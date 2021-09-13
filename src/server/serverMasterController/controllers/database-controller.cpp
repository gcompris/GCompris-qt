#include "database-controller.h"

#include <QDebug>
#include <QJsonDocument>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include "models/GroupData.h"
#include "models/UserData.h"

#define CREATE_TABLE_USERS \
    "CREATE TABLE IF NOT EXISTS users (user_name TEXT PRIMARY KEY NOT NULL, dateOfBirth TEXT, password TEXT); "
#define CREATE_TABLE_GROUPS \
    "CREATE TABLE IF NOT EXISTS groups (group_name TEXT PRIMARY KEY NOT NULL, description TEXT); "
#define CREATE_TABLE_USERGROUP \
    "CREATE TABLE IF NOT EXISTS group_users(user_name TEXT NOT NULL, group_name TEXT NOT NULL)"

#define CREATE_TABLE_ACTIVITY_DATA \
    "CREATE TABLE IF NOT EXISTS activity_data(user_name TEXT NOT NULL, activity_name TEXT NOT NULL, " \
    "date TEXT NOT NULL,data TEXT NOT NULL,PRIMARY KEY(user_name,activity_name,date))"

namespace cm {
namespace controllers {

    class DatabaseController::Implementation
    {
    public:
        Implementation(DatabaseController *_databaseController) :
            databaseController(_databaseController)
        {
            if (initialise()) {
                qDebug() << "Database created using Sqlite version: " + sqliteVersion();
                if (createTables()) {
                    qDebug() << "Database tables created";
                }
                else {
                    qDebug() << "ERROR: Unable to create database tables";
                }
            }
            else {
                qDebug() << "ERROR: Unable to open database";
            }
        }

        DatabaseController *databaseController { nullptr };
        QSqlDatabase database;

    private:
        bool initialise()
        {
            database = QSqlDatabase::addDatabase("QSQLITE", "gcompris");
            database.setDatabaseName("gcompris-qt.sqlite");
            if (!database.open()) {
                qDebug() << "Error: connection with database fail";
            }
            createTables();

            return database.open();
        }

        bool createTables()
        {
            bool res = createTable(CREATE_TABLE_USERS, "users");
            res &= createTable(CREATE_TABLE_GROUPS, "groups");
            res &= createTable(CREATE_TABLE_USERGROUP, "userGroups");
            res &= createTable(CREATE_TABLE_ACTIVITY_DATA, "activityData");
            return res;
        }

        bool createTable(const QString &sqlStatement, const QString &table) const
        {
            QSqlQuery query(database);

            if (!query.prepare(sqlStatement))
                return false;
            if(!query.exec()) {
                qDebug() << "Unable to create table " << table;
            }
            return true;
        }

        QString sqliteVersion() const
        {
            QSqlQuery query(database);

            query.exec("SELECT sqlite_version()");

            if (query.next())
                return query.value(0).toString();

            return QString::number(-1);
        }
    };
}

namespace controllers {

    DatabaseController::DatabaseController(QObject *parent) :
        IDatabaseController(parent)
    {
        implementation.reset(new Implementation(this));
    }

    DatabaseController::~DatabaseController()
    {
    }

    void DatabaseController::retrieveAllExistingGroups(QList<GroupData *> &allGroups)
    {
        // Don't add twice the same login
        QSqlQuery query(implementation->database);
        query.prepare("SELECT * FROM groups");
        query.exec();
        const int nameIndex = query.record().indexOf("group_name");
        const int descriptionIndex = query.record().indexOf("description");
        while(query.next()) {
            GroupData *g = new GroupData();
            g->setName(query.value(nameIndex).toString());
            g->setDescription(query.value(descriptionIndex).toString());
            allGroups.push_back(g);
        }
    }

    bool DatabaseController::addGroup(const QString &groupName, const QString& description, const QStringList& users)
    {
        bool groupAdded = false;
        QSqlQuery query(implementation->database);
        // add group to db only if it has not been added before
        query.prepare("SELECT group_name FROM groups WHERE group_name=:groupName");
        query.bindValue(":groupName", groupName);
        query.exec();
        if(query.next()) {
            qDebug()<< "group "<< groupName << " already exists";
            return false;
        }
        // since the group does not exist, create the new group and add description and users to it
        query.prepare("INSERT INTO groups (group_name, description) VALUES (:groupName,:description)");
        query.bindValue(":groupName", groupName);
        query.bindValue(":description",description);
        groupAdded = query.exec();
        if(groupAdded) {
            //add users to the group
            for(const auto &user: users) {
                //addUserToGroup(groupName, user);
            }
        }
        else
            qDebug()<<"group could not be added " <<  query.lastError();

        return groupAdded;
    }

