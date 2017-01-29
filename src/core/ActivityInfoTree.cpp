/* GCompris - ActivityInfoTree.cpp
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
#include "ActivityInfoTree.h"
#include "ApplicationInfo.h"

#include <QtDebug>
#include <QQmlProperty>
#include <QQmlComponent>
#include <QResource>
#include <QStandardPaths>
#include <QCoreApplication>
#include <QTextStream>

ActivityInfoTree::ActivityInfoTree(QObject *parent) : QObject(parent),
	m_currentActivity(NULL)
{
}

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
    return QQmlListProperty<ActivityInfo>(this, NULL, &menuTreeCount, &menuTreeAt);
}

int ActivityInfoTree::menuTreeCount(QQmlListProperty<ActivityInfo> *property)
{
    ActivityInfoTree *obj = qobject_cast<ActivityInfoTree*>(property->object);
    if(obj)
        return obj->m_menuTree.count();
    else
        return 0;
}

ActivityInfo *ActivityInfoTree::menuTreeAt(QQmlListProperty<ActivityInfo> *property, int index)
{
    ActivityInfoTree *obj = qobject_cast<ActivityInfoTree*>(property->object);
    if(obj)
        return obj->m_menuTree.at(index);
    else
        return 0;
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
    m_menuTreeFull.append(menu);
}

void ActivityInfoTree::menuTreeAppend(QQmlEngine *engine,
                                      const QDir &menuDir, const QString &menuFile)
{
    QQmlComponent component(engine,
                            QUrl::fromLocalFile(menuDir.absolutePath() + '/' + menuFile));
    QObject *object = component.create();
    if(component.isReady()) {
        if(QQmlProperty::read(object, "section").toString() == "/") {
            menuTreeAppend(qobject_cast<ActivityInfo*>(object));
        }
    } else {
        qDebug() << menuFile << ": Failed to load";
    }
}

void ActivityInfoTree::sortByDifficulty(bool emitChanged)
{
    std::sort(m_menuTree.begin(), m_menuTree.end(), SortByDifficulty());
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::sortByName(bool emitChanged)
{
    std::sort(m_menuTree.begin(), m_menuTree.end(), SortByName());
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

// Filter the current activity list by the given tag
// the tag 'all' means no filter
// the tag 'favorite' means only marked as favorite
// The level is also filtered based on the global property
void ActivityInfoTree::filterByTag(const QString &tag, bool emitChanged)
{
    m_menuTree.clear();
    for(const auto &activity: m_menuTreeFull) {
        if((activity->section().indexOf(tag) != -1 ||
            tag == "all" ||
            (tag == "favorite" && activity->favorite())) &&
            (activity->difficulty() >= ApplicationSettings::getInstance()->filterLevelMin() &&
             activity->difficulty() <= ApplicationSettings::getInstance()->filterLevelMax())) {
            m_menuTree.push_back(activity);
        }
    }
    sortByDifficulty();
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::filterByDifficulty(int levelMin, int levelMax)
{
    auto it = std::remove_if(m_menuTree.begin(), m_menuTree.end(),
                             [&](const ActivityInfo* activity) {
                                 return activity->difficulty() < levelMin || activity->difficulty() > levelMax;
                             });
    m_menuTree.erase(it, m_menuTree.end());
}

void ActivityInfoTree::filterLockedActivities(bool emitChanged)
{
    // If we have the full version or if we show all the activities, we don't need to do anything
    if(!ApplicationSettings::getInstance()->isDemoMode() || ApplicationSettings::getInstance()->showLockedActivities())
        return;

    // Remove non free activities if needed. We need to already have a menuTree filled!
    auto it = std::remove_if(m_menuTree.begin(), m_menuTree.end(),
                             [](const ActivityInfo* activity) { return !activity->demo(); });
    m_menuTree.erase(it, m_menuTree.end());
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::filterEnabledActivities(bool emitChanged)
{
    auto it = std::remove_if(m_menuTree.begin(), m_menuTree.end(),
                             [](const ActivityInfo* activity) { return !activity->enabled(); });
    m_menuTree.erase(it, m_menuTree.end());
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::filterCreatedWithinVersions(int firstVersion,
                                                   int lastVersion,
                                                   bool emitChanged)
{
    m_menuTree.clear();
    for(const auto &activity: m_menuTreeFull) {
        if(firstVersion < activity->createdInVersion() && activity->createdInVersion() <= lastVersion) {
            m_menuTree.push_back(activity);
        }
    }
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::exportAsSQL()
{
    QTextStream cout(stdout);

    ApplicationSettings::getInstance()->setFilterLevelMin(1);
    ApplicationSettings::getInstance()->setFilterLevelMax(6);
    filterByTag("all");

    cout << "CREATE TABLE activities (" <<
            "id INT UNIQUE, " <<
            "name TEXT," <<
            "section TEXT," <<
            "author TEXT," <<
            "difficulty INT," <<
            "icon TEXT," <<
            "title TEXT," <<
            "description TEXT," <<
            "prerequisite TEXT," <<
            "goal TEXT," <<
            "manual TEXT," <<
            "credit TEXT," <<
            "demo INT);" << endl;
    cout << "DELETE FROM activities" << endl;

    int i(0);
    for(const auto &activity: m_menuTree) {
        cout << "INSERT INTO activities VALUES(" <<
                i++ << ", " <<
                "'" << activity->name() << "', " <<
                "'" << activity->section() << "', " <<
                "'" << activity->author() << "', " <<
                activity->difficulty() << ", " <<
                "'" << activity->icon() << "', " <<
                "\"" << activity->title() << "\", " <<
                "\"" << activity->description() << "\", " <<
                "\"" << activity->prerequisite() << "\", " <<
                "\"" << activity->goal().toHtmlEscaped() << "\", " <<
                "\"" << activity->manual().toHtmlEscaped() << "\", " <<
                "\"" << activity->credit() << "\", " <<
                activity->demo() <<
                ");" << endl;
    }
}

QObject *ActivityInfoTree::menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(scriptEngine)

    ActivityInfoTree *menuTree = new ActivityInfoTree(NULL);
    QQmlComponent componentRoot(engine,
                                QUrl("qrc:/gcompris/src/activities/menu/ActivityInfo.qml"));
    QObject *objectRoot = componentRoot.create();
    menuTree->setRootMenu(qobject_cast<ActivityInfo*>(objectRoot));

    QFile file(":/gcompris/src/activities/activities_out.txt");
    if(!file.open(QFile::ReadOnly)) {
        qDebug() << "Failed to load the activity list";
    }
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if(!line.startsWith(QLatin1String("#"))) {
            QString url = QString("qrc:/gcompris/src/activities/%1/ActivityInfo.qml").arg(line);
            if(!QResource::registerResource(
                                            ApplicationInfo::getFilePath(line + ".rcc")))
                qDebug() << "Failed to load the resource file " << line + ".rcc";

            QQmlComponent componentRoot(engine, QUrl(url));
            QObject *objectRoot = componentRoot.create();
            if(objectRoot) {
                menuTree->menuTreeAppend(qobject_cast<ActivityInfo*>(objectRoot));
            } else {
                qDebug() << "ERROR: failed to load " << line << " " << componentRoot.errors();
            }
        }
    }
    file.close();

    menuTree->filterByTag("favorite");
    menuTree->filterLockedActivities();
    menuTree->filterEnabledActivities();
    return menuTree;
}

void ActivityInfoTree::init()
{
    if(!QResource::registerResource(ApplicationInfo::getFilePath("core.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("core.rcc");

    if(!QResource::registerResource(ApplicationInfo::getFilePath("menu.rcc")))
        qDebug() << "Failed to load the resource file menu.rcc";

    if(!QResource::registerResource(ApplicationInfo::getFilePath("activities.rcc")))
        qDebug() << "Failed to load the resource file activities.rcc";

    if(QResource::registerResource(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) +
                                   "/data2/" + QString("full-%1.rcc").arg(COMPRESSED_AUDIO)))
        qDebug() << "Registered the pre-download " << QString("full-%1.rcc").arg(COMPRESSED_AUDIO);

    qmlRegisterSingletonType<QObject>("GCompris", 1, 0, "ActivityInfoTree", menuTreeProvider);
    qmlRegisterType<ActivityInfo>("GCompris", 1, 0, "ActivityInfo");


}

void ActivityInfoTree::filterBySearch(const QString& text)
{
    m_menuTree.clear();
    if(!text.trimmed().isEmpty()) {
        // perform search on each word entered in the searchField
        QStringList wordsList = text.split(" ", QString::SkipEmptyParts);
        Q_FOREACH(const QString &searchTerm, wordsList) {
            const QString trimmedText = searchTerm.trimmed();
            for(const auto &activity: m_menuTreeFull) {
                if(activity->title().contains(trimmedText, Qt::CaseInsensitive) ||
                    activity->name().contains(trimmedText, Qt::CaseInsensitive) ||
                    activity->description().contains(trimmedText, Qt::CaseInsensitive)) {

                    // add the activity only if it's not added
                    if(m_menuTree.indexOf(activity) == -1)
                        m_menuTree.push_back(activity);
                }
            }
        }
    }
    else
        m_menuTree = m_menuTreeFull;

    filterEnabledActivities(false);
    filterLockedActivities(false);
    filterByDifficulty(ApplicationSettings::getInstance()->filterLevelMin(), ApplicationSettings::getInstance()->filterLevelMax());
    sortByDifficulty(false);
    Q_EMIT menuTreeChanged();
}

QVariantList ActivityInfoTree::allCharacters() {
    QSet<QChar> keyboardChars;
    for(auto &tree: m_menuTreeFull) {
        const QString &title = tree->title();
        Q_FOREACH(const QChar &letter, title) {
            if(!letter.isSpace() && !letter.isPunct()) {
                keyboardChars.insert(letter.toLower());
            }
        }
    }
    Q_FOREACH(const QString &letters, keyboardChars) {
        m_keyboardCharacters.push_back(letters);
    }
    std::sort(m_keyboardCharacters.begin(), m_keyboardCharacters.end());

    return m_keyboardCharacters;
}

