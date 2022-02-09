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

#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
qsizetype ActivityInfoTree::menuTreeCount(QQmlListProperty<ActivityInfo> *property)
#else
int ActivityInfoTree::menuTreeCount(QQmlListProperty<ActivityInfo> *property)
#endif
{
    ActivityInfoTree *obj = qobject_cast<ActivityInfoTree *>(property->object);
    if (obj != nullptr)
        return obj->m_menuTree.count();

    return 0;
}

#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
ActivityInfo *ActivityInfoTree::menuTreeAt(QQmlListProperty<ActivityInfo> *property, qsizetype index)
#else
ActivityInfo *ActivityInfoTree::menuTreeAt(QQmlListProperty<ActivityInfo> *property, int index)
#endif
{
    ActivityInfoTree *obj = qobject_cast<ActivityInfoTree *>(property->object);
    if (obj != nullptr)
        return obj->m_menuTree.at(index);

    return nullptr;
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
    if (component.isReady()) {
        if (QQmlProperty::read(object, "section").toString() == "/") {
            menuTreeAppend(qobject_cast<ActivityInfo *>(object));
        }
    }
    else {
        qDebug() << menuFile << ": Failed to load";
    }
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
    m_menuTree.clear();
    // https://www.kdab.com/goodbye-q_foreach/, for loops on QList may cause detach
    const auto constMenuTreeFull = m_menuTreeFull;
    for (const auto &activity: constMenuTreeFull) {
        // filter on category if given else on tag
        /* clang-format off */
        if(((!category.isEmpty() && activity->section().indexOf(category) != -1) ||
            (category.isEmpty() && activity->section().indexOf(tag) != -1) ||
            tag == "all" ||
            (tag == "favorite" && activity->favorite())) &&
            (activity->maximalDifficulty() >= ApplicationSettings::getInstance()->filterLevelMin() &&
             activity->minimalDifficulty() <= ApplicationSettings::getInstance()->filterLevelMax())) {
            m_menuTree.push_back(activity);
        }
        /* clang-format on */
    }
    sortByDifficultyThenName();
    if (emitChanged)
        Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::filterByDifficulty(quint32 levelMin, quint32 levelMax)
{
    //todo fix here the difficulty filtering
    auto it = std::remove_if(m_menuTree.begin(), m_menuTree.end(),
                             [&](const ActivityInfo *activity) {
                                 return activity->minimalDifficulty() < levelMin || activity->maximalDifficulty() > levelMax;
                             });
    m_menuTree.erase(it, m_menuTree.end());
}

void ActivityInfoTree::filterEnabledActivities(bool emitChanged)
{
    auto it = std::remove_if(m_menuTree.begin(), m_menuTree.end(),
                             [](const ActivityInfo *activity) { return !activity->enabled(); });
    m_menuTree.erase(it, m_menuTree.end());
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

QObject *ActivityInfoTree::menuTreeProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(scriptEngine)

    ActivityInfoTree *menuTree = new ActivityInfoTree(nullptr);
    QQmlComponent componentRoot(engine,
                                QUrl("qrc:/gcompris/src/activities/menu/ActivityInfo.qml"));
    QObject *objectRoot = componentRoot.create();
    menuTree->setRootMenu(qobject_cast<ActivityInfo *>(objectRoot));

    QFile file(":/gcompris/src/activities/activities_out.txt");
    if (!file.open(QFile::ReadOnly)) {
        qDebug() << "Failed to load the activity list";
    }
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (!line.startsWith(QLatin1String("#"))) {
            QString url = QString("qrc:/gcompris/src/activities/%1/ActivityInfo.qml").arg(line);
            if (!QResource::registerResource(
                    ApplicationInfo::getFilePath(line + ".rcc")))
                qDebug() << "Failed to load the resource file " << line + ".rcc";

            QQmlComponent activityComponentRoot(engine, QUrl(url));
            QObject *activityObjectRoot = activityComponentRoot.create();
            if (activityObjectRoot != nullptr) {
                ActivityInfo *activityInfo = qobject_cast<ActivityInfo *>(activityObjectRoot);
                activityInfo->fillDatasets(engine);
                menuTree->menuTreeAppend(activityInfo);
            }
            else {
                qDebug() << "ERROR: failed to load " << line << " " << activityComponentRoot.errors();
            }
        }
    }
    file.close();

    menuTree->filterByTag("favorite");
    menuTree->filterEnabledActivities();
    return menuTree;
}

