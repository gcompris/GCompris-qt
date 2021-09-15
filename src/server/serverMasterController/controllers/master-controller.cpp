#include <QtDebug>
#include <algorithm>
#include "master-controller.h"

using namespace cm::models;

namespace cm {
namespace controllers {

    class MasterController::Implementation
    {
    public:
        Implementation(MasterController *_masterController) :
            masterController(_masterController)
        {
            databaseController = new DatabaseController(masterController);
            navigationController = new NavigationController(masterController);
            newClient = new Client(masterController);
            clientSearch = new ClientSearch(masterController, databaseController);
            commandController = new CommandController(masterController, databaseController, navigationController, newClient, clientSearch);

            loadDatabase();
        }

        void loadDatabase() {
            databaseController->retrieveAllExistingGroups(groups);
            databaseController->retrieveAllExistingUsers(users);
        }

        MasterController *masterController { nullptr };
        CommandController *commandController { nullptr };
        DatabaseController *databaseController { nullptr };
        NavigationController *navigationController { nullptr };
        QList<GroupData *> groups;
        QList<UserData *> users;
        // remove below
        Client *newClient { nullptr };
        ClientSearch *clientSearch { nullptr };
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

    Client *MasterController::newClient()
    {
        return implementation->newClient;
    }

    ClientSearch *MasterController::clientSearch()
    {
        return implementation->clientSearch;
    }

    void MasterController::createGroup(const QString &groupName)
    {
        if(implementation->databaseController->addGroup(groupName)) {
            GroupData *group = new GroupData();
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
        if(implementation->databaseController->updateGroup(oldGroupName, newGroupName)) {
            auto groupIterator = std::find_if(std::begin(implementation->groups), std::end(implementation->groups),
                                              [&oldGroupName](GroupData * group) {
                                                  return group->getName() == oldGroupName;
                                              });
            GroupData *group = *groupIterator;
            group->setName(newGroupName);
            emit groupsChanged();
        }
        else {
            qDebug() << "Unable to update group from" << oldGroupName << "to" << newGroupName;
        }
    }

    void MasterController::deleteGroup(const QString &groupName)
    {
        //todo remove all users from this group
        if(implementation->databaseController->deleteGroup(groupName)) {
            auto groupIterator = std::find_if(std::begin(implementation->groups), std::end(implementation->groups),
                                           [&groupName](GroupData * group) {
                                               return group->getName() == groupName;
                                           });
            if(groupIterator != std::end(implementation->groups)) {
                GroupData *group = *groupIterator;
                implementation->groups.removeOne(group);
                emit groupsChanged();
                delete group;
            }
        }
        else {
            qDebug() << "Unable to delete group" << groupName;
        }
    }

    void MasterController::createUser(UserData *newUser)
    {
        if(implementation->databaseController->addUser(*newUser)) {
            UserData *user = new UserData(*newUser);
            implementation->users << user;
            emit usersChanged();
       }
        else {
            qDebug() << "Unable to create user" << newUser->getName();
        }
    }

    void MasterController::addUserToGroups(UserData *newUser, const QVariantList &groupList)
    {
        const QString &userName = newUser->getName();
        for(const QVariant &var: groupList) {
            const QString group = var.toString();
            if(implementation->databaseController->addUserToGroup(userName, group)) {
                qDebug() << userName << "added to" << group;
                // Todo add in the model and display it to screen
            }
            else {
                qDebug() << "Unable to add " << userName << "to" << group;
            }
        }
    }

    void MasterController::deleteUser(const QString &userName)
    {
        //todo remove this user from all of its groups
        if(implementation->databaseController->deleteUser(userName)) {
            auto userIterator = std::find_if(std::begin(implementation->users), std::end(implementation->users),
                                           [&userName](UserData * user) {
                                               return user->getName() == userName;
                                           });
            if(userIterator != std::end(implementation->users)) {
                UserData *user = *userIterator;
                implementation->users.removeOne(user);
                emit usersChanged();
                delete user;
            }
        }
        else {
            qDebug() << "Unable to delete user" << userName;
        }
    }

    QQmlListProperty<GroupData> MasterController::ui_groups()
    {
        return QQmlListProperty<GroupData>(this, implementation->groups);
    }

    QQmlListProperty<UserData> MasterController::ui_users()
    {
        return QQmlListProperty<UserData>(this, implementation->users);
    }

    void MasterController::selectClient(Client *client)
    {
        implementation->navigationController->goEditClientView(client);
    }

}
}
