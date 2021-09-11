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
        }
        MasterController *masterController { nullptr };
        CommandController *commandController { nullptr };
        DatabaseController *databaseController { nullptr };
        NavigationController *navigationController { nullptr };
        QList<GroupData *> groups;
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
        printf("in MasterController::createGroup\n");
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

    void MasterController::deleteGroup(const QString &groupName)
    {
        printf("in MasterController::deleteGroup\n");
        
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

    QQmlListProperty<GroupData> MasterController::ui_groups()
    {
        return QQmlListProperty<GroupData>(this, implementation->groups);
    }

    void MasterController::selectClient(Client *client)
    {
        implementation->navigationController->goEditClientView(client);
    }

}
}
