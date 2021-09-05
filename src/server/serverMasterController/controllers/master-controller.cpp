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
            newGroup = new Group(masterController);
        }

        MasterController *masterController { nullptr };
        CommandController *commandController { nullptr };
        DatabaseController *databaseController { nullptr };
        NavigationController *navigationController { nullptr };
        Group *newGroup { nullptr };
        QList<Group *> groups;
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

    Group *MasterController::newGroup()
    {
        return implementation->newGroup;
    }

    void MasterController::createGroup(cm::models::Group *group)
    {
        implementation->groups << group;
        emit groupsChanged();
        printf("in MasterController::createGroup\n");
        implementation->databaseController->createRow("groups", group->name->value(), group->toJson());
    }

    QQmlListProperty<Group> MasterController::ui_groups()
    {
        return QQmlListProperty<Group>(this, implementation->groups);
    }

    void MasterController::selectClient(Client *client)
    {
        implementation->navigationController->goEditClientView(client);
    }

}
}
