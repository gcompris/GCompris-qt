/* GCompris - Clickgame.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (animation refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0
import "../../core"
import "clickgame.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        signal start
        signal stop
        signal animTrigger
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/clickgame/resource/sea1.webp"
        sourceSize.width: width
        sourceSize.height: height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(activity, activityBackground, bar, bonus, items) }
        onStop: {
            Activity.stop()
            timer.stop()
            fishAnimation.stop()
        }

        GCSoundEffect {
            id: bubbleSound
            source: "qrc:/gcompris/src/activities/clickgame/resource/bubble.wav"
        }

        GCSoundEffect {
            id: dripSound
            source: "qrc:/gcompris/src/activities/clickgame/resource/drip.wav"
        }

        property alias dripSound: dripSound

        QtObject {
            id: items
            property alias score: score
            property alias killedFishes: score.currentSubLevel
            property int currentLevel: activity.currentLevel
        }

        Timer {
            id: timer
            interval: 5000
            running: true
            repeat: true
            onTriggered: bubbleSound.play()
        }

        Timer {
            id: fishAnimation
            interval: 10
            running: true
            repeat: true
            onTriggered: activityBackground.animTrigger()
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: activity.home()
        }

        Score {
            id: score

            anchors {
                top: parent.top
                bottom: undefined
                right: parent.right
                margins: GCStyle.baseMargins
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                activity.displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
