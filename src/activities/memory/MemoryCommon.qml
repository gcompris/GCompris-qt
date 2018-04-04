/* GCompris - MemoryCommon.qml
 *
 * Copyright (C) 2014 JB BUTET <ashashiwa@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
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

import "."
import "../../core"
import "memory.js" as Activity

ActivityBase {
    id: activity
    focus: true

    property string backgroundImg
    property var dataset
    property bool withTux: false
    property string additionnalPath

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: activity.backgroundImg
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop
        focus: true

        signal start
        signal stop

        property alias items: items

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property alias bar: bar
            property alias bonus: bonus
            property GCSfx audioEffects: activity.audioEffects
            property bool withTux: activity.withTux
            property bool tuxTurn: false
            property var playQueue
            property int selectionCount
            property int tuxScore: tuxScore.text
            property int playerScore: playerScore.text
            property var dataset: activity.dataset
            property alias containerModel: containerModel
            property alias cardRepeater: cardRepeater
            property alias grid: grid
            property int columns
            property int rows
        }

        onStart: Activity.start(items)

        onStop: Activity.stop()

        ListModel {
            id: containerModel
        }

        Grid {
            id: grid
            spacing: 5 * ApplicationInfo.ratio
            columns: items.columns
            rows: items.rows
            anchors {
                left: background.left
                right: background.rigth
                top: background.top
                margins: 10 * ApplicationInfo.ratio
            }

            Repeater {
                id: cardRepeater
                model: containerModel

                delegate: CardItem {
                    pairData: pairData_
                    tuxTurn: background.items.tuxTurn
                    width: (background.width - (grid.columns + 1) * grid.spacing) / grid.columns
                    height: (background.height - (grid.rows + 1) * grid.spacing) / (grid.rows + 0.5)
                    audioVoices: activity.audioVoices
                    audioEffects: activity.audioEffects
               }
            }
            add: Transition {
                PathAnimation {
                    path: Path {
                        PathCurve { x: background.width / 3}
                        PathCurve { y: background.height / 3}
                        PathCurve {}
                    }
                    easing.type: Easing.InOutQuad
                    duration: 2000
                }
            }
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
            onHomeClicked: home()
        }

        Image {
            id: player
            source: 'qrc:/gcompris/src/activities/memory/resource/children.svg'
            anchors {
                bottom: bar.bottom
                right: parent.right
                rightMargin: 2 * ApplicationInfo.ratio
            }
            width: height * 0.83
            height: bar.height * 1.2

            GCText {
                id: playerScore
                anchors.centerIn: parent
                anchors.verticalCenterOffset: parent.height / 6
                color: "black"
                font.bold: true
                fontSize: largeSize
                style: Text.Outline
                styleColor: "white"
                text: items.playerScore
            }
        }

        Image {
            id: tux
            visible: activity.withTux
            source: 'qrc:/gcompris/src/activities/memory/resource/tux-teacher.svg'
            anchors {
                bottom: bar.bottom
                right: player.left
                rightMargin: 2 * ApplicationInfo.ratio
            }
            width: height * 0.83
            height: bar.height * 1.2

            GCText {
                id: tuxScore
                anchors.centerIn: parent
                anchors.verticalCenterOffset: parent.height / 6
                color: "black"
                font.bold: true
                fontSize: largeSize
                style: Text.Outline
                styleColor: "white"
                text: items.tuxScore
            }
        }

        Bonus {
            id: bonus
            interval: 2000
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
