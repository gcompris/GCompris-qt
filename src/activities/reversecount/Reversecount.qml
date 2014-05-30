/* GCompris - ReverseCount.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
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
import QtQuick 2.1
import GCompris 1.0
import QtMultimedia 5.0

import "qrc:/gcompris/src/core"
import "reversecount.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias chooseDiceBar: chooseDiceBar
            property alias tux: tux
            property alias fishToReach: fishToReach
            property alias clock: clock
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }


//        onWidthChanged: {
//            Activity.placeFishToReach(Activity.fishesPos[Activity.fishIndex])
//            Activity.onWithChangingBool = true
//            Activity.tuxIsMoving = true
//            Activity.moveTuxToIceBlock()
//        }

//        onHeightChanged: {
//            Activity.placeFishToReach(Activity.fishesPos[Activity.fishIndex])
//            Activity.onHeightChangingBool = true
//            Activity.tuxIsMoving = true
//            Activity.moveTuxToIceBlock()
//        }

        // === The ice blocks ===
        Repeater {
            model: Activity.iceBlocksLayout

            Image {
                x: modelData[0] * activity.width / 5
                y: modelData[1] * (activity.height- activity.height/5) / 5
                width: activity.width / 5
                height: activity.height / 5
                source: Activity.url + "iceblock.svgz"
            }
        }


        Tux {
            id: tux
            width: activity.width / 6
            height: activity.height / 6
            background: background
        }


        Image {
            id: clock
            x: activity.width  - clock.width
            y: activity.height - clock.height
            width: activity.width / 8
            height: activity.height / 6
        }

        Image {
            id: fishToReach
            width: activity.width / 6
            height: activity.height / 6
            z: 10
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }


        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }


        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }


        ChooseDiceBar {
            id: chooseDiceBar

            x: activity.width / 2 - chooseDiceBar.width/2
            y: activity.height / 2 - chooseDiceBar.height
            onOkClicked: Activity.moveTux()
            onDice1Clicked: Activity.nextDice1()
            onDice1RightClicked: Activity.previousDice1()
            onDice2Clicked: Activity.nextDice2()
            onDice2RightClicked: Activity.previousDice2()
        }

        ParticleSystemStar {
            id: particles
            clip: false
        }

    }

}
