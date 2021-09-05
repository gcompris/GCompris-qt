#ifndef GROUP_H
#define GROUP_H

#include <QObject>
#include <QtQml/QQmlListProperty>

#include <cm-lib_global.h>
#include <data/string-decorator.h>
#include <data/entity.h>
#include <data/entity-collection.h>
#include <models/contact.h>

namespace cm {
namespace models {

    class CMLIBSHARED_EXPORT Group : public data::Entity
    {
        Q_OBJECT
        Q_PROPERTY(cm::data::StringDecorator *ui_name MEMBER name CONSTANT)
        Q_PROPERTY(QQmlListProperty<Contact> ui_contacts READ ui_contacts NOTIFY contactsChanged)

    public:
        explicit Group(QObject *parent = nullptr);
        Group(QObject *parent, const QJsonObject &json);

        data::StringDecorator *name { nullptr };
        data::EntityCollection<Contact> *contacts { nullptr };

        QQmlListProperty<cm::models::Contact> ui_contacts();

    signals:
        void contactsChanged();
    };

}
}

#endif
