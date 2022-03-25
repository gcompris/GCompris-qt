/* GCompris - GCTimerButton.qml
 *
 * SPDX-FileCopyrightText: 2021 Samarth Raj <mailforsamarth@gmail.com>
 *
 * Authors:
 *   Samarth Raj <mailforsamarth@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"

ControlButton {
    property bool enabled: true
    property int holdTime: 3000

    signal pressAndHold
    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        buttonTimer.stop()
    }

    Timer {
        id: buttonTimer
        interval: holdTime
        onTriggered: pressAndHold()
    }

    onPressed: {
        buttonTimer.restart()
    }

    onReleased: {
        buttonTimer.stop()
    }
}
