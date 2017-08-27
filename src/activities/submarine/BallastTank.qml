/* GCompris - BallastTank.qml
 *
 * Copyright (C) 2017 RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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

import QtQuick 2.6

Item {
    property int initialWaterLevel: 0
    property int waterLevel: 0
    property int maxWaterLevel: 500
    property int waterRate: 100
    property bool waterFilling: false
    property bool waterFlushing: false

    function fillBallastTanks() {
        waterFilling = !waterFilling
    }

    function flushBallastTanks() {
        waterFlushing = !waterFlushing
    }

    function updateWaterLevel(isInflow) {
        if (isInflow) {
            if (waterLevel < maxWaterLevel) {
                waterLevel += waterRate

            }
        } else {
            if (waterLevel > 0) {
                waterLevel -= waterRate
            }
        }

        if (waterLevel > maxWaterLevel) {
            waterLevel = maxWaterLevel
        }

        if (waterLevel < 0) {
            waterLevel = 0
        }
    }

    function resetBallastTanks() {
        waterFilling = false
        waterFlushing = false

        waterLevel = initialWaterLevel
    }

    Timer {
        id: fillBallastTanks
        interval: 500
        running: waterFilling && !waterFlushing
        repeat: true

        onTriggered: updateWaterLevel(true)
    }

    Timer {
        id: flushBallastTanks
        interval: 500
        running: waterFlushing && !waterFilling
        repeat: true

        onTriggered: updateWaterLevel(false)
    }
}
