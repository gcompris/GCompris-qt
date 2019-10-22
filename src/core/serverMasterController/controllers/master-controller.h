#ifndef MASTERCONTROLLER_H
#define MASTERCONTROLLER_H

#include <QObject>
#include <QScopedPointer>
#include <QString>

#include "cm-lib_global.h"
#include "navigation-controller.h"

namespace cm {
namespace controllers {

class CMLIBSHARED_EXPORT MasterController : public QObject
{
	Q_OBJECT

	Q_PROPERTY( QString ui_welcomeMessage READ welcomeMessage CONSTANT )
	Q_PROPERTY( cm::controllers::NavigationController* ui_navigationController READ navigationController CONSTANT )

public:
	explicit MasterController(QObject* parent = nullptr);
	~MasterController();

	NavigationController* navigationController();
	const QString& welcomeMessage() const;

private:
	class Implementation;
	QScopedPointer<Implementation> implementation;
};

}}

#endif
