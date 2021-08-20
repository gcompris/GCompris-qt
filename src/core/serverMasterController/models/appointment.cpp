#include "appointment.h"

using namespace cm::data;

namespace cm {
namespace models {

Appointment::Appointment(QObject* parent)
	: Entity(parent, "address")
{
	startAt = static_cast<DateTimeDecorator*>(addDataItem(new DateTimeDecorator(this, "startAt", "Start")));
	endAt = static_cast<DateTimeDecorator*>(addDataItem(new DateTimeDecorator(this, "endAt", "End")));
	notes = static_cast<StringDecorator*>(addDataItem(new StringDecorator(this, "notes", "Notes")));
}

Appointment::Appointment(QObject* parent, const QJsonObject& json)
	: Appointment(parent)
{
	update(json);
}

}}
