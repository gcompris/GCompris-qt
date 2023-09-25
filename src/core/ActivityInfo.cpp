/* GCompris - ActivityInfo.cpp
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include "ActivityInfo.h"

#include <QFile>
#include <QtDebug>
#include <QQmlProperty>
#include <QQmlEngine>
#include <QQmlComponent>

#include "ApplicationSettings.h"

ActivityInfo::ActivityInfo(QObject *parent) :
    QObject(parent),
    m_difficulty(0),
    m_minimalDifficulty(0),
    m_maximalDifficulty(0),
    m_favorite(false),
    m_enabled(true),
    m_createdInVersion(0)
{
}

QString ActivityInfo::name() const
{
    return m_name;
}

void ActivityInfo::setName(const QString &name)
{
    m_name = name;
    // Once we are given a name, we can get the favorite property
    // from the persistant configuration
    m_favorite = ApplicationSettings::getInstance()->isFavorite(m_name);

    setCurrentLevels();

    Q_EMIT nameChanged();
}

QString ActivityInfo::section() const
{
    return m_section;
}
void ActivityInfo::setSection(const QString &section)
{
    m_section = section;
    Q_EMIT sectionChanged();
}

quint32 ActivityInfo::difficulty() const
{
    return m_difficulty;
}
void ActivityInfo::setDifficulty(const quint32 &difficulty)
{
    m_difficulty = difficulty;
    Q_EMIT difficultyChanged();
}

quint32 ActivityInfo::minimalDifficulty() const
{
    return m_minimalDifficulty;
}
void ActivityInfo::setMinimalDifficulty(const quint32 &minimalDifficulty)
{
    m_minimalDifficulty = minimalDifficulty;
    Q_EMIT minimalDifficultyChanged();
}

quint32 ActivityInfo::maximalDifficulty() const
{
    return m_maximalDifficulty;
}
void ActivityInfo::setMaximalDifficulty(const quint32 &maximalDifficulty)
{
    m_maximalDifficulty = maximalDifficulty;
    Q_EMIT maximalDifficultyChanged();
}

QString ActivityInfo::icon() const
{
    return m_icon;
}
void ActivityInfo::setIcon(const QString &icon)
{
    m_icon = icon;
    Q_EMIT iconChanged();
}

QString ActivityInfo::author() const
{
    return m_author;
}
void ActivityInfo::setAuthor(const QString &author)
{
    m_author = author;
    Q_EMIT authorChanged();
}

QString ActivityInfo::title() const
{
    return m_title;
}
void ActivityInfo::setTitle(const QString &title)
{
    m_title = title;
    Q_EMIT titleChanged();
}

QString ActivityInfo::description() const
{
    return m_description;
}
void ActivityInfo::setDescription(const QString &description)
{
    m_description = description;
    Q_EMIT descriptionChanged();
}

QString ActivityInfo::goal() const
{
    return m_goal;
}
void ActivityInfo::setGoal(const QString &goal)
{
    m_goal = goal;
    Q_EMIT goalChanged();
}

QString ActivityInfo::prerequisite() const
{
    return m_prerequisite;
}
void ActivityInfo::setPrerequisite(const QString &prerequisite)
{
    m_prerequisite = prerequisite;
    Q_EMIT prerequisiteChanged();
}

QString ActivityInfo::manual() const
{
    return m_manual;
}
void ActivityInfo::setManual(const QString &manual)
{
    m_manual = manual;
    Q_EMIT manualChanged();
}

QString ActivityInfo::credit() const
{
    return m_credit;
}
void ActivityInfo::setCredit(const QString &credit)
{
    m_credit = credit;
    Q_EMIT creditChanged();
}

bool ActivityInfo::favorite() const
{
    return m_favorite;
}
void ActivityInfo::setFavorite(const bool favorite)
{
    m_favorite = favorite;
    ApplicationSettings::getInstance()->setFavorite(m_name, m_favorite);
    Q_EMIT favoriteChanged();
}

bool ActivityInfo::enabled() const
{
    return m_enabled;
}
void ActivityInfo::setEnabled(const bool enabled)
{
    m_enabled = enabled;
    Q_EMIT enabledChanged();
}

int ActivityInfo::createdInVersion() const
{
    return m_createdInVersion;
}
void ActivityInfo::setCreatedInVersion(const int created)
{
    m_createdInVersion = created;
    Q_EMIT createdInVersionChanged();
}

QStringList ActivityInfo::levels() const
{
    return m_levels;
}

void ActivityInfo::setLevels(const QStringList &levels)
{
    // levels only contains one element containing all the difficulties
    m_levels = levels.front().split(',');

    setCurrentLevels();

    Q_EMIT levelsChanged();
}

void ActivityInfo::fillDatasets(QQmlEngine *engine)
{
    quint32 levelMin = ApplicationSettings::getInstance()->filterLevelMin();
    quint32 levelMax = ApplicationSettings::getInstance()->filterLevelMax();
    for (const QString &level: qAsConst(m_levels)) {
        QString url = QString("qrc:/gcompris/src/activities/%1/resource/%2/Data.qml").arg(m_name.split('/')[0], level);
        QQmlComponent componentRoot(engine, QUrl(url));
        QObject *objectRoot = componentRoot.create();
        if (objectRoot != nullptr) {
            Dataset *dataset = qobject_cast<Dataset *>(objectRoot);
            if (levelMin > dataset->difficulty() || levelMax < dataset->difficulty()) {
                dataset->setEnabled(false);
            }

            addDataset(level, dataset);
        }
        else {
            qDebug() << "ERROR: failed to load " << m_name << " " << componentRoot.errors();
        }
    }
    if (m_levels.empty()) {
        setMinimalDifficulty(m_difficulty);
        setMaximalDifficulty(m_difficulty);
    }
    else {
        computeMinMaxDifficulty();
    }
}

QStringList ActivityInfo::currentLevels() const
{
    return m_currentLevels;
}

void ActivityInfo::computeMinMaxDifficulty()
{
    if (m_currentLevels.empty() || m_datasets.empty()) {
        return;
    }
    quint32 minimalDifficultyFound = 100;
    quint32 maximalDifficultyFound = 0;
    for (const QString &datasetName: qAsConst(m_currentLevels)) {
        Dataset *data = getDataset(datasetName);
        if (minimalDifficultyFound > data->difficulty()) {
            minimalDifficultyFound = data->difficulty();
        }
        if (maximalDifficultyFound < data->difficulty()) {
            maximalDifficultyFound = data->difficulty();
        }
    }
    setMinimalDifficulty(minimalDifficultyFound);
    setMaximalDifficulty(maximalDifficultyFound);
}

void ActivityInfo::setCurrentLevels(const QStringList &currentLevels)
{
    m_currentLevels = currentLevels;
    computeMinMaxDifficulty();
    Q_EMIT currentLevelsChanged();
}

void ActivityInfo::setCurrentLevels()
{
    if (!m_name.isEmpty()) {
        // by default, activate all existing levels
        if (!m_levels.empty() && ApplicationSettings::getInstance()->currentLevels(m_name).empty()) {
            ApplicationSettings::getInstance()->setCurrentLevels(m_name, m_levels);
        }
        m_currentLevels = ApplicationSettings::getInstance()->currentLevels(m_name);
    }
    // Remove levels that could have been added in the configuration but are not existing
    // Either we rename a dataset, or after working in another branch to add dataset and switching to a branch without it
    QStringList levelsToRemove;
    for (const QString &level: qAsConst(m_currentLevels)) {
        if (!m_levels.contains(level)) {
            qDebug() << QString("Invalid level %1 for activity %2, removing it").arg(level, m_name);
            levelsToRemove << level;
        }
    }
    for (const QString &level: qAsConst(levelsToRemove)) {
        m_currentLevels.removeOne(level);
    }
    computeMinMaxDifficulty();
}

void ActivityInfo::enableDatasetsBetweenDifficulties(quint32 levelMin, quint32 levelMax)
{
    QStringList newLevels;
    for (auto it = m_datasets.begin(); it != m_datasets.end(); ++it) {
        Dataset *dataset = it.value();
        if (levelMin <= dataset->difficulty() && dataset->difficulty() <= levelMax) {
            newLevels << it.key();
            dataset->setEnabled(true);
        }
        else {
            dataset->setEnabled(false);
        }
    }
    setCurrentLevels(newLevels);
    ApplicationSettings::getInstance()->setCurrentLevels(m_name, m_currentLevels, false);
}

void ActivityInfo::addDataset(const QString &name, Dataset *dataset)
{
    m_datasets[name] = dataset;
}

Dataset *ActivityInfo::getDataset(const QString &name) const
{
    return m_datasets[name];
}

bool ActivityInfo::hasConfig() const
{
    return QFile::exists(":/gcompris/src/activities/" + m_name.split('/')[0] + "/ActivityConfig.qml");
}

bool ActivityInfo::hasDataset() const
{
    return !m_levels.empty();
}

void ActivityInfo::resetLevels()
{
    enableDatasetsBetweenDifficulties(1, 6);
}

#include "moc_ActivityInfo.cpp"
