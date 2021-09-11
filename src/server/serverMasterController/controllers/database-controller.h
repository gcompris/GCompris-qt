#ifndef DATABASECONTROLLER_H
#define DATABASECONTROLLER_H

#include <QObject>
#include <QScopedPointer>

#include <controllers/i-database-controller.h>

#include <cm-lib_global.h>

class GroupData;

namespace cm {
namespace controllers {

    class CMLIBSHARED_EXPORT DatabaseController : public IDatabaseController
    {
        Q_OBJECT

    public:
        explicit DatabaseController(QObject *parent = nullptr);
        ~DatabaseController();

        void retrieveAllExistingGroups(QList<GroupData* > &allGroups);
        bool addGroup(const QString &groupName, const QString& description = QString(), const QStringList& users=QStringList());
        bool deleteGroup(const QString& groupName);

        /* ---------------------- */
        bool createRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const override;
        bool deleteRow(const QString &tableName, const QString &id) const override;
        QJsonArray find(const QString &tableName, const QString &searchText) const override;
        QJsonObject readRow(const QString &tableName, const QString &id) const override;
        bool updateRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const override;

    private:
        class Implementation;
        QScopedPointer<Implementation> implementation;
    };

}
}

#endif
