/* GCompris - Clickgame.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import GCompris 1.0
import "../../core"
import "clickgame.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: background
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/clickgame/resource/sea1.jpg"
        sourceSize.width: Math.max(parent.width, parent.height)

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(activity, background, bar, bonus, items) }
        onStop: {
            Activity.stop()
            timer.stop()
        }

        QtObject {
            id: items
            property alias score: score
            property alias killedFishes: score.currentSubLevel
        }

        Timer {
            id: timer
            interval: 5000; running: true; repeat: true
            onTriggered: activity.audioEffects.play("qrc:/gcompris/src/activities/clickgame/resource/bubble.wav")
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Score {
            id: score

            anchors {
                top: parent.top
                bottom: undefined
                right: parent.right
                margins: 10 * ApplicationInfo.ratio
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
