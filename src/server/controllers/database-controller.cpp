/* GCompris - database-controller.h
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "database-controller.h"

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

#define DB_VERSION 10
#define SCHEMA_SQL ":/gcompris/src/server/database/create_tables.sql"
#define VIEWS_SQL ":/gcompris/src/server/database/create_views.sql"
#define PATCH_SQL ":/gcompris/src/server/database/patch_%1.sql"

static const char *AES_ALGORITHM = "aes128";
static const char *AES_ENCRYPTION = "aes128-cbc-pkcs7";
static const char *INITIALIZATION_VECTOR = "gcomprisInitialisationVector";

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

    DatabaseController::~DatabaseController()
    {
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
            for (int i = 0; i < requests.size(); i++) {
                QString req = requests.at(i).simplified();
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

    QString DatabaseController::decryptText(const QString &value)
    {
        return value; // TODO Implement
    }

    QString DatabaseController::encryptText(const QString &value)
    {
        return value; // TODO Implement
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

    bool DatabaseController::isCrypted()
    {
        return dbEncrypted;
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
            qWarning() << "Encrypted database:" << dbEncrypted;
            return true;
        }
    }

    void DatabaseController::triggerDBError(QSqlError sqlError, const QString &message)
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
            activityId = addActivity(activityName);
        }
        //    qWarning() << "Activity:" << activityName << rawData;
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

#include <QJsonDocument>
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

    int DatabaseController::addDataset(const QString &datasetName, const int activityId, const QString &objective, const int difficulty, const QString &content)
    {
        int datasetId = -1;
        QSqlQuery query(database);
        // since the dataset does not exist, create the new dataset and add description and users to it
        query.prepare("INSERT INTO dataset_ (dataset_name, activity_id, dataset_objective, dataset_difficulty, dataset_content) VALUES (:datasetName,:activityId,:objective,:difficulty,:content)");
        query.bindValue(":datasetName", datasetName);
        query.bindValue(":activityId", activityId);
        query.bindValue(":objective", objective);
        query.bindValue(":difficulty", difficulty);
        query.bindValue(":content", content);

        bool datasetAdded = query.exec();
        if (datasetAdded)
            datasetId = query.lastInsertId().toInt();
        else
            triggerDBError(query.lastError(), tr("Dataset <b>%1</b> already exists.").arg(datasetName));
        return datasetId;
    }

    /*int DatabaseController::updateDataset(const int datasetId, const QString &newDatasetName, const QString &datasetDescription)
    {
        QString encryptedName(newDatasetName);
        QString encryptedDesc(datasetDescription);
        if (dbEncrypted) {
            encryptedName = encryptText(newDatasetName);
            encryptedDesc = encryptText(datasetDescription);
        }
        QSqlQuery query(database);
        QString sqlStatement = "UPDATE dataset_ SET dataset_name=:newName, dataset_description=:desc WHERE dataset_id=:id";
        if (!query.prepare(sqlStatement))
            return false;
        query.bindValue(":id", datasetId);
        query.bindValue(":newName", encryptedName);
        query.bindValue(":desc", encryptedDesc);

        if (!query.exec()) {
            triggerDBError(query.lastError(), tr("Dataset <b>%1</b> could not be updated to <b>%2</b>.").arg(datasetId).arg(newDatasetName));
            return -1;
        }
        return datasetId;
    }*/

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
                            QStringList names = str.split(",");
                            for (int i = 0; i < names.size(); ++i) {
                                names[i] = decryptText(names[i]);
                            }
                            str = names.join(",");
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
