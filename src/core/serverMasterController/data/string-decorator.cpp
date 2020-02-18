#include "string-decorator.h"

#include <QVariant>

namespace cm {
namespace data {

class StringDecorator::Implementation
{
public:
	Implementation(StringDecorator* _stringDecorator, const QString& _value)
		: stringDecorator(_stringDecorator)
		, value(_value)
	{
	}

	StringDecorator* stringDecorator{nullptr};
	QString value;
};

StringDecorator::StringDecorator(Entity* parentEntity, const QString& key, const QString& label, const QString& value)
	: DataDecorator(parentEntity, key, label)
{
	implementation.reset(new Implementation(this, value));
}

StringDecorator::~StringDecorator()
{
}

const QString& StringDecorator::value() const
{
	return implementation->value;
}

StringDecorator& StringDecorator::setValue(const QString& value)
{
	if(value != implementation->value) {
		// ...Validation here if required...
		implementation->value = value;
		emit valueChanged();
	}
	return *this;
}

QJsonValue StringDecorator::jsonValue() const
{
	return QJsonValue::fromVariant(QVariant(implementation->value));
}

void StringDecorator::update(const QJsonObject& _jsonObject)
{
	if (_jsonObject.contains(key())) {
		setValue(_jsonObject.value(key()).toString());
	} else {
		setValue("");
	}
}

}}
