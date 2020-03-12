#include "master-controller.h"

using namespace cm::models;

namespace cm {
namespace controllers {

class MasterController::Implementation
{
public:
	Implementation(MasterController* _masterController)
		: masterController(_masterController)
	{
		commandController = new CommandController(masterController);
		navigationController = new NavigationController(masterController);
        newClient = new Client(masterController);
	}

	MasterController* masterController{nullptr};
	CommandController* commandController{nullptr};
	NavigationController* navigationController{nullptr};
    Client* newClient{nullptr};
	QString welcomeMessage = "This is MasterController to Major Tom";
};

MasterController::MasterController(QObject* parent)
	: QObject(parent)
{
	implementation.reset(new Implementation(this));
}

MasterController::~MasterController()
{
}

CommandController* MasterController::commandController()
{
	return implementation->commandController;
}

NavigationController* MasterController::navigationController()
{
	return implementation->navigationController;
}

Client* MasterController::newClient()
{
    return implementation->newClient;
}

const QString& MasterController::welcomeMessage() const
{
	return implementation->welcomeMessage;
}

}}
