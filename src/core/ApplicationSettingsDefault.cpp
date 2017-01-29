/* GCompris - ApplicationSettingsDefault.cpp
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

#include "ApplicationSettings.h"
#include "config.h"
#include <QDebug>
void ApplicationSettings::setDemoMode(const bool newMode) {
    m_isDemoMode = newMode;
    emit demoModeChanged();
}

void ApplicationSettings::checkPayment() {
    if(m_activationMode == 2)
        setDemoMode(checkActivationCode(m_codeKey) < 2);
}

uint ApplicationSettings::checkActivationCode(const QString &code) {
    if(code.length() != 12) {
        return 0;
    }
    bool ok;
    uint year = code.midRef(4, 3).toUInt(&ok, 16);
    uint month = code.midRef(7, 1).toUInt(&ok, 16);
    uint crc = code.midRef(8, 4).toUInt(&ok, 16);

    uint expectedCrc =
            code.midRef(0, 4).toUInt(&ok, 16) ^
            code.midRef(4, 4).toUInt(&ok, 16) ^
            0xCECA;

    ok = (expectedCrc == crc && year < 2100 && month <= 12);
    if(!ok)
        // Bad crc, year or month
        return 0;

    // Check date is under 2 years
    ok = year * 100 + month + 200 >= atoi(BUILD_DATE);
    return(ok ? 2 : 1);
}

