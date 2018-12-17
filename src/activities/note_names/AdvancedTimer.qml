/* GCompris - AdvancedTimer.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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
import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0
import "note_names.js" as Activity

Timer {
    id: timer

    property double startTime
    property double pauseTime
    property int timerNormalInterval: 2700
    property int remainingInterval

    interval: timerNormalInterval

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
        if(interval != timerNormalInterval) {
            interval = timerNormalInterval
        }
    }

    onRunningChanged: {
        if(running)
            startTime = new Date().getTime()
    }
}
