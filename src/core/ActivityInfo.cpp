/* GCompris - ActivityInfo.cpp
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
#include "ActivityInfo.h"

#include <QtDebug>
#include <QQmlProperty>
#include <QQmlEngine>
#include <QQmlComponent>

#include "ApplicationSettings.h"

ActivityInfo::ActivityInfo(QObject *parent):
	QObject(parent),
    m_difficulty(0),
    m_minimalDifficulty(0),
    m_maximalDifficulty(0),
    m_demo(true),
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

    emit nameChanged();
}

QString ActivityInfo::section() const
{
    return m_section;
}
void ActivityInfo::setSection(const QString &section)
{
    m_section = section;
    emit sectionChanged();
}

quint32 ActivityInfo::difficulty() const
{
    return m_difficulty;
}
void ActivityInfo::setDifficulty(const quint32 &difficulty)
{
    m_difficulty = difficulty;
    emit difficultyChanged();
}

quint32 ActivityInfo::minimalDifficulty() const
{
    return m_minimalDifficulty;
}
void ActivityInfo::setMinimalDifficulty(const quint32 &minimalDifficulty)
{
    m_minimalDifficulty = minimalDifficulty;
    emit minimalDifficultyChanged();
}

quint32 ActivityInfo::maximalDifficulty() const
{
    return m_maximalDifficulty;
}
void ActivityInfo::setMaximalDifficulty(const quint32 &maximalDifficulty)
{
    m_maximalDifficulty = maximalDifficulty;
    emit maximalDifficultyChanged();
}

QString ActivityInfo::icon() const
{
    return m_icon;
}
void ActivityInfo::setIcon(const QString &icon)
{
    m_icon = icon;
    emit iconChanged();
}

QString ActivityInfo::author() const
{
    return m_author;
}
void ActivityInfo::setAuthor(const QString &author)
{
    m_author = author;
    emit authorChanged();
}

bool ActivityInfo::demo() const
{
    return m_demo;
}
void ActivityInfo::setDemo(const bool &demo)
{
    m_demo = demo;
    emit demoChanged();
}

QString ActivityInfo::title() const
{
    return m_title;
}
void ActivityInfo::setTitle(const QString &title)
{
    m_title = title;
    emit titleChanged();
}

QString ActivityInfo::description() const
{
    return m_description;
}
void ActivityInfo::setDescription(const QString &description)
{
    m_description = description;
    emit descriptionChanged();
}

QString ActivityInfo::goal() const
{
    return m_goal;
}
void ActivityInfo::setGoal(const QString &goal)
{
    m_goal = goal;
    emit goalChanged();
}

QString ActivityInfo::prerequisite() const
{
    return m_prerequisite;
}
void ActivityInfo::setPrerequisite(const QString &prerequisite)
{
    m_prerequisite = prerequisite;
    emit prerequisiteChanged();
}

QString ActivityInfo::manual() const
{
    return m_manual;
}
void ActivityInfo::setManual(const QString &manual)
{
    m_manual = manual;
    emit manualChanged();
}

QString ActivityInfo::credit() const
{
    return m_credit;
}
void ActivityInfo::setCredit(const QString &credit)
{
    m_credit = credit;
    emit creditChanged();
}

bool ActivityInfo::favorite() const
{
    return m_favorite;
}
void ActivityInfo::setFavorite(const bool favorite)
{
    m_favorite = favorite;
    ApplicationSettings::getInstance()->setFavorite(m_name, m_favorite);
    emit favoriteChanged();
}

bool ActivityInfo::enabled() const
{
    return m_enabled;
}
void ActivityInfo::setEnabled(const bool enabled)
{
    m_enabled = enabled;
    emit enabledChanged();
}

int ActivityInfo::createdInVersion() const
{
    return m_createdInVersion;
}
void ActivityInfo::setCreatedInVersion(const int created)
{
    m_createdInVersion = created;
    emit createdInVersionChanged();
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

    emit levelsChanged();
}

void ActivityInfo::fillDatasets(QQmlEngine *engine)
{
    quint32 levelMin = ApplicationSettings::getInstance()->filterLevelMin();
    quint32 levelMax = ApplicationSettings::getInstance()->filterLevelMax();
    for(const QString &level: m_levels) {
        QString url = QString("qrc:/gcompris/src/activities/%1/resource/%2/Data.qml").arg(m_name.split('/')[0]).arg(level);
        QQmlComponent componentRoot(engine, QUrl(url));
        QObject *objectRoot = componentRoot.create();
        if(objectRoot != nullptr) {
            Dataset *dataset = qobject_cast<Dataset*>(objectRoot);
            if(levelMin > dataset->difficulty() || levelMax < dataset->difficulty()) {
                dataset->setEnabled(false);
            }

            m_datasets[level] = dataset;
        } else {
            qDebug() << "ERROR: failed to load " << m_name << " " << componentRoot.errors();
        }
    }
    if(m_levels.empty()) {
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
    if(m_currentLevels.empty() || m_datasets.empty()) {
        return;
    }
    quint32 minimalDifficultyFound = 100;
    quint32 maximalDifficultyFound = 0;
    for(const QString &datasetName: m_currentLevels) {
        Dataset *data = m_datasets[datasetName];
        if(minimalDifficultyFound > data->difficulty()) {
            minimalDifficultyFound = data->difficulty();
        }
        if(maximalDifficultyFound < data->difficulty()) {
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
    emit currentLevelsChanged();
}

void ActivityInfo::setCurrentLevels()
{
    if(!m_name.isEmpty()) {
        // by default, activate all existing levels
        if(!m_levels.empty() && ApplicationSettings::getInstance()->currentLevels(m_name).empty()) {
            ApplicationSettings::getInstance()->setCurrentLevels(m_name, m_levels);
        }
        m_currentLevels = ApplicationSettings::getInstance()->currentLevels(m_name);
    }
    computeMinMaxDifficulty();
}

void ActivityInfo::enableDatasetsBetweenDifficulties(quint32 levelMin, quint32 levelMax) {
    QStringList newLevels;
    for(auto it = m_datasets.begin(); it != m_datasets.end(); ++ it) {
        Dataset *dataset = it.value();
        if(levelMin <= dataset->difficulty() && dataset->difficulty() <= levelMax) {
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

Dataset *ActivityInfo::getDataset(const QString& name) const {
    return m_datasets[name];
}

