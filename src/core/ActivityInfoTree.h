/* GCompris - ActivityInfoTree.h
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef ACTIVITYINFOTREE_H
#define ACTIVITYINFOTREE_H

#include "ActivityInfo.h"
#include <QQmlEngine>
#include <QDir>

class ActivityInfoTree : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ActivityInfo *rootMenu READ getRootMenu CONSTANT)
    Q_PROPERTY(QQmlListProperty<ActivityInfo> menuTree READ menuTree NOTIFY menuTreeChanged)
    Q_PROPERTY(ActivityInfo *currentActivity READ getCurrentActivity WRITE setCurrentActivity NOTIFY currentActivityChanged)
    Q_PROPERTY(QVariantList characters READ allCharacters CONSTANT)

public:
    explicit ActivityInfoTree(QObject *parent = 0);
    QQmlListProperty<ActivityInfo> menuTree();
    ActivityInfo *getRootMenu() const;
    void setRootMenu(ActivityInfo *rootMenu);
    ActivityInfo *menuTree(int) const;
    void setCurrentActivity(ActivityInfo *currentActivity);
    ActivityInfo *getCurrentActivity() const;
    void menuTreeAppend(ActivityInfo *menu);
    void menuTreeAppend(QQmlEngine *engine,
                        const QDir &menuDir, const QString &menuFile);
    void sortByDifficultyThenName(bool emitChanged = true);
    QVariantList allCharacters();

protected Q_SLOTS:
    Q_INVOKABLE void filterByTag(const QString &tag, const QString &category = "", bool emitChanged = true);
    Q_INVOKABLE void filterEnabledActivities(bool emitChanged = true);
    // create a tree from the whole list of activities with the activities created between the two versions
    Q_INVOKABLE void filterCreatedWithinVersions(int firstVersion, int lastVersion,
                                                 bool emitChanged = true);
    Q_INVOKABLE void filterBySearch(const QString &text);
    Q_INVOKABLE void filterByDifficulty(quint32 levelMin, quint32 levelMax);
    Q_INVOKABLE void minMaxFiltersChanged(quint32 levelMin, quint32 levelMax, bool emitChanged = true);

signals:
    void menuTreeChanged();
    void currentActivityChanged();
    void allCharactersChanged();

private:
    // this is the full activity list, it never changes
    QList<ActivityInfo *> m_menuTreeFull;
    // represents the Menu view and can be filtered
    QList<ActivityInfo *> m_menuTree;
    ActivityInfo *m_rootMenu;
    ActivityInfo *m_currentActivity;
    QVariantList m_keyboardCharacters;
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    static qsizetype menuTreeCount(QQmlListProperty<ActivityInfo> *property);
    static ActivityInfo *menuTreeAt(QQmlListProperty<ActivityInfo> *property, qsizetype index);
#else
    static int menuTreeCount(QQmlListProperty<ActivityInfo> *property);
    static ActivityInfo *menuTreeAt(QQmlListProperty<ActivityInfo> *property, int index);
#endif

public:
    static void registerResources();
    static QObject *menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
    void exportAsSQL();
};

#endif // ACTIVITYINFOTREE_H
