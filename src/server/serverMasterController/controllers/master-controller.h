#ifndef MASTERCONTROLLER_H
#define MASTERCONTROLLER_H

#include <QObject>
#include <QScopedPointer>
#include <QString>

#include <controllers/command-controller.h>
#include <controllers/database-controller.h>
#include <controllers/navigation-controller.h>
#include <models/GroupData.h>
#include <models/UserData.h>

namespace controllers {

class MasterController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(controllers::NavigationController *ui_navigationController READ navigationController CONSTANT)
    Q_PROPERTY(controllers::CommandController *ui_commandController READ commandController CONSTANT)
    Q_PROPERTY(controllers::DatabaseController *ui_databaseController READ databaseController CONSTANT)
    Q_PROPERTY(QQmlListProperty<GroupData> ui_groups READ ui_groups NOTIFY groupsChanged)
    Q_PROPERTY(QQmlListProperty<UserData> ui_users READ ui_users NOTIFY usersChanged)
    Q_PROPERTY(QStringList ui_groupsFiltered READ ui_groupsFiltered NOTIFY groupsFilteredChanged)

public:
    explicit MasterController(QObject *parent = nullptr);
    ~MasterController();

    CommandController *commandController();
    DatabaseController *databaseController();
    NavigationController *navigationController();

    UserData *getUserByName(const QString &name);
    GroupData *getGroupByName(const QString &name);
    QQmlListProperty<GroupData> ui_groups();
    QQmlListProperty<UserData> ui_users();
    QStringList ui_groupsFiltered();

    Q_INVOKABLE void unloadDatabase();
    Q_INVOKABLE void loadDatabase(const QString &databaseFile);

    bool checkPassword(const QString &login, const QString &password);

    void addActivityDataForUser(const UserData &user, const QString& activity, qint64 timestamp, const QString &rawData);

public slots:
    void createGroup(const QString &groupName);
    void updateGroup(const QString &oldGroupName, const QString &newGroupName);
    void deleteGroup(const QString &groupName);
    void createUser(UserData *userName);
    void updateUser(UserData *oldUser, UserData *newUser, const QStringList &newGroupList);
    void deleteUser(const QString &userName);
    void setGroupsForUser(UserData *newUser, const QStringList &groupList);
    void addGroupsToUser(const QString &userName, const QStringList &groupList);
    void removeGroupsToUser(const QString &userName, const QStringList &groupList);

    void addGroupToFilter(const QString &groupName);
    void removeGroupToFilter(const QString &groupName);
    Q_INVOKABLE void filterUsersView();

    QList<QVariant> getActivityData(const QString &userName, const QString &activity /*, range of date */);

signals:
    void groupsFilteredChanged();
    void groupsChanged();
    void usersChanged();

private:
    class Implementation;
    QScopedPointer<Implementation> implementation;
};

}

#endif
