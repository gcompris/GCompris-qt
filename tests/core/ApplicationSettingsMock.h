/* GCompris - ApplicationSettingsMock.h
 *
 * Copyright (C) 2018 Himanshu Vishwakarma <himvish997@gmail.com>
 * GCompris  (C) 2018 GCompris Developers  <gcompris-devel@kde.org>
 *
 * Authors:
 *   Himanshu Vishwakarma <himvish997@gmail.com>
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

/* This file is used for the unit tests */

#ifndef APPLICATIONSETTINGSMOCK_H
#define APPLICATIONSETTINGSMOCK_H

#include <QObject>

#include "src/core/ApplicationSettings.h"

class ApplicationSettingsMock : public ApplicationSettings
{
public:
    ApplicationSettingsMock() : ApplicationSettings(QStringLiteral("./dummy_application_settings.conf"))
    {
    }

    static ApplicationSettings *getInstance() {
        if(!m_instance) {
            m_instance = new ApplicationSettingsMock();
        }
        return m_instance;
    }
};

#endif // APPLICATIONSETTINGSMOCK_H
