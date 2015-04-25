/* GCompris - ReverseCount.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Major rework)
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

import "../../core"
import "reversecount.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ff00a4b0"

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
            property GCAudio audioEffects: activity.audioEffects
            property alias background: background
            property alias backgroundImg: backgroundImg
            property alias bar: bar
            property alias bonus: bonus
            property alias chooseDiceBar: chooseDiceBar
            property alias tux: tux
            property alias fishToReach: fishToReach
            property alias clock: clock
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.onEnterPressed: Activity.moveTux()
        Keys.onReturnPressed: Activity.moveTux()

        onWidthChanged: {
            if(Activity.fishIndex > 0) {
                Activity.placeFishToReach(Activity.fishIndex)
                Activity.moveTuxToIceBlock()
            }
        }

        onHeightChanged: {
            if(Activity.fishIndex > 0) {
                Activity.placeFishToReach(Activity.fishIndex)
                Activity.moveTuxToIceBlock()
            }
        }

        Image {
            id: backgroundImg
            source: Activity.url + Activity.backgrounds[0]
            sourceSize.height: parent.height * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        // === The ice blocks ===
        Repeater {
            model: Activity.iceBlocksLayout

            Image {
                x: modelData[0] * background.width / 5
                y: modelData[1] * (background.height- background.height/5) / 5
                width: background.width / 5
                height: background.height / 5
                source: Activity.url + "iceblock.svg"
            }
        }


        Tux {
            id: tux
            sourceSize.width: Math.min(background.width / 6, background.height / 6)
            z: 11
        }


        Image {
            id: fishToReach
            sourceSize.width: Math.min(background.width / 6, background.height / 6)
            z: 10
            property string nextSource
            property int nextX
            property int nextY

            function showParticles() {
                particles.burst(40)
            }

            ParticleSystemStarLoader {
                id: particles
                clip: false
            }

            onOpacityChanged: opacity == 0 ? source = nextSource : null
            onSourceChanged: {
                x = nextX
                y = nextY
                opacity = 1
            }

            Behavior on opacity { NumberAnimation { duration: 500 } }
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Image {
            id: clock
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 10
            }
            sourceSize.width: 66 * bar.barZoom
        }


        ChooseDiceBar {
            id: chooseDiceBar
            x: background.width / 5 + 20
            y: (background.height - background.height/5) * 3 / 5
            audioEffects: activity.audioEffects
        }

        Bonus {
            id: bonus
            winSound: "qrc:/gcompris/src/activities/ballcatch/resource/tuxok.wav"
            looseSound: "qrc:/gcompris/src/activities/ballcatch/resource/youcannot.wav"
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
