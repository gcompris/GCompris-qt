/* GCompris - ApplicationInfoDefault.cpp
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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

int ApplicationInfo::localeCompare(const QString &a, const QString &b,
                                   const QString &locale) const
{
    QString _locale = locale.isEmpty() ? ApplicationSettings::getInstance()->locale()
                                       : locale;
    QLocale l = (_locale == GC_DEFAULT_LOCALE) ? QLocale::system()
                                               : QLocale(_locale);
    return QCollator(l).compare(a, b);
}

bool ApplicationInfo::checkPermissions() const
{
    return true;
}
