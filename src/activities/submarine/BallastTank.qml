/* GCompris - BallastTank.qml
 *
 * SPDX-FileCopyrightText: 2017 RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12

Item {
    property int initialWaterLevel: 0
    property int waterLevel: 0
    property int maxWaterLevel: 500
    property int waterRate: 100
    property bool waterFilling: false
    property bool waterFlushing: false

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        fillBallastTanks.stop();
        flushBallastTanks.stop();
    }

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