    bool DatabaseController::updateGroup(const QString &oldGroupName, const QString& newGroupName)
    {
        bool groupUpdated = false;
        QSqlQuery query(implementation->database);

        QString sqlStatement = "UPDATE groups SET group_name=:newName WHERE group_name=:name";

        if (!query.prepare(sqlStatement))
            return false;

        query.bindValue(":name", oldGroupName);
        query.bindValue(":newName", newGroupName);

        if (!query.exec()) {
            qDebug()<<"group" << oldGroupName << "could not be updated to" << newGroupName << ": " << query.lastError();
            return false;
        }

        return query.numRowsAffected() > 0;
    }

    bool DatabaseController::deleteGroup(const QString &groupName)
    {
        bool groupDeleted = false;
        QSqlQuery query(implementation->database);
        query.prepare("DELETE FROM groups WHERE group_name=:gname");
        query.bindValue(":gname", groupName);
        if(query.exec()) {
            query.prepare("DELETE FROM group_users WHERE group_name=:gname");
            query.bindValue(":gname", groupName);
            if(query.exec())
                groupDeleted = true;
        }
        return groupDeleted;
    }

    void DatabaseController::retrieveAllExistingUsers(QList <UserData *> &allUsers)
    {
        QSqlQuery query(implementation->database);
        query.prepare("SELECT * FROM users");
        query.exec();
        const int nameIndex = query.record().indexOf("user_name");
        const int dateIndex = query.record().indexOf("dateOfBirth");
        const int passwordIndex = query.record().indexOf("password");
        while(query.next()) {
            UserData *u = new UserData();
            u->setName(query.value(nameIndex).toString());
            u->setDateOfBirth(query.value(dateIndex).toString());
            u->setPassword(query.value(passwordIndex).toString());
            //retrieveActivityData(u);
            allUsers.push_back(u);
        }
    }

    bool DatabaseController::addUser(const UserData& user)
    {
        // check whether user already exists before adding to database
        bool userAdded = false;
        QSqlQuery query(implementation->database);
        query.prepare("SELECT user_name FROM users WHERE user_name=:name");
        query.bindValue(":name", user.getName());
        query.exec();
        if(query.next()) {
            qDebug() << "user " << user.getName() << "already exists";
            return false;
        }
        query.prepare("INSERT INTO users (user_name, dateOfBirth, password) VALUES(:name, :dateOfBirth, :password)");
        query.bindValue(":name", user.getName());
        query.bindValue(":dateOfBirth", user.getDateOfBirth());
        query.bindValue(":password", user.getPassword());
        userAdded = query.exec();
        if(!userAdded) {
            qDebug()<< query.lastError();
        }

        return userAdded;
    }

    bool DatabaseController::deleteUser(const QString& name)
    {
        bool userDeleted = false;
        QSqlQuery query(implementation->database);
        query.prepare("DELETE FROM users WHERE user_name=:name");
        query.bindValue(":name", name);
        if(query.exec()) {
            query.prepare("DELETE FROM group_users WHERE user_name=:name");
            query.bindValue(":name",name);
            if(query.exec()) {
            
                query.prepare("DELETE FROM activity_data WHERE user_name=:name");
                query.bindValue(":name",name);
                if(query.exec()) {
                    userDeleted = true;
                }
                else {
                    qDebug() << query.executedQuery() << " failed";
                }
            }
            else {
                qDebug() << query.executedQuery() << " failed";
            }
        }
        else {
            qDebug() << query.executedQuery() << " failed";
        }
        return userDeleted;
    }

    bool DatabaseController::addUserToGroup(const QString& user, const QString& group)
    {
        // insert in table group_users
        // add (user, group) to db only if they don't exist
        bool userAdded = false;
        QSqlQuery query(implementation->database);
        query.prepare("SELECT * FROM group_users WHERE user_name=:user and group_name=:group");
        query.bindValue(":user",user);
        query.bindValue(":group",group);
        query.exec();
        if(query.next()) {
            qDebug() << "user " << user << "already exists in group " << group;
            return false;
        }
        query.prepare("INSERT INTO group_users (user_name, group_name) values(:user,:group)");
        query.bindValue(":user",user);
        query.bindValue(":group",group);
        userAdded = query.exec();
        if(!userAdded) {
            qDebug() << "user could not be added "<< query.lastError();
        }
        return userAdded;

    }

    /*----------------------------------------------*/
    bool DatabaseController::createRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const
    {
        if (tableName.isEmpty())
            return false;
        if (id.isEmpty())
            return false;
        if (jsonObject.isEmpty())
            return false;

        QSqlQuery query(implementation->database);

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

        QSqlQuery query(implementation->database);

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

        QSqlQuery query(implementation->database);

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

        QSqlQuery query(implementation->database);

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

        QSqlQuery query(implementation->database);

        QString sqlStatement = "UPDATE " + tableName + " SET json=:json WHERE id=:id";

        if (!query.prepare(sqlStatement))
            return false;

        query.bindValue(":id", QVariant(id));
        query.bindValue(":json", QVariant(QJsonDocument(jsonObject).toJson(QJsonDocument::Compact)));

        if (!query.exec())
            return false;

        return query.numRowsAffected() > 0;
    }
}
}
