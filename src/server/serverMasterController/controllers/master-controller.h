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
#include <models/client-search.h>
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
        Q_PROPERTY(cm::models::ClientSearch *ui_clientSearch READ clientSearch CONSTANT)
        Q_PROPERTY(QQmlListProperty<GroupData> ui_groups READ ui_groups NOTIFY groupsChanged)
        Q_PROPERTY(QQmlListProperty<UserData> ui_users READ ui_users NOTIFY usersChanged)

    public:
        explicit MasterController(QObject *parent = nullptr);
        ~MasterController();

        CommandController *commandController();
        DatabaseController *databaseController();
        NavigationController *navigationController();
        QQmlListProperty<GroupData> ui_groups();
        QQmlListProperty<UserData> ui_users();
        models::Client *newClient();
        models::ClientSearch *clientSearch();

    public slots:
        void createGroup(const QString &groupName);
        void updateGroup(const QString &oldGroupName, const QString &newGroupName);
        void deleteGroup(const QString &groupName);
        void createUser(UserData *userName);
        void deleteUser(const QString &userName);
        void setGroupsForUser(UserData *newUser, const QVariantList &groupList);

        void selectClient(cm::models::Client *client);

        Q_INVOKABLE void filterUsersView(const QString &groupName);

    signals:
        void groupsChanged();
        void usersChanged();

    private:
        class Implementation;
        QScopedPointer<Implementation> implementation;
    };

}
}

#endif
