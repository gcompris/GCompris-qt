#ifndef COMMANDCONTROLLER_H
#define COMMANDCONTROLLER_H

#include <QObject>
#include <QtQml/QQmlListProperty>

#include <framework/command.h>
#include <controllers/database-controller.h>
#include <controllers/navigation-controller.h>

namespace controllers {

class CommandController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<framework::Command> ui_managePupilsViewContextCommands READ ui_managePupilsViewContextCommands CONSTANT)
    Q_PROPERTY(QQmlListProperty<framework::Command> ui_followResultViewContextCommands READ ui_followResultViewContextCommands CONSTANT)
    Q_PROPERTY(QQmlListProperty<framework::Command> ui_findClientViewContextCommands READ ui_findClientViewContextCommands CONSTANT)

public:
    explicit CommandController(QObject *_parent = nullptr, DatabaseController *databaseController = nullptr, controllers::NavigationController *navigationController = nullptr);
    ~CommandController();

    QQmlListProperty<framework::Command> ui_managePupilsViewContextCommands();
    QQmlListProperty<framework::Command> ui_followResultViewContextCommands();

    QQmlListProperty<framework::Command> ui_findClientViewContextCommands();

public slots:
    void onManagePupilsAddPupilExecuted();
    void onManagePupilsAddPupilsFromListExecuted();
    void onManagePupilsRemovePupilsExecuted();
    void onManagePupilsAddPupilToGroupsExecuted();
    void onManagePupilsRemovePupilToGroupsExecuted();

    void onShowPupilActivitiesDataCommandExecuted();

private:
    class Implementation;
    QScopedPointer<Implementation> implementation;
};

}

#endif
