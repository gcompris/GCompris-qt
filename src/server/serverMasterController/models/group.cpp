#include "group.h"

using namespace cm::data;

namespace cm {
namespace models {

    Group::Group(QObject *parent) :
        Entity(parent, "group")
    {
        name = static_cast<StringDecorator *>(addDataItem(new StringDecorator(this, "name", "Name")));
        contacts = static_cast<EntityCollection<Contact> *>(addChildCollection(new EntityCollection<Contact>(this, "contacts")));

        setPrimaryKey(name);
    }

    Group::Group(QObject *parent, const QJsonObject &json) :
        Group(parent)
    {
        update(json);
    }

    QQmlListProperty<Contact> Group::ui_contacts()
    {
        return QQmlListProperty<Contact>(this, contacts->derivedEntities());
    }
}
}
