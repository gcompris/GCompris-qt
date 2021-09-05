#include "contact.h"

using namespace cm::data;

namespace cm {
namespace models {

    std::map<int, QString> Contact::contactTypeMapper = std::map<int, QString> {
        { Contact::eContactType::Unknown, "" }, { Contact::eContactType::Telephone, "Telephone" }, { Contact::eContactType::Email, "Email" }, { Contact::eContactType::Fax, "Fax" }
    };

    Contact::Contact(QObject *parent) :
        Entity(parent, "contact")
    {
        contactType = static_cast<EnumeratorDecorator *>(addDataItem(new EnumeratorDecorator(this, "contactType", "Contact Type", 0, contactTypeMapper)));
        address = static_cast<StringDecorator *>(addDataItem(new StringDecorator(this, "address", "Address")));
    }

    Contact::Contact(QObject *parent, const QJsonObject &json) :
        Contact(parent)
    {
        update(json);
    }

}
}
