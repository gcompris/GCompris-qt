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
#include <QList>
#include <QDir>

class ActivityInfoTree : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ActivityInfo *rootMenu READ getRootMenu CONSTANT)
    Q_PROPERTY(QQmlListProperty<ActivityInfo> menuTreeFull READ getMenuTreeFull CONSTANT)
    Q_PROPERTY(QQmlListProperty<ActivityInfo> menuTree READ menuTree NOTIFY menuTreeChanged)
    Q_PROPERTY(ActivityInfo *currentActivity READ getCurrentActivity WRITE setCurrentActivity NOTIFY currentActivityChanged)
    Q_PROPERTY(QVariantList characters READ allCharacters CONSTANT)
    /**
     * Specify the activity to start on when running GCompris if --launch is specified in command-line.
     */
    Q_PROPERTY(QString startingActivity MEMBER m_startingActivity NOTIFY startingActivityChanged)
    Q_PROPERTY(int startingLevel MEMBER m_startingLevel NOTIFY startingLevelChanged)
public:
    static ActivityInfoTree *getInstance()
    {
        if (!m_instance) {
            m_instance = new ActivityInfoTree();
        }
        return m_instance;
    }
    QQmlListProperty<ActivityInfo> menuTree();
    QQmlListProperty<ActivityInfo> getMenuTreeFull();
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

    static void setStartingActivity(const QString &startingActivity, int startingLevel)
    {
        m_startingActivity = startingActivity;
        m_startingLevel = startingLevel;
    }

protected:
    static ActivityInfoTree *m_instance;

public Q_SLOTS:
    Q_INVOKABLE void minMaxFiltersChanged(quint32 levelMin, quint32 levelMax, bool doSynchronize = true);
    Q_INVOKABLE void filterByTag(const QString &tag, const QString &category = "", bool emitChanged = true);
    Q_INVOKABLE void resetLevels(const QString &activity);

protected Q_SLOTS:
    Q_INVOKABLE void filterEnabledActivities(bool emitChanged = true);
    // create a tree from the whole list of activities with the activities created between the two versions
    Q_INVOKABLE void filterCreatedWithinVersions(int firstVersion, int lastVersion,
                                                 bool emitChanged = true);
    Q_INVOKABLE void filterBySearch(const QString &text);
    Q_INVOKABLE void filterByDifficulty(quint32 levelMin, quint32 levelMax);
    Q_INVOKABLE void setCurrentActivityFromName(const QString &name);

Q_SIGNALS:
    void menuTreeChanged();
    void currentActivityChanged();
    void allCharactersChanged();
    void startingActivityChanged();
    void startingLevelChanged();

private:
    explicit ActivityInfoTree(QObject *parent = nullptr);

    // this is the full activity list, it never changes
    QList<ActivityInfo *> m_menuTreeFull;
    // represents the Menu view and can be filtered
    QList<ActivityInfo *> m_menuTree;
    ActivityInfo *m_rootMenu;
    ActivityInfo *m_currentActivity;
    QVariantList m_keyboardCharacters;
    static QString m_startingActivity;
    static int m_startingLevel;

    static QList<ActivityInfo>::size_type menuTreeCount(QQmlListProperty<ActivityInfo> *property);
    static ActivityInfo *menuTreeAt(QQmlListProperty<ActivityInfo> *property, QList<ActivityInfo>::size_type index);

    static QList<ActivityInfo>::size_type menuTreeFullCount(QQmlListProperty<ActivityInfo> *property);
    static ActivityInfo *menuTreeFullAt(QQmlListProperty<ActivityInfo> *property, QList<ActivityInfo>::size_type index);

    static QStringList getActivityList();

public:
    static void registerResources();
    static QObject *menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
    void exportAsSQL();
    void listActivities();
};

#endif // ACTIVITYINFOTREE_H
