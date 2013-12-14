#include <QtDebug>
#include <QQmlProperty>
#include <QQmlEngine>
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

void ActivityInfoTree::menuTreeAppend(ActivityInfo *menu)
{
	m_menuTree.append(menu);
	emit menuTreeChanged();
}


QObject *ActivityInfoTree::menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(scriptEngine)

	ActivityInfoTree *menuTree = new ActivityInfoTree(NULL);

	// TODO Parse all ActivityInfo on disk
	QQmlComponent component(engine,
			QUrl::fromLocalFile("qml/leftright-activity/ActivityInfo.qml"));
	QObject *object = component.create();
	qDebug() << "Property value:" << QQmlProperty::read(object, "dir").toString();

	menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(object));
	return menuTree;
}

void ActivityInfoTree::init()
{
	qmlRegisterSingletonType<QObject>("GCompris", 1, 0, "ActivityInfoTree", menuTreeProvider);
	qmlRegisterType<ActivityInfo>("GCompris", 1, 0, "ActivityInfo");
}
