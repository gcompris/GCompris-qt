#include <QtDebug>
#include <QQmlProperty>
#include <QQmlComponent>

#include "ActivityInfoTree.h"

ActivityInfoTree::ActivityInfoTree(QObject *parent) : QObject(parent)
{}


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
	QQmlComponent component(engine,
			QUrl("qrc:/gcompris/src/activities/leftright/ActivityInfo.qml"));
	QObject *object = component.create();
	qDebug() << "bar_home.svgz file exists?" << QFile(":/gcompris/src/core/resource/bar_home.svgz").exists();
	qDebug() << "Property value:" << QQmlProperty::read(object, "dir").toString();
	qDebug() << "Property value:" << QQmlProperty::read(object, "icon").toString();

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
