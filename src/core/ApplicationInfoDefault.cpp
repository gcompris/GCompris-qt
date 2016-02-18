/* GCompris - ApplicationInfoDefault.cpp
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

#include "ApplicationInfo.h"
#include <QCollator>
#include <QLocale>

bool ApplicationInfo::requestAudioFocus() const
{
  return true;
}

void ApplicationInfo::abandonAudioFocus() const
{
}

void ApplicationInfo::setRequestedOrientation(int orientation)
{
    Q_UNUSED(orientation);
}

int ApplicationInfo::getRequestedOrientation()
{
    return -1;
}

void ApplicationInfo::setKeepScreenOn(bool value)
{
    Q_UNUSED(value);
}

int ApplicationInfo::localeCompare(const QString& a, const QString& b,
                                   const QString& locale) const
{
    QString _locale = locale.isEmpty() ? \
                          ApplicationSettings::getInstance()->locale() \
                        : locale;
    QLocale l = (_locale == GC_DEFAULT_LOCALE) ? QLocale::system() \
                                               : QLocale(_locale);
    return QCollator(l).compare(a, b);
}
