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

#include <QDir>
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
    m_createdInVersion(0),
    m_acceptDataset(false)
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
    // from the persistent configuration
    m_favorite = ApplicationSettings::getInstance()->isFavorite(m_name);

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
    m_acceptDataset = true;
    m_levels = levels;

    Q_EMIT levelsChanged();
}

void ActivityInfo::fillDatasets(QQmlEngine *engine)
{
    /* If we switch from a previous version to one above or equals to 26.0
       we need to fill the ignoredLevels from the list of currentLevels stored
       in configuration.
       The currentLevels was previously used because we could not add external
       datasets (but with this approach we cannot disable them, thus we change
       to a list of ignored instead of currently used).
    */
    if (ApplicationSettings::getInstance()->getUpdateToNewIgnoreLevels()) {
        QStringList currentLevelsInConf = ApplicationSettings::getInstance()->currentLevels(m_name);
        if (!currentLevelsInConf.empty()) {
            for (const QString &level: m_levels) {
                if (!currentLevelsInConf.contains(level)) {
                    m_ignoredLevels << level;
                }
            }
        }
        if (!m_ignoredLevels.empty()) {
            ApplicationSettings::getInstance()->setIgnoredLevels(m_name.split('/')[0], m_ignoredLevels);
        }
    }

    m_ignoredLevels = ApplicationSettings::getInstance()->ignoredLevels(m_name.split('/')[0]);
    quint32 levelMin = ApplicationSettings::getInstance()->filterLevelMin();
    quint32 levelMax = ApplicationSettings::getInstance()->filterLevelMax();
    for (const QString &level: std::as_const(m_levels)) {
        QString url = QString("qrc:/gcompris/src/activities/%1/resource/%2/Data.qml").arg(m_name.split('/')[0], level);

        if (!QFileInfo::exists(url.sliced(3))) {
            qDebug() << "INFO: did not find level" << url.sliced(3) << "internally";
            removeDataset(level);
            continue;
        }

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

    // Load user created levels
    bool atLeastOneLevelAdded = false;
    const QString userDatasetPath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" + m_name.split('/')[0]);
    QDir userDatasetFolder(userDatasetPath);
    userDatasetFolder.setFilter(QDir::Dirs | QDir::NoSymLinks | QDir::NoDotAndDotDot);
    QFileInfoList datasetList = userDatasetFolder.entryInfoList();
    for (const QFileInfo &datasetFileInfo: datasetList) {
        QString url = QString("%1/Data.qml").arg(datasetFileInfo.absoluteFilePath());
        QQmlComponent componentRoot(engine, QUrl(url));
        QObject *objectRoot = componentRoot.create();
        if (objectRoot != nullptr) {
            Dataset *dataset = qobject_cast<Dataset *>(objectRoot);
            QString datasetName(datasetFileInfo.fileName());

            if (levelMin > dataset->difficulty() || levelMax < dataset->difficulty()) {
                dataset->setEnabled(false);
            }

            m_levels.push_back(datasetName);
            addDataset(datasetName, dataset);
            atLeastOneLevelAdded = true;
        }
        else {
            qDebug() << "ERROR: failed to load " << m_name << " " << componentRoot.errors();
        }
    }

    if (atLeastOneLevelAdded) {
        Q_EMIT levelsChanged();
    }

    setCurrentLevels();
    if (m_levels.empty()) {
        setMinimalDifficulty(m_difficulty);
        setMaximalDifficulty(m_difficulty);
    }
    else {
        computeMinMaxDifficulty();
    }
}

void ActivityInfo::removeDataset(const QString &datasetName)
{
    m_currentLevels.removeOne(datasetName);
    m_levels.removeOne(datasetName);
    delete m_datasets[datasetName];
    m_datasets.remove(datasetName);
    Q_EMIT currentLevelsChanged();
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
    for (const QString &datasetName: std::as_const(m_currentLevels)) {
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
        m_ignoredLevels = ApplicationSettings::getInstance()->ignoredLevels(m_name.split('/')[0]);
        // Clear m_currentLevels before filling it to avoid duplicates when reloading it after sending new level from the server
        m_currentLevels.clear();
        // Fill m_currentLevels with all levels except the ignored ones
        for (const QString &level: m_levels) {
            if (!m_ignoredLevels.contains(level)) {
                m_currentLevels << level;
            }
        }
    }
    else {
        qWarning() << "ActivityInfo::setCurrentLevels(), name is empty";
    }

    computeMinMaxDifficulty();

    Q_EMIT currentLevelsChanged();
}

void ActivityInfo::enableDatasetsBetweenDifficulties(quint32 levelMin, quint32 levelMax)
{
    QStringList newLevels;
    for (const auto &[key, dataset]: m_datasets.asKeyValueRange()) {
        if (levelMin <= dataset->difficulty() && dataset->difficulty() <= levelMax) {
            newLevels << key;
            dataset->setEnabled(true);
        }
        else {
            dataset->setEnabled(false);
        }
    }
    setCurrentLevels(newLevels);
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

bool ActivityInfo::acceptDataset() const
{
    // This differs from hasDataset as an activity may accept dataset (multiple choice question) but don't have by default
    return m_acceptDataset;
}

void ActivityInfo::resetLevels()
{
    enableDatasetsBetweenDifficulties(1, 6);
}

#include "moc_ActivityInfo.cpp"
