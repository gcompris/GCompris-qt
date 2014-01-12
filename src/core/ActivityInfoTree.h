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
public:
	ActivityInfoTree(QObject *parent = 0);
	QQmlListProperty<ActivityInfo> menuTree();
	int menuTreeCount() const;
	ActivityInfo *getRootMenu() const;
	void setRootMenu(ActivityInfo *rootMenu);
	ActivityInfo *menuTree(int) const;
	ActivityInfo *getParentActivity(ActivityInfo *root, ActivityInfo *menu);
	void menuTreeAppend(ActivityInfo *menu);
	void menuTreeAppend(QQmlEngine *engine,
						const QDir &menuDir, const QString &menuFile);
signals:
	void menuTreeChanged();

private:
	QList<ActivityInfo *> m_menuTree;
	ActivityInfo *m_rootMenu;

public:
	static void init();
	static QObject *menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine);

};

#endif // MENUTREE_H
