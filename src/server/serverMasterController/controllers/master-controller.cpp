#include <QtDebug>
#include <algorithm>
#include "master-controller.h"

namespace controllers {

class MasterController::Implementation
{
public:
    Implementation(MasterController *_masterController) :
        masterController(_masterController)
    {
        databaseController = new DatabaseController(masterController);
        navigationController = new NavigationController(masterController);
        commandController = new CommandController(masterController, databaseController, navigationController);

        loadDatabase();
    }

    void loadDatabase()
    {
        databaseController->retrieveAllExistingGroups(groups);
        databaseController->retrieveAllExistingUsers(users);
        databaseController->recreateAllLinksBetweenGroupsAndUsers(groups, users);
        filterUsersView();
    }

    void filterUsersView()
    {
        QList<UserData *> tmpList;
        if (groupFilterName.isEmpty()) {
            tmpList << users;
        }
        else {
            for (UserData *user: users) {
                auto groupIterator = std::find_if(std::begin(user->getGroups()), std::end(user->getGroups()),
                                                  [this](GroupData *group) {
                                                      return groupFilterName.indexOf(group->getName()) != -1;
                                                  });
                if (groupIterator != std::end(user->getGroups())) {
                    tmpList << user;
                }
            }
        }
        usersToDisplay = tmpList;
    }

    MasterController *masterController { nullptr };
    CommandController *commandController { nullptr };
    DatabaseController *databaseController { nullptr };
    NavigationController *navigationController { nullptr };
    QList<GroupData *> groups;
    QList<UserData *> users;
    QList<UserData *> usersToDisplay;
    QStringList groupFilterName;

};

MasterController::MasterController(QObject *parent) :
    QObject(parent)
{
    implementation.reset(new Implementation(this));
}

MasterController::~MasterController()
{
}

CommandController *MasterController::commandController()
{
    return implementation->commandController;
}

DatabaseController *MasterController::databaseController()
{
    return implementation->databaseController;
}

NavigationController *MasterController::navigationController()
{
    return implementation->navigationController;
}

void MasterController::createGroup(const QString &groupName)
{
    int groupId = implementation->databaseController->addGroup(groupName);
    if (groupId > 0) {
        GroupData *group = new GroupData();
        group->setPrimaryKey(groupId);
        group->setName(groupName);
        implementation->groups << group;
        emit groupsChanged();
    }
    else {
        qDebug() << "Unable to create group" << groupName;
    }
}

void MasterController::updateGroup(const QString &oldGroupName, const QString &newGroupName)
{
    GroupData *group = getGroupByName(oldGroupName);
    if (!group) {
        qDebug() << "Group" << oldGroupName << "does not exist";
        return;
    }
    if (implementation->databaseController->updateGroup(*group, newGroupName)) {
        if (implementation->groupFilterName.indexOf(group->getName()) >= 0) {
            implementation->groupFilterName.removeOne(group->getName());
            implementation->groupFilterName << newGroupName;
            emit groupsFilteredChanged();
        }

        group->setName(newGroupName);
        emit groupsChanged();
        emit usersChanged();
    }
    else {
        qDebug() << "Unable to update group from" << oldGroupName << "to" << newGroupName;
    }
}

void MasterController::deleteGroup(const QString &groupName)
{
    GroupData *group = getGroupByName(groupName);
    if (!group) {
        qDebug() << "Unable to delete group" << groupName;
        return;
    }
    if (implementation->databaseController->deleteGroup(*group)) {
        implementation->groups.removeOne(group);
        // remove all users from this group
        for (UserData *user: implementation->users) {
            auto groupIterator = std::find_if(std::begin(user->getGroups()), std::end(user->getGroups()),
                                              [&groupName](GroupData *group) {
                                                  return groupName == group->getName();
                                              });
            if (groupIterator != std::end(user->getGroups())) {
                user->removeGroup(*groupIterator);
            }
        }
        // Remove the group from views filter if it was present
        if (implementation->groupFilterName.indexOf(group->getName()) >= 0) {
            implementation->groupFilterName.removeOne(group->getName());
            filterUsersView();
        }
        emit groupsChanged();
        emit usersChanged();
        delete group;
    }
    else {
        qDebug() << "Unable to delete group" << groupName << "on database";
    }
}

void MasterController::createUser(UserData *newUser)
{
    int userId = implementation->databaseController->addUser(*newUser);
    if (userId > 0) {
        UserData *user = new UserData(*newUser);
        user->setPrimaryKey(userId);
        implementation->users << user;
        emit usersChanged();
    }
    else {
        qDebug() << "Unable to create user" << newUser->getName();
    }
}

void MasterController::setGroupsForUser(UserData *newUser, const QStringList &groupList)
{
    UserData *user = getUserByName(newUser->getName());
    if (!user) {
        qDebug() << "User" << newUser->getName() << "does not exist";
        return;
    }    
    implementation->databaseController->removeAllGroupsForUser(*user);
    user->removeAllGroups();
    addGroupsToUser(user->getName(), groupList);
}

void MasterController::addGroupsToUser(const QString &userName, const QStringList &groupList)
{
    UserData *user = getUserByName(userName);
    if (!user) {
        qDebug() << "User" << userName << "does not exist";
        return;
    }
    for (const QString &groupName: groupList) {
        GroupData *group = getGroupByName(groupName);
        if (!group) {
            qDebug() << "Group" << groupName << "does not exist";
            continue;
        }

        if (user->hasGroup(group)) {
            qDebug() << "User" << user->getName() << "already has group" << group->getName();
            continue;
        }
        if (implementation->databaseController->addUserToGroup(*user, *group)) {
            user->addGroup(group);
            qDebug() << userName << "added to" << groupName;
        }
        else {
            qDebug() << "Unable to add " << userName << "to" << groupName;
        }
    }
    filterUsersView();
}

void MasterController::removeGroupsToUser(const QString &userName, const QStringList &groupList)
{
    UserData *user = getUserByName(userName);
    if (!user) {
        qDebug() << "User" << userName << "does not exist";
        return;
    }
    for (const QString &groupName: groupList) {
        GroupData *group = getGroupByName(groupName);
        if (!group) {
            qDebug() << "Group" << groupName << "does not exist";
            continue;
        }

        if (implementation->databaseController->removeUserToGroup(*user, *group)) {
            user->removeGroup(group);
            qDebug() << userName << "remove to" << groupName;
        }
        else {
            qDebug() << "Unable to remove " << userName << "to" << groupName;
        }
    }
    filterUsersView();
}

void MasterController::deleteUser(const QString &userName)
{
    UserData *user = getUserByName(userName);
    if (!user) {
        qDebug() << "Unable to find user" << userName;
        return;
    }
    if (implementation->databaseController->deleteUser(*user)) {
        implementation->users.removeOne(user);
        filterUsersView();
        delete user;
    }
    else {
        qDebug() << "Unable to delete user" << userName << "from database";
    }
}

QQmlListProperty<GroupData> MasterController::ui_groups()
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 15, 0)
    return QQmlListProperty<GroupData>(this, &implementation->groups);
