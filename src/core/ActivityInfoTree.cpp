#include <QtDebug>
#include <QQmlProperty>
#include <QQmlComponent>

#include "ActivityInfoTree.h"

ActivityInfoTree::ActivityInfoTree(QObject *parent) : QObject(parent),
	m_currentActivity(NULL)
{}


void ActivityInfoTree::setRootMenu(ActivityInfo *rootMenu)
{
	m_rootMenu = rootMenu;
}

ActivityInfo *ActivityInfoTree::getRootMenu() const
{
	return m_rootMenu;
}

QQmlListProperty<ActivityInfo> ActivityInfoTree::menuTree()
{
	return QQmlListProperty<ActivityInfo>(this, m_menuTree);
}

int ActivityInfoTree::menuTreeCount() const
{
	return m_menuTree.count();
}

ActivityInfo *ActivityInfoTree::menuTree(int index) const
{
	return m_menuTree.at(index);
}

void ActivityInfoTree::setCurrentActivity(ActivityInfo *currentActivity)
{
	m_currentActivity = currentActivity;
	emit currentActivityChanged();
}

ActivityInfo *ActivityInfoTree::getCurrentActivity() const
{
	return m_currentActivity;
}

ActivityInfo *ActivityInfoTree::getParentActivity(ActivityInfo *root, ActivityInfo *menu)
{

	qDebug() << "Parent Path= " << menu->getSectionPath();

	Q_FOREACH( QObject *object, root->children() )
	{
		ActivityInfo *activityInfo = qobject_cast<ActivityInfo*>(object);
		if(activityInfo->section() == menu->section()) {
			return activityInfo;
		}
	}

	return m_menuTree.at(0);
}

void ActivityInfoTree::menuTreeAppend(ActivityInfo *menu)
{
	m_menuTree.append(menu);
	emit menuTreeChanged();
}

void ActivityInfoTree::menuTreeAppend(QQmlEngine *engine,
									  const QDir &menuDir, const QString &menuFile)
{
	QQmlComponent component(engine,
							QUrl::fromLocalFile(menuDir.absolutePath() + "/" + menuFile));
	QObject *object = component.create();
	if(component.isReady()) {
		if(QQmlProperty::read(object, "section").toString() == "/") {
			menuTreeAppend(qobject_cast<ActivityInfo*>(object));
		}
	} else {
		qDebug() << menuFile << ": Failed to load";
	}
}

QObject *ActivityInfoTree::menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(scriptEngine)

	ActivityInfoTree *menuTree = new ActivityInfoTree(NULL);

	// TODO Parse all ActivityInfo on disk
//	QDir menuDir("../gcompris-qt/src/activities/menus", "*.qml");
//	qDebug() << "menu dir path= " << menuDir.absolutePath();
//	QStringList list = menuDir.entryList();
//	for (int i = 0; i < list.size(); ++i) {
//		menuTree->menuTreeAppend(engine, menuDir,
//								 list.at(i));
//	}

	QQmlComponent componentRoot(engine,
			QUrl("qrc:/gcompris/src/activities/menu/ActivityInfo.qml"));
	QObject *objectRoot = componentRoot.create();
	menuTree->setRootMenu(qobject_cast<ActivityInfo*>(objectRoot));

	QQmlComponent component(engine,
			QUrl("qrc:/gcompris/src/activities/leftright/ActivityInfo.qml"));
	QObject *object = component.create();
	menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(object));

	QQmlComponent component2(engine,
			QUrl("qrc:/gcompris/src/activities/clickgame/ActivityInfo.qml"));
	menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(component2.create()));

	menuTree->menuTreeAppend(
		qobject_cast<ActivityInfo*>(
			QQmlComponent(engine,
				QUrl("qrc:/gcompris/src/activities/erase/ActivityInfo.qml")).create()));

	menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(object));
	menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(object));
	menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(object));
	menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(object));

//	qDebug() << "getParentActivity:" << menuTree->getParentActivity(menuTree->menuTree(0),
//																	qobject_cast<ActivityInfo*>(object))->name();
	return menuTree;
}

void ActivityInfoTree::init()
{
	qmlRegisterSingletonType<QObject>("GCompris", 1, 0, "ActivityInfoTree", menuTreeProvider);
	qmlRegisterType<ActivityInfo>("GCompris", 1, 0, "ActivityInfo");
}
