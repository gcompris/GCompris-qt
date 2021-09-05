#include "enumerator-decorator.h"

#include <QVariant>

namespace cm {
namespace data {

class EnumeratorDecorator::Implementation
{
public:
	Implementation(EnumeratorDecorator* enumeratorDecorator, int value, const std::map<int, QString>& descriptionMapper)
		: enumeratorDecorator(enumeratorDecorator)
		, value(value)
		, descriptionMapper(descriptionMapper)
	{
	}

	EnumeratorDecorator* enumeratorDecorator{nullptr};
	int value;
	std::map<int, QString> descriptionMapper;
};

EnumeratorDecorator::EnumeratorDecorator(Entity* parentEntity, const QString& key, const QString& label, int value, const std::map<int, QString>& descriptionMapper)
	: DataDecorator(parentEntity, key, label)
{
	implementation.reset(new Implementation(this, value, descriptionMapper));
}

EnumeratorDecorator::~EnumeratorDecorator()
{
}

int EnumeratorDecorator::value() const
{
	return implementation->value;
}

QString EnumeratorDecorator::valueDescription() const
{
	if (implementation->descriptionMapper.find(implementation->value) != implementation->descriptionMapper.end()) {
		return implementation->descriptionMapper.at(implementation->value);
	} else {
		return {};
	}
}

EnumeratorDecorator& EnumeratorDecorator::setValue(int value)
{
	if (value != implementation->value) {
		// ...Validation here if required...
		implementation->value = value;
		emit valueChanged();
	}

	return *this;
}

QJsonValue EnumeratorDecorator::jsonValue() const
{
	return QJsonValue::fromVariant(QVariant(implementation->value));
}

void EnumeratorDecorator::update(const QJsonObject& jsonObject)
{
	if (jsonObject.contains(key())) {
		auto valueFromJson = jsonObject.value(key()).toInt();
		setValue(valueFromJson);
	} else {
		setValue(0);
	}
}

}}
