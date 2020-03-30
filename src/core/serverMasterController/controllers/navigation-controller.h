#ifndef NAVIGATIONCONTROLLER_H
#define NAVIGATIONCONTROLLER_H

#include <QObject>

#include <cm-lib_global.h>
#include <models/client.h>

namespace cm {
namespace controllers {

class CMLIBSHARED_EXPORT NavigationController : public QObject
{
	Q_OBJECT

public:
	explicit NavigationController(QObject* parent = nullptr) : QObject(parent){}

signals:
    void goManagePupilsView();
    void goCreateClientView();
	void goDashboardView();
	void goEditClientView(cm::models::Client* client);
	void goFindClientView();
    void goManageWorkPlanView();

};

}
}

#endif
