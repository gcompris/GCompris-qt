#ifndef ADDRESS_H
#define ADDRESS_H

#include <QObject>

#include <cm-lib_global.h>
#include <data/string-decorator.h>
#include <data/entity.h>

namespace cm {
namespace models {

class CMLIBSHARED_EXPORT Address : public data::Entity
{
	Q_OBJECT
	Q_PROPERTY(cm::data::StringDecorator* ui_building MEMBER building CONSTANT)
	Q_PROPERTY(cm::data::StringDecorator* ui_street MEMBER street CONSTANT)
	Q_PROPERTY(cm::data::StringDecorator* ui_city MEMBER city CONSTANT)
	Q_PROPERTY(cm::data::StringDecorator* ui_postcode MEMBER postcode CONSTANT)
	Q_PROPERTY(QString ui_fullAddress READ fullAddress CONSTANT)

public:
	explicit Address(QObject* parent = nullptr);
	Address(QObject* parent, const QJsonObject& json);

	data::StringDecorator* building{nullptr};
	data::StringDecorator* street{nullptr};
	data::StringDecorator* city{nullptr};
	data::StringDecorator* postcode{nullptr};

	QString fullAddress() const;
};

}}

#endif
