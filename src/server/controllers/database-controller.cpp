/* GCompris - database-controller.h
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "database-controller.h"

#include <openssl/evp.h>
#include <openssl/aes.h>
#include <openssl/err.h>

#include <QDebug>
#include <QCryptographicHash>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlDriver>
#include <QRegularExpression>
#include <QFileInfo>

#include "File.h"

#define DB_VERSION 13
#define SCHEMA_SQL ":/gcompris/src/server/database/create_tables.sql"
#define VIEWS_SQL ":/gcompris/src/server/database/create_views.sql"
#define PATCH_SQL ":/gcompris/src/server/database/patch_%1.sql"

static const char *AES_ENCRYPTION = "AES-128-CBC-CTS";
static const unsigned char INITIALIZATION_VECTOR[] = "gcomprisInitialisationVector";

static const char *COMMA_SEPARATOR = ",";
static const char *COMMA_CRYPTED_SEPARATOR = "=,,";
#include <iostream>

namespace controllers {

    DatabaseController::DatabaseController(QObject *parent) :
        QObject(parent),
        dbEncrypted(false),
        database(),
        error(),
        teacherPasswordKey()
    {
        cryptedFields << "user_name"
                      << "group_name"
                      << "group_description"
                      << "user_password";
        cryptedLists << "users_name"
                     << "groups_name";
    }

    bool DatabaseController::sqlCommands(const QString &sqlFile)
    {
        File sql;
        QString script = sql.read(sqlFile);
        QSqlQuery query(database);
        query.prepare("BEGIN TRANSACTION");
        query.exec();
        bool succeed = true;
        if (!script.isEmpty()) {
            qWarning() << "Processing:" << sqlFile;
            script.replace(QRegularExpression("^--.*$"), ""); // remove commented lines
            QStringList requests = script.split(";");
            for (const QString &request: requests) {
                QString req = request.simplified();
                if (!req.isEmpty()) {
                    if (query.prepare(req)) {
                        qWarning() << req;
                        if (!query.exec()) {
                            triggerDBError(query.lastError(), tr("File %1\nError SQL: %2").arg(sqlFile).arg(req));
                            succeed = false;
                            break;
                        }
                    }
                    else {
                        triggerDBError(query.lastError(), tr("File %1\nError SQL: %2").arg(sqlFile).arg(req));
                        qWarning() << "Error preparing:" << req;
                        succeed = false;
                        break;
                    }
                }
            }
        }
        else {
            succeed = false;
            qWarning() << "Empty sql file" << sqlFile;
        }
        if (succeed)
            query.prepare("COMMIT");
        else
            query.prepare("ROLLBACK");
        query.exec();
        return succeed;
    }

    void DatabaseController::checkDBVersion(int dbVersion)
    {
        if (DB_VERSION > dbVersion) {
            // apply patches
            bool succeed = true;
            while (succeed && (dbVersion < DB_VERSION)) {
                dbVersion++;
                succeed = succeed && sqlCommands(QString(PATCH_SQL).arg(dbVersion));
                if (succeed) {
                    qWarning() << "Patch" << dbVersion << "applied";
                    // Save new teacher_dbversion
                    QSqlQuery updateQuery(database);
                    updateQuery.prepare("UPDATE teacher_ SET teacher_dbversion=:version");
                    updateQuery.bindValue(":version", dbVersion);
                    if (!updateQuery.exec()) {
                        qWarning() << updateQuery.lastError() << "for" << updateQuery.lastQuery();
                        triggerDBError(updateQuery.lastError(), tr("Table teacher_ could not be updated to current version."));
                    }
                }
                else {
                    qWarning() << "Error processing patch" << dbVersion;
                }
            }
        }
    }

    bool DatabaseController::fileExists(const QString &databaseFile)
    {
        return QFileInfo::exists(databaseFile);
    }

    //------------ Methods moved from implementation
    bool DatabaseController::initialise(const QString &databaseFile)
    {
        database = QSqlDatabase::addDatabase("QSQLITE", "gcompris");
        bool isNew = !QFileInfo::exists(databaseFile);
        database.setDatabaseName(databaseFile);
        if (!database.open()) {
            qWarning() << "Error: connection with database fail";
        }
        else if (isNew) {
            sqlCommands(SCHEMA_SQL);
            sqlCommands(VIEWS_SQL);
            qWarning() << "Tables created in:" << databaseFile;
        }
        if (isDatabaseLocked()) {
            qWarning() << "Database" << databaseFile << "is locked";
            exit(-1); // Hard exit before writing error management.
        }
        return database.open();
    }

    QString DatabaseController::sqliteVersion() const
    {
        QSqlQuery query(database);

        query.exec("SELECT sqlite_version()");

        if (query.next())
            return query.value(0).toString();

        return QString::number(-1);
    }

    
    static void handleErrors(const char *where)
    {
        qDebug() << "An error occurred in" << where;
        while(unsigned long errCode = ERR_get_error()) {
            char *err = ERR_error_string(errCode, nullptr);
            qDebug() << "OpenSSL error:" << err << errCode;
        }
    }
    
    QString DatabaseController::decryptText(const QString &value)
    {
        if(value.isEmpty()) {
            return value;
        }
        QByteArray cipherData = value.toLatin1();
        cipherData.replace(COMMA_CRYPTED_SEPARATOR, COMMA_SEPARATOR);
        int cipherTextLength = cipherData.size();
        unsigned char* cipherText = (unsigned char*)cipherData.data();
        unsigned char* plainText = (unsigned char*) malloc(cipherTextLength + AES_BLOCK_SIZE);

        EVP_CIPHER_CTX *ctx = nullptr;
        int len = 0, plaintext_len = 0;

        /* Create and initialise the context */
        if(ctx = EVP_CIPHER_CTX_new(); !ctx) {
            handleErrors("EVP_CIPHER_CTX_new");
        }

        EVP_CIPHER *cipher = EVP_CIPHER_fetch(nullptr, AES_ENCRYPTION, nullptr);
        /* Initialise the decryption operation. */
        if(!EVP_DecryptInit_ex2(ctx, cipher, teacherPasswordKeyAsSha, INITIALIZATION_VECTOR, nullptr)) {
            handleErrors("EVP_DecryptInit_ex2");
        }

        /* Provide the message to be decrypted, and obtain the plaintext output.
         * EVP_DecryptUpdate can be called multiple times if necessary
         */
        if(cipherText) {
            if(!EVP_DecryptUpdate(ctx, plainText, &len, cipherText, cipherTextLength)) {
                handleErrors("EVP_DecryptUpdate");
            }

            plaintext_len = len;
        }

        /* Finalise the decryption. A positive return value indicates success,
         * anything else is a failure - the plaintext is not trustworthy.
         */
        EVP_DecryptFinal_ex(ctx, plainText + len, &len);

        plaintext_len += len;

        QByteArray out((char *) plainText, plaintext_len);
        out.replace("+++++++++++++++++", "");
        QByteArray base64 = QByteArray::fromBase64(out);
        QString ret = QString::fromUtf8(base64);

        /* Clean up */
        EVP_CIPHER_free(cipher);
        EVP_CIPHER_CTX_free(ctx);
        free(plainText);

        return ret;
    }

    QString DatabaseController::encryptText(const QString &value)
    {
        if(value.isEmpty()) {
            return value;
        }
        QByteArray plainData = value.toUtf8().toBase64();
        plainData.append("+++++++++++++++++");

        int plainTextLength = plainData.size();
        int cipherLength = plainTextLength;
        unsigned char* cipherText = (unsigned char*) malloc(cipherLength);
        unsigned char* plainText = (unsigned char*)plainData.data();

        EVP_CIPHER_CTX *ctx = nullptr;
        int len = 0, ciphertext_len = 0;

        /* Create and initialise the context */
        if(ctx = EVP_CIPHER_CTX_new(); !ctx) {
            handleErrors("EVP_CIPHER_CTX_new");
        }

        EVP_CIPHER *cipher = EVP_CIPHER_fetch(nullptr, AES_ENCRYPTION, nullptr);

        /* Initialise the encryption operation. */
        if(1 != EVP_EncryptInit_ex2(ctx, cipher, teacherPasswordKeyAsSha, INITIALIZATION_VECTOR, nullptr)) {
            handleErrors("EVP_EncryptInit_ex2");
        }

        /* Provide the message to be encrypted, and obtain the encrypted output.
         * EVP_EncryptUpdate can be called multiple times if necessary
         */
        if(plainText) {
            if(1 != EVP_EncryptUpdate(ctx, cipherText, &len, plainText, plainTextLength)) {
                handleErrors("EVP_EncryptUpdate");
            }
            ciphertext_len = len;
        }

        /* Finalise the encryption. Normally ciphertext bytes may be written at
         * this stage, but this does not occur in GCM mode
         */
        if(1 != EVP_EncryptFinal_ex(ctx, cipherText + len, &len)) {
            handleErrors("EVP_EncryptFinal_ex");
        }
        ciphertext_len += len;

        QByteArray out((char *) cipherText, ciphertext_len);
    
        /* Clean up */
        EVP_CIPHER_free(cipher);
        EVP_CIPHER_CTX_free(ctx);
        free(cipherText);

        out.replace(COMMA_SEPARATOR, COMMA_CRYPTED_SEPARATOR);
        return QString::fromLatin1(out);
    }

    bool DatabaseController::isDatabaseLoaded()
    {
        return QSqlDatabase::contains("gcompris");
    }

    void DatabaseController::unloadDatabase()
    {
        if (QSqlDatabase::contains("gcompris")) {
            database.close();
            database = QSqlDatabase();
            QSqlDatabase::removeDatabase("gcompris");
        }
    }

    void DatabaseController::setKey(const QString &teacherKey)
    {
        teacherPasswordKey = teacherKey;
        QByteArray base64 = teacherPasswordKey.toUtf8().toBase64();
        SHA256((unsigned char*)base64.data(), base64.size(), teacherPasswordKeyAsSha);
    }

    bool DatabaseController::isDatabaseLocked()
    {
        bool locked = true;
        database.setConnectOptions("QSQLITE_BUSY_TIMEOUT=0");
        QSqlQuery query(database);
        if (query.exec("BEGIN EXCLUSIVE")) { // tries to acquire the lock
            query.exec("COMMIT"); // releases the lock immediately
            locked = false; // db is not locked
        }
        database.setConnectOptions("QSQLITE_BUSY_TIMEOUT=30000"); // restore default timeout
        return locked;
    }

    //------------
    void DatabaseController::loadDatabase(const QString &databaseFile)
    {
        qWarning() << "Load database: " << databaseFile;
        initialise(databaseFile);
    }

    bool DatabaseController::createTeacher(const QString &login, const QString &password, const bool crypted)
    {
        QByteArray hashResult = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256);
        QString encryptedPassword = QString(hashResult.toHex());

        QSqlQuery query(database);
        query.prepare("INSERT INTO teacher_ (teacher_login, teacher_password, teacher_dbversion, teacher_dbcrypted) VALUES(:login, :password, :version, :crypted)");
        query.bindValue(":login", login);
        query.bindValue(":password", encryptedPassword);
        query.bindValue(":version", DB_VERSION);
        query.bindValue(":crypted", crypted);
        qWarning() << query.lastQuery();
        if (!query.exec()) {
            qWarning() << query.lastError();
            triggerDBError(query.lastError(), tr("Error creating teacher."));
            return false;
        }
        dbEncrypted = crypted;
        cryptedChanged();
        qWarning() << "Encrypted database:" << dbEncrypted;
        setKey(password);
        return true;
    }

    bool DatabaseController::checkTeacher(const QString &login, const QString &password)
    {
        QByteArray hashResult = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256);
        QString encryptedPassword = QString(hashResult.toHex());

        QSqlQuery query(database);
        query.prepare("SELECT * FROM teacher_ WHERE teacher_login=:login AND teacher_password=:password");
        query.bindValue(":login", login);
        query.bindValue(":password", encryptedPassword);
        query.exec();
        if (!query.next()) {
            qWarning() << "login " << login << " does not already exist or incorrect password";
            triggerDBError(query.lastError(), tr("Wrong password."));
            setKey("");
            return false;
        }
        else {
            // We successfully logged as 'login', we use 'password' as key
            setKey(password);
            checkDBVersion(query.record().value("teacher_dbversion").toInt());
            QVariant dbCryptVariant = query.record().value("teacher_dbcrypted");
            dbEncrypted = (dbCryptVariant.isValid()) ? (dbCryptVariant.toInt() != 0) : false;
            cryptedChanged();
            qWarning() << "Encrypted database:" << dbEncrypted;
            return true;
        }
    }

    void DatabaseController::triggerDBError(const QSqlError &sqlError, const QString &message)
    {
        //    if (sqlError.nativeErrorCode().toInt() != SQLITE_CONSTRAINT)
        //        message = tr("Sql error type: %1").arg(sqlError.nativeErrorCode());
        Q_EMIT dbError(QStringList()
                       << message
                       << sqlError.driverText()
                       << sqlError.databaseText());
    }

    int DatabaseController::addGroup(const QString &groupName, const QString &description, const QStringList &users)
    {
        int groupId = -1;
        QString encryptedName(groupName);
        QString encryptedDesc(description);
        if (dbEncrypted) {
            encryptedName = encryptText(groupName);
            encryptedDesc = encryptText(description);
        }
        QSqlQuery query(database);
        // since the group does not exist, create the new group and add description and users to it
        query.prepare("INSERT INTO group_ (group_name, group_description) VALUES (:groupName,:description)");
        query.bindValue(":groupName", encryptedName);
        query.bindValue(":description", encryptedDesc);
        bool groupAdded = query.exec();
        if (groupAdded)
            groupId = query.lastInsertId().toInt();
        else
            triggerDBError(query.lastError(), tr("Group <b>%1</b> already exists.").arg(groupName));
        return groupId;
    }

    int DatabaseController::updateGroup(const int groupId, const QString &newGroupName, const QString &groupDescription)
    {
        QString encryptedName(newGroupName);
        QString encryptedDesc(groupDescription);
        if (dbEncrypted) {
            encryptedName = encryptText(newGroupName);
            encryptedDesc = encryptText(groupDescription);
        }
        QSqlQuery query(database);
        QString sqlStatement = "UPDATE group_ SET group_name=:newName, group_description=:desc WHERE group_id=:id";
        if (!query.prepare(sqlStatement))
            return false;
        query.bindValue(":id", groupId);
        query.bindValue(":newName", encryptedName);
        query.bindValue(":desc", encryptedDesc);

        if (!query.exec()) {
            triggerDBError(query.lastError(), tr("Group <b>%1</b> could not be updated to <b>%2</b>.").arg(groupId).arg(newGroupName));
            return -1;
        }
        return groupId;
    }

    bool DatabaseController::deleteGroup(const int groupId, const QString &groupName)
    {
        bool groupDeleted = false;
        QSqlQuery query(database);
        query.prepare("DELETE FROM group_user_ WHERE group_id=:gid"); // Delete group_user_ rows first
        query.bindValue(":gid", groupId);
        if (query.exec()) {
            query.prepare("DELETE FROM group_ WHERE group_id=:gid");
            query.bindValue(":gid", groupId);
            if (query.exec())
                groupDeleted = true;
            else
                triggerDBError(query.lastError(), tr("Group <b>%1</b> could not be deleted from table group_.").arg(groupName));
        }
        else
            triggerDBError(query.lastError(), tr("Group <b>%1</b> could not be deleted from table group_user_.").arg(groupName));
        return groupDeleted;
    }

    int DatabaseController::addUser(const QString &userName, const QString &userPass)
    {
        int userId = -1;
        QString password = userPass;
        if (password == "")
            password = "apple"; // default password if empty (when importing)
        QString encryptedName(userName);
        QString encryptedPass(password);
        if (dbEncrypted) {
            encryptedName = encryptText(userName);
            encryptedPass = encryptText(password);
        }
        QSqlQuery query(database);
        query.prepare("INSERT INTO user_ (user_name, user_password) VALUES(:name, :password)");
        query.bindValue(":name", encryptedName);
        query.bindValue(":password", encryptedPass);
        bool userAdded = query.exec();
        if (userAdded)
            userId = query.lastInsertId().toInt();
        else
            triggerDBError(query.lastError(), tr("Pupil login <b>%1</b> already exists or password is empty.").arg(userName));
        return userId;
    }

    bool DatabaseController::updateUser(const int userId, const QString &userName, const QString &userPass)
    {
        QString encryptedName(userName);
        QString encryptedPass(userPass);
        if (dbEncrypted) {
            encryptedName = encryptText(userName);
            encryptedPass = encryptText(userPass);
        }
        QSqlQuery updateQuery(database);
        updateQuery.prepare("UPDATE user_ SET user_name=:name, user_password=:password WHERE user_id=:id");
        updateQuery.bindValue(":name", encryptedName);
        updateQuery.bindValue(":password", encryptedPass);
        updateQuery.bindValue(":id", userId);
        if (!updateQuery.exec()) {
            qWarning() << updateQuery.lastError() << "for" << updateQuery.lastQuery();
            triggerDBError(updateQuery.lastError(), tr("<b>%1</b> could not be updated to <b>%2</b>.").arg(userId).arg(userName));
            return false;
        }
        return true;
    }

    bool DatabaseController::deleteUser(const int userId)
    {
        bool userDeleted = false;
        QSqlQuery query(database);
        query.prepare("DELETE FROM result_ WHERE user_id=:id"); // delete from result
        query.bindValue(":id", userId);
        if (query.exec()) {
            if (removeAllGroupsForUser(userId)) { // delete from group_user_
                query.prepare("DELETE FROM user_ WHERE user_id=:id"); // delete from user_
                query.bindValue(":id", userId);
                if (query.exec()) {
                    userDeleted = true;
                }
                else {
                    triggerDBError(query.lastError(), tr("User <b>%1</b> could not be deleted from table user_.").arg(userId));
                }
            }
        }
        else {
            triggerDBError(query.lastError(), tr("User <b>%1</b> could not be deleted from table result_.").arg(userId));
        }
        return userDeleted;
    }

    bool DatabaseController::removeAllGroupsForUser(const int userId)
    {
        bool groupsRemoved = false;
        QSqlQuery query(database);
        query.prepare("DELETE FROM group_user_ WHERE user_id=:id");
        query.bindValue(":id", userId);
        if (query.exec()) {
            groupsRemoved = true;
        }
        else {
            triggerDBError(query.lastError(), tr("User <b>%1</b> could not be deleted from table group_user_.").arg(userId));
        }
        return groupsRemoved;
    }

    bool DatabaseController::addUserToGroup(const int userId, const int groupId)
    {
        // insert in table group_user_
        bool userAdded = false;
        QSqlQuery query(database);
        query.prepare("INSERT INTO group_user_ (user_id, group_id) values(:userId,:groupId)");
        query.bindValue(":userId", userId);
        query.bindValue(":groupId", groupId);
        userAdded = query.exec();
        if (!userAdded) {
            triggerDBError(query.lastError(), tr("User <b>%1</b> already exists in group <b>%2</b>.").arg(userId).arg(groupId));
        }
        return userAdded;
    }

    bool DatabaseController::removeUserGroup(const int userId, const int groupId)
    {
        bool userGroupRemoved = false;
        QSqlQuery query(database);
        query.prepare("DELETE FROM group_user_ WHERE user_id=:id and group_id=:group");
        query.bindValue(":id", userId);
        query.bindValue(":group", groupId);
        query.exec();
        userGroupRemoved = query.exec();
        if (!userGroupRemoved) {
            triggerDBError(query.lastError(), tr("User <b>%1</b> group <b>%2</b> couldn't be deleted.").arg(userId).arg(groupId));
        }
        return userGroupRemoved;
    }

    bool DatabaseController::addDataToUser(const int userId, const QString &activityName, const QString &rawData, const bool success, const int duration)
    {
        QString name = activityName.split("/").at(0); // Keep only activity's directory name
        // insert into table result_
        bool dataAdded = false;
        int activityId = -1;
        QSqlQuery query(database);

        // Check for existing activity
        query.prepare("SELECT activity_id FROM activity_ WHERE activity_name=:activity");
        query.bindValue(":activity", name);
        if (query.exec()) {
            while (query.next()) { //  empty result will let activityId to -1
                activityId = query.value("activity_id").toInt();
            }
        }
        if (activityId == -1) { // add new activity
            activityId = addActivity(name);
            activityAdded();
        }
        //    qWarning() << "Activity:" << name << rawData;
        // add new result to database
        query.prepare("INSERT INTO result_ (user_id, activity_id, result_data, result_success, result_duration) values(:user,:activity, :data, :success, :duration)");
        query.bindValue(":user", userId);
        query.bindValue(":activity", activityId);
        query.bindValue(":data", rawData);
        query.bindValue(":success", success ? 1 : 0);
        query.bindValue(":duration", duration);
        dataAdded = query.exec();
        if (!dataAdded) { // In case of multiple errors, next line should raise a problem.
            triggerDBError(query.lastError(), tr("Result could not be added for user <b>%1</b>").arg(userId));
        }
        return dataAdded;
    }

    int DatabaseController::addActivity(const QString &activityName) {
        QSqlQuery query(database);
        query.prepare("INSERT INTO activity_ (activity_name) VALUES(:activity)");
        query.bindValue(":activity", activityName);
        if (query.exec())
            return query.lastInsertId().toInt();
        else {
            triggerDBError(query.lastError(), tr("Error inserting activity: %1").arg(activityName));
            return -1;
        }
    }

    // QMap with key the date?
    QList<QVariant> DatabaseController::getActivityData(const int userId, const QString &activityName /*, range of date*/)
    {
        QSqlQuery query(database);
        query.prepare("SELECT * FROM result_ WHERE user_id IN (:uid) AND activity_name IN (:activity)");
        query.bindValue(":uid", userId);
        query.bindValue(":activity", activityName);
        query.exec();
        const int dataIndex = query.record().indexOf("data");
        const int dateIndex = query.record().indexOf("date");
        QList<QVariant> fetchedData;
        qWarning() << "Found" << query.size() << "records";
        while (query.next()) {
            QVariant data = query.value(dataIndex);
            QJsonDocument doc = QJsonDocument::fromJson(data.toByteArray());
            QJsonObject obj = doc.object();
            obj["date"] = query.value(dateIndex).toLongLong();
            doc.setObject(obj);
            QVariant dataWithDate = doc.toJson(QJsonDocument::Compact);
            fetchedData << dataWithDate;
        }
        return fetchedData;
    }

    int DatabaseController::addDataset(const QString &datasetName, const int activityId, const QString &objective, const int difficulty, const QString &content, const bool isCreatedByUser)
    {
        int datasetId = -1;
        QSqlQuery query(database);
        // since the dataset does not exist, create the new dataset and add description and users to it
        query.prepare("INSERT INTO dataset_ (dataset_name, activity_id, dataset_objective, dataset_difficulty, dataset_content, is_created_dataset) VALUES (:datasetName,:activityId,:objective,:difficulty,:content,:isCreatedByUser)");
        query.bindValue(":datasetName", datasetName);
        query.bindValue(":activityId", activityId);
        query.bindValue(":objective", objective);
        query.bindValue(":difficulty", difficulty);
        query.bindValue(":content", content);
        query.bindValue(":isCreatedByUser", isCreatedByUser);

        bool datasetAdded = query.exec();
        if (datasetAdded)
            datasetId = query.lastInsertId().toInt();
        else
            triggerDBError(query.lastError(), tr("Dataset <b>%1</b> already exists.").arg(datasetName));
        return datasetId;
    }

    int DatabaseController::updateDataset(const int datasetId, const QString &datasetName, const QString &objective, const int difficulty, const QString &content)
    {
        // No need to update is_created_dataset because we can only update created datasets, not internal ones
        QSqlQuery query(database);
        QString sqlStatement = "UPDATE dataset_ SET dataset_name=:datasetName, dataset_objective=:objective, dataset_difficulty=:difficulty, dataset_content=:content WHERE dataset_id=:id";
        if (!query.prepare(sqlStatement))
            return false;
        query.bindValue(":id", datasetId);
        query.bindValue(":datasetName", datasetName);
        query.bindValue(":objective", objective);
        query.bindValue(":difficulty", difficulty);
        query.bindValue(":content", content);

        if (!query.exec()) {
            triggerDBError(query.lastError(), tr("Dataset <b>%1</b> could not be updated to <b>%2</b>.").arg(datasetId).arg(datasetName));
            return -1;
        }
        return datasetId;
    }

    bool DatabaseController::deleteDataset(const int datasetId)
    {
        bool datasetRemoved = false;
        QSqlQuery query(database);
        query.prepare("DELETE FROM dataset_ WHERE dataset_id=:id");
        query.bindValue(":id", datasetId);
        query.exec();
        datasetRemoved = query.exec();
        if (!datasetRemoved) {
            triggerDBError(query.lastError(), tr("Dataset <b>%1</b> couldn't be deleted.").arg(datasetId));
        }
        return datasetRemoved;
    }

    int DatabaseController::addSequence(const QString &sequenceName, const QString &objective, const QVariantList &sequenceList)
    {
        int sequenceId = -1;
        QSqlQuery query(database);
        query.prepare("INSERT INTO sequence_ (sequence_name, sequence_objective) VALUES (:sequenceName, :objective)");
        query.bindValue(":sequenceName", sequenceName);
        query.bindValue(":objective", objective);
        if (query.exec()) {
            sequenceId = query.lastInsertId().toInt();
        }
        else {
            triggerDBError(query.lastError(), tr("Error inserting sequence in table sequence_: <b>%1</b>.").arg(sequenceName));
            return sequenceId;
        }
        int rank = 0;
        for (const QVariant &elt: sequenceList) {
            QVariantMap sequence = elt.toMap();
            query.prepare("INSERT INTO activity_with_datasets_ (activity_id, dataset_id) VALUES (:activityId, :datasetId)");
            query.bindValue(":activityId", sequence["activity_id"].toInt());
            query.bindValue(":datasetId", sequence["dataset_id"].toInt());
            if (query.exec()) {
                int act_dat_id = query.lastInsertId().toInt();
                query.prepare("INSERT INTO sequence_with_activity_ (sequence_id, activity_with_data_id, activity_rank) VALUES (:sequenceId, :activityWithDatasetId, :activityRank)");
                query.bindValue(":sequenceId", sequenceId);
                query.bindValue(":activityWithDatasetId", act_dat_id);
                query.bindValue(":activityRank", rank);
                if (query.exec()) {
                    int seq_act_id = query.lastInsertId().toInt();
                }
            }
            rank ++;
        }
        return sequenceId;
    }

    /*int DatabaseController::updateSequence(const int sequenceId, const QString &sequenceName, const QString &objective)
    {
        QSqlQuery query(database);
        return sequenceId;
    }*/

    bool DatabaseController::deleteSequence(const int sequenceId)
    {
        bool sequenceRemoved = false;
        QSqlQuery query(database);
        query.prepare("DELETE FROM activity_with_datasets_ WHERE act_dat_id IN ( SELECT act_dat_id FROM activity_with_datasets_ a INNER JOIN sequence_with_activity_ b ON a.act_dat_id=b.activity_with_data_id WHERE b.sequence_id=:id );");
        query.bindValue(":id", sequenceId);
        if (query.exec()) {
            query.prepare("DELETE FROM sequence_with_activity_ WHERE sequence_id=:id");
            query.bindValue(":id", sequenceId);
            if(query.exec()) {
                query.prepare("DELETE FROM sequence_ WHERE sequence_id=:id");
                query.bindValue(":id", sequenceId);
                if (query.exec())
                    sequenceRemoved = true;
                else
                    triggerDBError(query.lastError(), tr("Sequence <b>%1</b> could not be deleted from table sequence_.").arg(sequenceId));
                sequenceRemoved = query.exec();
            }
            else {
                triggerDBError(query.lastError(), tr("Sequence <b>%1</b> couldn't be deleted from table sequence_with_activity_.").arg(sequenceId));
            }
        }
        else {
            triggerDBError(query.lastError(), tr("Sequence <b>%1</b> couldn't be deleted from table activity_with_datasets_.").arg(sequenceId));
        }
        return sequenceRemoved;
    }

    /*----------------------------------------------*/
    // Following functions has not be updated for error management because they are not used for now.
    bool DatabaseController::createRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const
    {
        if (tableName.isEmpty())
            return false;
        if (id.isEmpty())
            return false;
        if (jsonObject.isEmpty())
            return false;

        QSqlQuery query(database);

        QString sqlStatement = "INSERT OR REPLACE INTO " + tableName + " (id, json) VALUES (:id, :json)";

        if (!query.prepare(sqlStatement))
            return false;

        query.bindValue(":id", QVariant(id));
        query.bindValue(":json", QVariant(QJsonDocument(jsonObject).toJson(QJsonDocument::Compact)));

        if (!query.exec())
            return false;

        return query.numRowsAffected() > 0;
    }

    bool DatabaseController::deleteRow(const QString &tableName, const QString &id) const
    {
        if (tableName.isEmpty())
            return false;
        if (id.isEmpty())
            return false;

        QSqlQuery query(database);

        QString sqlStatement = "DELETE FROM " + tableName + " WHERE id=:id";

        if (!query.prepare(sqlStatement))
            return false;

        query.bindValue(":id", QVariant(id));

        if (!query.exec())
            return false;

        return query.numRowsAffected() > 0;
    }

    QJsonArray DatabaseController::find(const QString &tableName, const QString &searchText) const
    {
        if (tableName.isEmpty())
            return {};
        if (searchText.isEmpty())
            return {};

        QSqlQuery query(database);

        QString sqlStatement = "SELECT json FROM " + tableName + " where lower(json) like :searchText";

        if (!query.prepare(sqlStatement))
            return {};

        query.bindValue(":searchText", QVariant("%" + searchText.toLower() + "%"));

        if (!query.exec())
            return {};

        QJsonArray returnValue;

        while (query.next()) {
            auto json = query.value(0).toByteArray();
            auto jsonDocument = QJsonDocument::fromJson(json);
            if (jsonDocument.isObject()) {
                returnValue.append(jsonDocument.object());
            }
        }

        return returnValue;
    }

    QJsonObject DatabaseController::readRow(const QString &tableName, const QString &id) const
    {
        if (tableName.isEmpty())
            return {};
        if (id.isEmpty())
            return {};

        QSqlQuery query(database);

        QString sqlStatement = "SELECT json FROM " + tableName + " WHERE id=:id";

        if (!query.prepare(sqlStatement))
            return {};

        query.bindValue(":id", QVariant(id));

        if (!query.exec())
            return {};

        if (!query.first())
            return {};

        auto json = query.value(0).toByteArray();
        auto jsonDocument = QJsonDocument::fromJson(json);

        if (!jsonDocument.isObject())
            return {};

        return jsonDocument.object();
    }

    bool DatabaseController::updateRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const
    {
        if (tableName.isEmpty())
            return false;
        if (id.isEmpty())
            return false;
        if (jsonObject.isEmpty())
            return false;

        QSqlQuery query(database);

        QString sqlStatement = "UPDATE " + tableName + " SET json=:json WHERE id=:id";

        if (!query.prepare(sqlStatement))
            return false;

        query.bindValue(":id", QVariant(id));
        query.bindValue(":json", QVariant(QJsonDocument(jsonObject).toJson(QJsonDocument::Compact)));

        if (!query.exec())
            return false;

        return query.numRowsAffected() > 0;
    }

    int DatabaseController::doRequest(const QString &req)
    {
        QSqlQuery query(database);
        query.prepare(req);
        if (query.exec()) {
            return 0;
        }
        else {
            triggerDBError(query.lastError(), req);
            return -1;
        }
    }

    // TODO: split function not used, replaced by QString.split(RegExp) in selectToJson... Remove it ?
    /**
       Let's assume we have a string `in` #<¿BILY/ú\u007F¯á\u000Eã\u0005S\u007FÁoktn/Ã\u0090,Ô&?m&\u009A4ùQë¤=,,!ãB¤:64È*
       We want to split on "," but not on "=,,"
       First step is to split on "=,," => QList("#<¿BILY/ú\u007F¯á\u000Eã\u0005S\u007FÁoktn/Ã\u0090,Ô&?m&\u009A4ùQë¤", "!ãB¤:64È*")
       Second step to split the list on "," => QList(QList("#<¿BILY/ú\u007F¯á\u000Eã\u0005S\u007FÁoktn/Ã\u0090", "Ô&?m&\u009A4ùQë¤"), QList("!ãB¤:64È*"))
       Then we can merge back the list on one list and we join the last element of each list with the first one of the next list using the exclude separator =>
       QList("#<¿BILY/ú\u007F¯á\u000Eã\u0005S\u007FÁoktn/Ã\u0090", "Ô&?m&\u009A4ùQë¤=,,!ãB¤:64È*")
       We have splitted the original string with the correct separator!

       This is used as the strings in the db are joined by `,`. However, with the crypting, we can have `,` in the output. Thus, we first modify the `,` in the crypted strings to `=,,` so we are sure everytime we face a `=,,` it should be converted back to a `,` and the change is reversible (we cannot have a single `,` in the crypted string, and `=,,` is always a `,`, as if we had `=,,` in the original crypted string, it would be converted to `==,,=,,`).
     */
    QStringList split(const QString &in, const QString &separator, const QString &exclude) {
        QStringList splittedByExcluded = in.split(exclude);
        QList<QStringList> splittedBySeparator;
        for(int i = 0; i < splittedByExcluded.size(); ++ i) {
            splittedBySeparator.push_back(splittedByExcluded[i].split(separator));
        }
        QStringList out;
        QString lastElementOfPreviousList;
        for(int i = 0; i < splittedBySeparator.size(); ++ i) {
            const QStringList &list = splittedBySeparator[i];
            for(int j = 0 ; j < list.size(); ++ j) {
                QString atomicElement = list[j];
                if(i != 0 && j == 0) {
                    QString element = lastElementOfPreviousList + QString(COMMA_CRYPTED_SEPARATOR) + atomicElement;
                    out << element;
                }
                else if(j < list.size() - 1) {
                    out << atomicElement;
                }
                else {
                    lastElementOfPreviousList = atomicElement;
                }
            }
        }
        return out;
    }
    // Code based on: https://stackoverflow.com/questions/18058936/qt-qsqlquery-return-in-json
    // Execute request and returns a json array of objects as a string.
    // Decrypt fields contained in cryptedFields and cryptedLists
    QString DatabaseController::selectToJson(const QString &req)
    {
        if (!database.isOpen())
            return "{}";
        QSqlQuery query(database);
        //    qWarning() << req;
        query.prepare(req);
        query.setForwardOnly(true);
        if (query.exec()) {
            QJsonDocument json;
            QJsonArray recordsArray;
            while (query.next()) {
                QJsonObject recordObject;
                for (int x = 0; x < query.record().count(); x++) {
                    QString field = query.record().fieldName(x);
                    QVariant value = query.value(x);
                    if (dbEncrypted) {
                        if (cryptedFields.contains(field)) { // decrypt single field
                            value = QVariant::fromValue(decryptText(value.toString()));
                        }
                        else if (cryptedLists.contains(field)) { // decrypt merged fields
                            QString str = value.toString();
                            //// test string, after split should return QList("abc=,,", "def=", "ghi", "=jkl=,,mno", "pqr")
                            // QString str = "abc=,,,def=,ghi,=jkl=,,mno,pqr";
                            //// RegExp: a "," not preceded by "=,", and not followed by ","
                            QStringList names =  str.split(QRegularExpression("(?<!(=,)),(?!(,))"));
                            // QString joinedList = names.join(", ");
                            // qDebug() << "split original string" << joinedList;
                            // QString targetString = "abc=,,, def=, ghi, =jkl=,,mno, pqr";
                            // if(joinedList == targetString) {
                            //     qDebug() << "SUCCESS!!!";
                            // } else {
                            //     qDebug() << "split failed...";
                            // }
                            for (int i = 0; i < names.size(); ++i) {
                                names[i] = decryptText(names[i]);
                            }
                            str = names.join(", ");
                            value = QVariant::fromValue(str);
                        }
                    }
                    recordObject.insert(field, QJsonValue::fromVariant(value));
                }
                recordsArray.append(recordObject);
            }
            json.setArray(recordsArray);
            return json.toJson();
        }
        else {
            triggerDBError(query.lastError(), req);
            return "";
        }
    }
}
