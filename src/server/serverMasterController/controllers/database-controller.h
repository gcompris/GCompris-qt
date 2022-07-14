#ifndef DATABASECONTROLLER_H
#define DATABASECONTROLLER_H

#include <QObject>
#include <QScopedPointer>
#include <QSqlQueryModel>

class GroupData;
class UserData;

namespace controllers {

class DatabaseController : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseController(QObject *parent = nullptr);
    ~DatabaseController();

    Q_INVOKABLE bool createTeacher(const QString &login, const QString &password);
    Q_INVOKABLE bool checkTeacher(const QString &login, const QString &password);

    void retrieveAllExistingGroups(QList<GroupData *> &allGroups);
    int addGroup(const QString &groupName, const QString &description = QString(), const QStringList &users = QStringList());
    int updateGroup(const GroupData &oldGroup, const QString &newGroupName);
    bool deleteGroup(const GroupData &group);

    void retrieveAllExistingUsers(QList<UserData *> &allUsers);
    int addUser(const UserData &user);
    bool deleteUser(const UserData &user);

    void recreateAllLinksBetweenGroupsAndUsers(QList<GroupData *> &groups, QList<UserData *> &users);
    bool addUserToGroup(const UserData &user, const GroupData &group);
    bool removeUserToGroup(const UserData &user, const GroupData &group);
    bool removeAllGroupsForUser(const UserData &user);

    bool addDataToUser(const UserData &user, const QString& activity, qint64 timestamp, const QString &rawData);

    QList<QVariant> getActivityData(const UserData &user, const QString &activity /*, range of date*/);

    /* ---------------------- */
    bool createRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const;
    bool deleteRow(const QString &tableName, const QString &id) const;
    QJsonArray find(const QString &tableName, const QString &searchText) const;
    QJsonObject readRow(const QString &tableName, const QString &id) const;
    bool updateRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const;

private:
    class Implementation;
    QScopedPointer<Implementation> implementation;
};

}

#endif