#else
    return QQmlListProperty<GroupData>(this, implementation->groups);
#endif
}

void MasterController::addGroupToFilter(const QString &groupName)
{
    implementation->groupFilterName << groupName;
}
void MasterController::removeGroupToFilter(const QString &groupName)
{
    if (groupName.isEmpty()) {
        implementation->groupFilterName.clear();
    }
    else {
        implementation->groupFilterName.removeOne(groupName);
    }
}

UserData *MasterController::getUserByName(const QString &name)
{
    auto userIterator = std::find_if(std::begin(implementation->users), std::end(implementation->users),
                                     [&name](UserData *user) {
                                         return user->getName() == name;
                                     });

    if (userIterator == std::end(implementation->users)) {
        return nullptr;
    }
    return *userIterator;
}

GroupData *MasterController::getGroupByName(const QString &name)
{
    auto groupIterator = std::find_if(std::begin(implementation->groups), std::end(implementation->groups),
                                      [&name](GroupData *group) {
                                          return group->getName() == name;
                                      });
    if (groupIterator == std::end(implementation->groups)) {
        return nullptr;
    }
    return *groupIterator;
}

void MasterController::filterUsersView()
{
    implementation->filterUsersView();
    emit usersChanged();
}

QQmlListProperty<UserData> MasterController::ui_users()
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 15, 0)
    return QQmlListProperty<UserData>(this, &implementation->usersToDisplay);
#else
    return QQmlListProperty<UserData>(this, implementation->usersToDisplay);
#endif
}

QStringList MasterController::ui_groupsFiltered()
{
    return implementation->groupFilterName;
}

bool MasterController::checkPassword(const QString &login, const QString &password)
{
    // todo
    return true;
}

void MasterController::addActivityDataForUser(const UserData &user, const QString& activity, qint64 timestamp, const QString &rawData)
{
    implementation->databaseController->addDataToUser(user, activity, timestamp, rawData);
}

QList<QVariant> MasterController::getActivityData(const QString &userName, const QString &activity) {
    UserData *user = getUserByName(userName);
    if(!user) {
        qDebug() << "Unable to find user" << userName;
        return QList<QVariant>();
    }
    return implementation->databaseController->getActivityData(*user, activity);
}
}