void ActivityInfoTree::registerResources()
{
    if (!QResource::registerResource(ApplicationInfo::getFilePath("core.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("core.rcc");

    if (!QResource::registerResource(ApplicationInfo::getFilePath("menu.rcc")))
        qDebug() << "Failed to load the resource file menu.rcc";

    if (!QResource::registerResource(ApplicationInfo::getFilePath("activities.rcc")))
        qDebug() << "Failed to load the resource file activities.rcc";

    if (QResource::registerResource(ApplicationSettings::getInstance()->cachePath() + "/data2/" + QString("full-%1.rcc").arg(COMPRESSED_AUDIO)))
        qDebug() << "Registered the pre-download " << QString("full-%1.rcc").arg(COMPRESSED_AUDIO);
}

void ActivityInfoTree::filterBySearch(const QString &text)
{
    m_menuTree.clear();
    if (!text.trimmed().isEmpty()) {
        // perform search on each word entered in the searchField
#if QT_VERSION >= QT_VERSION_CHECK(5, 15, 0)
        const QStringList wordsList = text.split(' ', Qt::SkipEmptyParts);
#else
        const QStringList wordsList = text.split(' ', QString::SkipEmptyParts);
#endif
        for (const QString &searchTerm: wordsList) {
            const QString trimmedText = searchTerm.trimmed();
            const auto &constMenuTreeFull = m_menuTreeFull;
            for (const auto &activity: constMenuTreeFull) {
                /* clang-format off */
                if (activity->title().contains(trimmedText, Qt::CaseInsensitive) ||
                    activity->name().contains(trimmedText, Qt::CaseInsensitive) ||
                    activity->description().contains(trimmedText, Qt::CaseInsensitive)) {
                    /* clang-format on */
                    // add the activity only if it's not added
                    if (m_menuTree.indexOf(activity) == -1)
                        m_menuTree.push_back(activity);
                }
            }
        }
    }
    else
        m_menuTree = m_menuTreeFull;

    filterEnabledActivities(false);
    filterByDifficulty(ApplicationSettings::getInstance()->filterLevelMin(), ApplicationSettings::getInstance()->filterLevelMax());
    sortByDifficultyThenName(false);
    Q_EMIT menuTreeChanged();
}

void ActivityInfoTree::minMaxFiltersChanged(quint32 levelMin, quint32 levelMax, bool emitChanged)
{
    for (ActivityInfo *activity: m_menuTreeFull) {
        activity->enableDatasetsBetweenDifficulties(levelMin, levelMax);
    }
    ApplicationSettings::getInstance()->sync();
}

QVariantList ActivityInfoTree::allCharacters()
{
    QSet<QChar> keyboardChars;
    const auto constMenuTreeFull = m_menuTreeFull;
    for (const auto &tree: constMenuTreeFull) {
        const QString &title = tree->title();
        for (const QChar &letter: title) {
            if (letter.isLetterOrNumber() || letter == QLatin1Char('-')) {
                keyboardChars.insert(letter.toLower());
            }
        }
    }
    for (const QChar &letters: keyboardChars) {
        m_keyboardCharacters.push_back(letters);
    }
    std::sort(m_keyboardCharacters.begin(), m_keyboardCharacters.end(), [](const QVariant &v1, const QVariant &v2) { return v1.toChar() < v2.toChar(); });

    return m_keyboardCharacters;
}
