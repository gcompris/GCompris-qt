#ifndef MENUTREE_H
#define MENUTREE_H

#include <qqml.h>
#include "ActivityInfo.h"
#include <QQmlEngine>
#include <QDir>

class ActivityInfoTree : public QObject
{
	Q_OBJECT
	Q_PROPERTY(ActivityInfo* rootMenu READ getRootMenu CONSTANT)
	Q_PROPERTY(QQmlListProperty<ActivityInfo> menuTree READ menuTree NOTIFY menuTreeChanged)
    Q_PROPERTY(ActivityInfo* currentActivity READ getCurrentActivity WRITE setCurrentActivity NOTIFY currentActivityChanged)
public:
	ActivityInfoTree(QObject *parent = 0);
	QQmlListProperty<ActivityInfo> menuTree();
	int menuTreeCount() const;
	ActivityInfo *getRootMenu() const;
	void setRootMenu(ActivityInfo *rootMenu);
	ActivityInfo *menuTree(int) const;
	void setCurrentActivity(ActivityInfo *currentActivity);
	ActivityInfo *getCurrentActivity() const;
	ActivityInfo *getParentActivity(ActivityInfo *root, ActivityInfo *menu);
	void menuTreeAppend(ActivityInfo *menu);
	void menuTreeAppend(QQmlEngine *engine,
						const QDir &menuDir, const QString &menuFile);
	void sortByDifficulty();
	void sortByName();

protected slots:
    Q_INVOKABLE void filterByTag(const QString &tag);

signals:
	void menuTreeChanged();
	void currentActivityChanged();

private:
    // this is the full activity list, it never changes
    QList<ActivityInfo *> m_menuTreeFull;
    // represents the Menu view and can be filtered
    QList<ActivityInfo *> m_menuTree;
    ActivityInfo *m_rootMenu;
	ActivityInfo *m_currentActivity;

	struct SortByDifficulty
	{
		bool operator()(const ActivityInfo *a, const ActivityInfo *b) const
		{
			return a->difficulty() < b->difficulty();
		}
	};

	struct SortByName
	{
		bool operator()(const ActivityInfo *a, const ActivityInfo *b) const
		{
			return a->name() < b->name();
		}
	};

public:
	static void init();
	static QObject *menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine);

};

#endif // MENUTREE_H
