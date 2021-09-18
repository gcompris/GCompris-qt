#ifndef MASTERCONTROLLER_H
#define MASTERCONTROLLER_H

#include <QObject>
#include <QScopedPointer>
#include <QString>

#include <cm-lib_global.h>
#include <controllers/command-controller.h>
#include <controllers/database-controller.h>
#include <controllers/navigation-controller.h>
#include <models/client.h>
#include <models/GroupData.h>
#include <models/UserData.h>

namespace cm {
namespace controllers {

    class CMLIBSHARED_EXPORT MasterController : public QObject
    {
        Q_OBJECT

        Q_PROPERTY(cm::controllers::NavigationController *ui_navigationController READ navigationController CONSTANT)
        Q_PROPERTY(cm::controllers::CommandController *ui_commandController READ commandController CONSTANT)
        Q_PROPERTY(cm::controllers::DatabaseController *ui_databaseController READ databaseController CONSTANT)
        Q_PROPERTY(cm::models::Client *ui_newClient READ newClient CONSTANT)
        Q_PROPERTY(QQmlListProperty<GroupData> ui_groups READ ui_groups NOTIFY groupsChanged)
        Q_PROPERTY(QQmlListProperty<UserData> ui_users READ ui_users NOTIFY usersChanged)
        Q_PROPERTY(QStringList ui_groupsFiltered READ ui_groupsFiltered NOTIFY groupsFilteredChanged)

    public:
        explicit MasterController(QObject *parent = nullptr);
        ~MasterController();

        CommandController *commandController();
        DatabaseController *databaseController();
        NavigationController *navigationController();
        QQmlListProperty<GroupData> ui_groups();
        QQmlListProperty<UserData> ui_users();
        QStringList ui_groupsFiltered();
        models::Client *newClient();

    public slots:
        void createGroup(const QString &groupName);
        void updateGroup(const QString &oldGroupName, const QString &newGroupName);
        void deleteGroup(const QString &groupName);
        void createUser(UserData *userName);
        void deleteUser(const QString &userName);
        void setGroupsForUser(UserData *newUser, const QStringList &groupList);
        void addGroupsToUser(const QString &userName, const QStringList &groupList);
        void removeGroupsToUser(const QString &userName, const QStringList &groupList);

        void selectClient(cm::models::Client *client);

        void addGroupToFilter(const QString &groupName);
        void removeGroupToFilter(const QString &groupName);
        Q_INVOKABLE void filterUsersView();

    signals:
        void groupsFilteredChanged();
        void groupsChanged();
        void usersChanged();

    private:
        class Implementation;
        QScopedPointer<Implementation> implementation;
    };

}
}

#endif
