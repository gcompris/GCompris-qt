#include <QtDebug>
#include <QQmlProperty>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QDir>

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
	QDir menuDir("../gcompris-qt/menus", "*.qml");
	qDebug() << menuDir.absolutePath();
	QStringList list = menuDir.entryList();
	for (int i = 0; i < list.size(); ++i) {
		QString menuFile = menuDir.absolutePath() + "/" + list.at(i);

		QQmlComponent component(engine,
				QUrl::fromLocalFile(menuFile));
		QObject *object = component.create();
		if(component.isReady()) {
			if(QQmlProperty::read(object, "section").toString() == "") {
				QQmlProperty::write(object, "dir", menuDir.absolutePath());
				menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(object));
			}
		} else {
			qDebug() << menuFile << ": Failed to load";
		}

	}
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
