#include <QtDebug>
#include <QQmlProperty>
#include <QQmlComponent>
#include <QResource>
#include <QCoreApplication>

#include "ActivityInfoTree.h"
#include "ApplicationInfo.h"

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

void ActivityInfoTree::sortByDifficulty()
{
	qSort(m_menuTree.begin(), m_menuTree.end(), SortByDifficulty());
}

void ActivityInfoTree::sortByName()
{
	qSort(m_menuTree.begin(), m_menuTree.end(), SortByName());
}

QObject *ActivityInfoTree::menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(scriptEngine)

	ActivityInfoTree *menuTree = new ActivityInfoTree(NULL);

	QQmlComponent componentRoot(engine,
								QUrl("qrc:/gcompris/src/activities/menu/ActivityInfo.qml"));
	QObject *objectRoot = componentRoot.create();
	menuTree->setRootMenu(qobject_cast<ActivityInfo*>(objectRoot));


    QFile file(":/gcompris/src/activities/activities.txt");
	if(!file.open(QFile::ReadOnly)) {
		qDebug() << "Failed to load the activity list";
	}
	QTextStream in(&file);
	while (!in.atEnd())
	{
		QString line = in.readLine();
		if(!line.startsWith("#")) {
			QString url = QString("qrc:/gcompris/src/activities/%1/ActivityInfo.qml").arg(line);

			if(!QResource::registerResource(
				   ApplicationInfo::getFilePath(line + ".rcc")))
				qDebug() << "Failed to load the resource file " << line + ".rcc";

			QQmlComponent componentRoot(engine,	QUrl(url));
			QObject *objectRoot = componentRoot.create();
			if(objectRoot) {
				menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(objectRoot));
			}
		}
	}
	file.close();

	menuTree->sortByDifficulty();
	return menuTree;
}

void ActivityInfoTree::init()
{
	if(!QResource::registerResource(ApplicationInfo::getFilePath("core.rcc")))
		qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("core.rcc");

	if(!QResource::registerResource(ApplicationInfo::getFilePath("menu.rcc")))
		qDebug() << "Failed to load the resource file menu.rcc";

	qmlRegisterSingletonType<QObject>("GCompris", 1, 0, "ActivityInfoTree", menuTreeProvider);
	qmlRegisterType<ActivityInfo>("GCompris", 1, 0, "ActivityInfo");
}

