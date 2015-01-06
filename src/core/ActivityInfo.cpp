/* GCompris - ActivityInfo.cpp
 *
 * Copyright (C) 2014 Bruno Coudoin
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
#include <QtDebug>
#include <QQmlProperty>
#include <QQmlEngine>
#include <QQmlComponent>

#include "ActivityInfoTree.h"

ActivityInfo::ActivityInfo(QObject *parent):
	QObject(parent),
	m_dir("")
{}

QString ActivityInfo::name() const
{
	return m_name;
}
void ActivityInfo::setName(const QString &name)
{
	m_name = name;
	emit nameChanged();
}

QString ActivityInfo::dir() const
{
	return m_dir;
}
void ActivityInfo::setDir(const QString &dir)
{
	m_dir = dir;
	emit dirChanged();
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

int ActivityInfo::difficulty() const
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

QStringList ActivityInfo::getSectionPath()
{
	QStringList path;
	ActivityInfo *activity(this);
	do {
		path.prepend(activity->section());
	} while( ( activity = qobject_cast<ActivityInfo*>(activity->parent()) ) );
	return path;
}
