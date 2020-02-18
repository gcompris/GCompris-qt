#ifndef INTDECORATOR_H
#define INTDECORATOR_H

#include <QJsonObject>
#include <QJsonValue>
#include <QObject>
#include <QScopedPointer>

#include <cm-lib_global.h>
#include <data/data-decorator.h>

namespace cm {
namespace data {

class CMLIBSHARED_EXPORT IntDecorator : public DataDecorator
{
	Q_OBJECT

	Q_PROPERTY( int ui_value READ value WRITE setValue NOTIFY valueChanged )

public:
	IntDecorator(Entity* parentEntity = nullptr, const QString& key = "SomeItemKey", const QString& label = "", int value = 0);
	~IntDecorator();

	IntDecorator& setValue(int value);
	int value() const;

public:
	QJsonValue jsonValue() const override;
	void update(const QJsonObject& jsonObject) override;

signals:
	void valueChanged();

private:
	class Implementation;
	QScopedPointer<Implementation> implementation;
};

}}

#endif
