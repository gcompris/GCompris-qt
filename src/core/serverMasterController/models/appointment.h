#ifndef APPOINTMENT_H
#define APPOINTMENT_H

#include <QObject>

#include <cm-lib_global.h>
#include <data/datetime-decorator.h>
#include <data/string-decorator.h>
#include <data/entity.h>

namespace cm {
namespace models {

class CMLIBSHARED_EXPORT Appointment : public data::Entity
{
	Q_OBJECT
	Q_PROPERTY(cm::data::DateTimeDecorator* ui_startAt MEMBER startAt CONSTANT)
	Q_PROPERTY(cm::data::DateTimeDecorator* ui_endAt MEMBER endAt CONSTANT)
	Q_PROPERTY(cm::data::StringDecorator* ui_notes MEMBER notes CONSTANT)
public:
	explicit Appointment(QObject* parent = nullptr);
	Appointment(QObject* parent, const QJsonObject& json);

	data::DateTimeDecorator* startAt{nullptr};
	data::DateTimeDecorator* endAt{nullptr};
	data::StringDecorator* notes{nullptr};
};

}}

#endif
