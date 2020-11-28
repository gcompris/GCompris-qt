/* GCompris - ApplicationSettingsMock.h
 *
 * SPDX-FileCopyrightText: 2018 Himanshu Vishwakarma <himvish997@gmail.com>
 * GCompris  (C) 2018 GCompris Developers  <gcompris-devel@kde.org>
 *
 * Authors:
 *   Himanshu Vishwakarma <himvish997@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
