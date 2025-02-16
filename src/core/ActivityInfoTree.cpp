/* GCompris - ActivityInfoTree.cpp
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
#include <QLatin1StringView>

ActivityInfoTree *ActivityInfoTree::m_instance = nullptr;

ActivityInfoTree::ActivityInfoTree(QObject *parent) :
    QObject(parent),
    m_rootMenu(nullptr),
    m_currentActivity(nullptr)
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
    return { this, nullptr, &menuTreeCount, &menuTreeAt };
}

QList<ActivityInfo>::size_type ActivityInfoTree::menuTreeCount(QQmlListProperty<ActivityInfo> *property)
{
    ActivityInfoTree *obj = qobject_cast<ActivityInfoTree *>(property->object);
    if (obj != nullptr)
        return obj->m_menuTree.count();

    return 0;
}

ActivityInfo *ActivityInfoTree::menuTreeAt(QQmlListProperty<ActivityInfo> *property, QList<ActivityInfo>::size_type index)
{
    ActivityInfoTree *obj = qobject_cast<ActivityInfoTree *>(property->object);
    if (obj != nullptr)
        return obj->m_menuTree.at(index);

    return nullptr;
}

QQmlListProperty<ActivityInfo> ActivityInfoTree::getMenuTreeFull()
{
    return { this, nullptr, &menuTreeFullCount, &menuTreeFullAt };
}

QList<ActivityInfo>::size_type ActivityInfoTree::menuTreeFullCount(QQmlListProperty<ActivityInfo> *property)
{
    ActivityInfoTree *obj = qobject_cast<ActivityInfoTree *>(property->object);
    if (obj != nullptr)
        return obj->m_menuTreeFull.count();

    return 0;
}

ActivityInfo *ActivityInfoTree::menuTreeFullAt(QQmlListProperty<ActivityInfo> *property, QList<ActivityInfo>::size_type index)
{
    ActivityInfoTree *obj = qobject_cast<ActivityInfoTree *>(property->object);
    if (obj != nullptr)
        return obj->m_menuTreeFull.at(index);

    return nullptr;
}

ActivityInfo *ActivityInfoTree::menuTree(int index) const
{
    return m_menuTree.at(index);
}

void ActivityInfoTree::setCurrentActivityFromName(const QString &name)
{
    const auto &constMenuTreeFull = m_menuTreeFull;
    for (const auto &activity: constMenuTreeFull) {
        if (activity->name() == name) {
            m_currentActivity = activity;
            Q_EMIT currentActivityChanged();
            break;
        }
    }
}

void ActivityInfoTree::setCurrentActivity(ActivityInfo *currentActivity)
{
    m_currentActivity = currentActivity;
    Q_EMIT currentActivityChanged();
}

ActivityInfo *ActivityInfoTree::getCurrentActivity() const
{
    return m_currentActivity;
}

void ActivityInfoTree::menuTreeAppend(ActivityInfo *menu)
{
    m_menuTreeFull.append(menu);
}

void ActivityInfoTree::sortByDifficultyThenName(bool emitChanged)
{
    std::sort(m_menuTree.begin(), m_menuTree.end(),
              [](const ActivityInfo *a, const ActivityInfo *b) {
                  /* clang-format off */
                  return (a->minimalDifficulty() < b->minimalDifficulty()) ||
                         (a->minimalDifficulty() == b->minimalDifficulty() && (a->name() < b->name()));
                  /* clang-format on */
              });
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

