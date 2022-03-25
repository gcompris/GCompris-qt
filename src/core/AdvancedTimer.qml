/* GCompris - AdvancedTimer.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

Timer {
    id: timer

    property double startTime
    property double pauseTime
    property int remainingInterval

    interval: activity.timerNormalInterval

    signal pause
    signal resume
    signal restart

    onPause: {
        if(timer.running) {
            pauseTime = new Date().getTime()
            timer.stop()
        }
    }

    onResume: {
        if(!timer.running) {
            if(!triggeredOnStart) {
                remainingInterval = Math.abs(timer.interval - Math.abs(pauseTime - startTime))
                timer.interval = remainingInterval
            }
            timer.start()
        }
    }

    onRestart: {
        timer.stop()
        timer.interval = 1
        timer.start()
    }

    onTriggered:{
        if(interval != activity.timerNormalInterval) {
            interval = activity.timerNormalInterval
        }
    }

    onRunningChanged: {
        if(running)
            startTime = new Date().getTime()
    }
}
