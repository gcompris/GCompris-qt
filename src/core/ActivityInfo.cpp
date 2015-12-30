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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
#include "ActivityInfo.h"

#include <QtDebug>
#include <QQmlProperty>
#include <QQmlEngine>
#include <QQmlComponent>

#include "ApplicationSettings.h"

ActivityInfo::ActivityInfo(QObject *parent):
	QObject(parent),
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
    if(!ApplicationSettings::getInstance()->isKioskMode())
        m_favorite = ApplicationSettings::getInstance()->isFavorite(m_name);
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
void ActivityInfo::setDifficulty(const int &difficulty)
{
  m_difficulty = difficulty;
  emit difficultyChanged();
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

QStringList ActivityInfo::getSectionPath()
{
	QStringList path;
	ActivityInfo *activity(this);
	do {
		path.prepend(activity->section());
	} while( ( activity = qobject_cast<ActivityInfo*>(activity->parent()) ) );
	return path;
}