// Filter the current activity list by the given tag
// the tag 'all' means no filter
// the tag 'favorite' means only marked as favorite
// The level is also filtered based on the global property
void ActivityInfoTree::filterByTag(const QString &tag, const QString &category, bool emitChanged)
{
    using namespace Qt::Literals::StringLiterals;

    m_menuTree.clear();
    // https://www.kdab.com/goodbye-q_foreach/, for loops on QList may cause detach
    const auto constMenuTreeFull = m_menuTreeFull;
    const bool isAllTag = (tag == "all"_L1);
    const bool isFavoriteTag = (tag == "favorite"_L1);
    for (const auto &activity: constMenuTreeFull) {
        // filter on category if given else on tag
        /* clang-format off */
        if((isAllTag ||
            (isFavoriteTag && activity->favorite()) ||
            (!category.isEmpty() && activity->section().indexOf(category) != -1) ||
            (category.isEmpty() && activity->section().indexOf(tag) != -1)
            ) &&
            (activity->maximalDifficulty() >= ApplicationSettings::getInstance()->filterLevelMin() &&
             activity->minimalDifficulty() <= ApplicationSettings::getInstance()->filterLevelMax())) {
            m_menuTree.push_back(activity);
        }
        /* clang-format on */
    }
    sortByDifficultyThenName(false);
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

bool ActivityInfoTree::launchedActivityMissGivenDifficulty() const{
    bool activityMissDifficulty = true;
    const auto constMenuTreeFull = m_menuTreeFull;
    for (const auto &activity: constMenuTreeFull) {
        if (activity->name() == m_startingActivity) {
            if (activity->maximalDifficulty() >= ApplicationSettings::getInstance()->filterLevelMin() &&
                activity->minimalDifficulty() <= ApplicationSettings::getInstance()->filterLevelMax()) {
                activityMissDifficulty = false;
            }
            break;
        }
    }
    return activityMissDifficulty;
}

void ActivityInfoTree::filterByDifficulty(quint32 levelMin, quint32 levelMax)
{
    m_menuTree.removeIf([&](const ActivityInfo *activity) {
                                 return activity->minimalDifficulty() < levelMin || activity->maximalDifficulty() > levelMax;
                             });
}

void ActivityInfoTree::filterEnabledActivities(bool emitChanged)
{
    m_menuTree.removeIf([](const ActivityInfo *activity) { return !activity->enabled(); });
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::filterCreatedWithinVersions(int firstVersion,
                                                   int lastVersion,
                                                   bool emitChanged)
{
    m_menuTree.clear();
    const auto constMenuTreeFull = m_menuTreeFull;
    for (const auto &activity: constMenuTreeFull) {
        if (firstVersion < activity->createdInVersion() && activity->createdInVersion() <= lastVersion) {
            m_menuTree.push_back(activity);
        }
    }
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::resetLevels(const QString &activityName)
{
    auto activityIterator = std::find_if(m_menuTreeFull.begin(), m_menuTreeFull.end(), [&activityName](const ActivityInfo *value) {
        return activityName == value->name();
    });
    if (activityIterator == m_menuTreeFull.end()) {
        // We didn't find the activity
        return;
    }
    ActivityInfo *activity = *activityIterator;
    activity->resetLevels();
}

void ActivityInfoTree::exportAsSQL()
{
    QTextStream qtOut(stdout);

    ApplicationSettings::getInstance()->setFilterLevelMin(1);
    ApplicationSettings::getInstance()->setFilterLevelMax(6);
    filterByTag("all");

    qtOut << "CREATE TABLE activities ("
          << "id INT UNIQUE, "
          << "name TEXT,"
          << "section TEXT,"
          << "author TEXT,"
          << "difficulty INT,"
          << "icon TEXT,"
          << "title TEXT,"
          << "description TEXT,"
          << "prerequisite TEXT,"
          << "goal TEXT,"
          << "manual TEXT,"
          << "credit TEXT);\n";
    qtOut << "DELETE FROM activities\n";

    int i(0);
    const auto constMenuTree = m_menuTree;
    for (const auto &activity: constMenuTree) {
        qtOut << "INSERT INTO activities VALUES(" << i++ << ", "
              << "'" << activity->name() << "', "
              << "'" << activity->section() << "', "
              << "'" << activity->author() << "', " << activity->difficulty() << ", "
              << "'" << activity->icon() << "', "
              << "\"" << activity->title() << "\", "
              << "\"" << activity->description() << "\", "
              << "\"" << activity->prerequisite() << "\", "
              << "\"" << activity->goal().toHtmlEscaped() << "\", "
              << "\"" << activity->manual().toHtmlEscaped() << "\", "
              << "\"" << activity->credit() << ");\n";
    }
    qtOut.flush();
}

void ActivityInfoTree::listActivities()
{
    QTextStream qtOut(stdout);
    const QStringList list = getActivityList();
    for (const QString &activity: list) {
        qtOut << activity << '\n';
    }
    qtOut.flush();
}

QStringList ActivityInfoTree::getActivityList()
{
    QStringList list;
    QFile file(":/gcompris/src/activities/activities_out.txt");
    if (!file.open(QFile::ReadOnly)) {
        qDebug() << "Failed to load the activity list";
        return list;
    }
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (!line.startsWith(QLatin1String("#"))) {
            list << line;
        }
    }
    file.close();
    return list;
}

void ActivityInfoTree::initialize(QQmlEngine *engine)
{
    QQmlComponent componentRoot(engine,
                                QUrl("qrc:/gcompris/src/activities/menu/ActivityInfo.qml"));
    QObject *objectRoot = componentRoot.create();
    setRootMenu(qobject_cast<ActivityInfo *>(objectRoot));

    const QStringList activities = getActivityList();
    QString startingActivity = m_startingActivity;
    for (const QString &line: activities) {
        QString url = QString("qrc:/gcompris/src/activities/%1/ActivityInfo.qml").arg(line);

#ifdef WITH_RCC
        if (!QResource::registerResource(
                ApplicationInfo::getFilePath(line + ".rcc")))
            qDebug() << "Failed to load the resource file " << line + ".rcc";
#endif

        QQmlComponent activityComponentRoot(engine, QUrl(url));
        QObject *activityObjectRoot = activityComponentRoot.create();
        if (activityObjectRoot != nullptr) {
            ActivityInfo *activityInfo = qobject_cast<ActivityInfo *>(activityObjectRoot);
            activityInfo->fillDatasets(engine);
            menuTreeAppend(activityInfo);

            // Check if the activity is the one we want to start in and set the full name
            if (!startingActivity.isEmpty() && startingActivity == line) {
                startingActivity = activityInfo->name();
            }
        }
        else {
            qDebug() << "ERROR: failed to load " << line << " " << activityComponentRoot.errors();
        }

#if !__ANDROID__
        // As we need to load the qml files within the main thread, we need to process the events so
        // the qml loading screen is active and do not only display a white screen
        QCoreApplication::processEvents();
#endif
    }

    // In case we have asked for a specific activity to start but the activity does not exist, we reinitialise the value
    if (m_startingActivity == startingActivity) {
        m_startingActivity = "";
    }
    else {
        m_startingActivity = startingActivity;
    }

    filterByTag("favorite", "", false);
    filterEnabledActivities(true);
}

ActivityInfoTree *ActivityInfoTree::create(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(scriptEngine)

    ActivityInfoTree *menuTree = getInstance();
    return menuTree;
}

void ActivityInfoTree::registerResources()
{
#ifdef WITH_RCC
    if (!QResource::registerResource(ApplicationInfo::getFilePath("core.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("core.rcc");

    if (!QResource::registerResource(ApplicationInfo::getFilePath("menu.rcc")))
        qDebug() << "Failed to load the resource file menu.rcc";
#endif
    if (!QResource::registerResource(ApplicationInfo::getFilePath("activities.rcc")))
        qDebug() << "Failed to load the resource file activities.rcc";
}

void ActivityInfoTree::filterBySearch(const QString &text)
{
    m_menuTree.clear();
    if (!text.trimmed().isEmpty()) {
        // perform search on each word entered in the searchField
        const QStringList wordsList = text.split(' ', Qt::SkipEmptyParts);
        for (const QString &searchTerm: wordsList) {
            const QString trimmedText = searchTerm.trimmed();
            const auto &constMenuTreeFull = m_menuTreeFull;
            for (const auto &activity: constMenuTreeFull) {
                /* clang-format off */
                if (activity->title().remove(QChar::SoftHyphen).contains(trimmedText, Qt::CaseInsensitive) ||
                    activity->name().remove(QChar::SoftHyphen).contains(trimmedText, Qt::CaseInsensitive) ||
                    activity->description().remove(QChar::SoftHyphen).contains(trimmedText, Qt::CaseInsensitive)) {
                    /* clang-format on */
                    // add the activity only if it's not added
                    if (m_menuTree.indexOf(activity) == -1)
                        m_menuTree.push_back(activity);
                }
            }
        }
    }
    else {
        m_menuTree = m_menuTreeFull;
    }

    filterEnabledActivities(false);
    filterByDifficulty(ApplicationSettings::getInstance()->filterLevelMin(), ApplicationSettings::getInstance()->filterLevelMax());
    sortByDifficultyThenName(false);
    Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::minMaxFiltersChanged(quint32 levelMin, quint32 levelMax, bool doSynchronize)
{
    for (ActivityInfo *activity: std::as_const(m_menuTreeFull)) {
        activity->enableDatasetsBetweenDifficulties(levelMin, levelMax);
    }
    if (doSynchronize) {
        ApplicationSettings::getInstance()->sync();
    }
}

QVariantList ActivityInfoTree::allCharacters()
{
    QSet<QChar> keyboardChars;
    const auto constMenuTreeFull = m_menuTreeFull;
    for (const auto &tree: constMenuTreeFull) {
        const QString &title = tree->title();
        for (const QChar &letter: title) {
            if (letter.isLetterOrNumber() || letter == QLatin1Char('\'') || letter == QLatin1Char('-')) {
                keyboardChars.insert(letter.toLower());
            }
        }
    }
    QVariantList keyboardCharacters;
    for (const QChar &letters: keyboardChars) {
        keyboardCharacters.push_back(letters);
    }
    std::sort(keyboardCharacters.begin(), keyboardCharacters.end(), [](const QVariant &v1, const QVariant &v2) {
        return ApplicationInfo::getInstance()->localeCompare(v1.toString(), v2.toString()) < 0;
    });

    return keyboardCharacters;
}

#include "moc_ActivityInfoTree.cpp"
