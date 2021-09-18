#ifndef COMMANDCONTROLLER_H
#define COMMANDCONTROLLER_H

#include <QObject>
#include <QtQml/QQmlListProperty>

#include <cm-lib_global.h>
#include <framework/command.h>
#include <controllers/database-controller.h>
#include <controllers/navigation-controller.h>
#include <models/client.h>

namespace cm {
namespace controllers {

    class CMLIBSHARED_EXPORT CommandController : public QObject
    {
        Q_OBJECT
        Q_PROPERTY(QQmlListProperty<cm::framework::Command> ui_createClientViewContextCommands READ ui_createClientViewContextCommands CONSTANT)
        Q_PROPERTY(QQmlListProperty<cm::framework::Command> ui_findClientViewContextCommands READ ui_findClientViewContextCommands CONSTANT)
        Q_PROPERTY(QQmlListProperty<cm::framework::Command> ui_editClientViewContextCommands READ ui_editClientViewContextCommands CONSTANT)
        Q_PROPERTY(QQmlListProperty<cm::framework::Command> ui_managePupilsViewContextCommands READ ui_managePupilsViewContextCommands CONSTANT)

    public:
        explicit CommandController(QObject *_parent = nullptr, DatabaseController *databaseController = nullptr, controllers::NavigationController *navigationController = nullptr, models::Client *newClient = nullptr);
        ~CommandController();

        QQmlListProperty<framework::Command> ui_createClientViewContextCommands();
        QQmlListProperty<framework::Command> ui_findClientViewContextCommands();
        QQmlListProperty<framework::Command> ui_editClientViewContextCommands();
        QQmlListProperty<framework::Command> ui_managePupilsViewContextCommands();

    public slots:
        void setSelectedClient(cm::models::Client *client);
        void onCreateClientSaveExecuted();
        void onEditClientSaveExecuted();
        void onEditClientDeleteExecuted();
        void onManagePupilsAddPupilExecuted();
        void onManagePupilsAddPupilsFromListExecuted();
        void onManagePupilsRemovePupilsExecuted();

    private:
        class Implementation;
        QScopedPointer<Implementation> implementation;
    };

}
}

#endif
