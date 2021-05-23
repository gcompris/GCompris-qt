/* GCompris - Clickgame.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
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
        sourceSize.width: width
        sourceSize.height: height

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
            interval: 5000
            running: true
            repeat: true
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
