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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
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
        property bool keyNavigationVisible: false

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
            property alias grid: grid
            property bool blockClicks: false
            property int columns
            property int rows
            property int spacing: 5 * ApplicationInfo.ratio
        }

        onStart: Activity.start(items)

        onStop: Activity.stop()

        ListModel {
            id: containerModel
        }


        GridView {
            id: grid
            width: background.width - (items.columns + 1) * items.spacing - anchors.margins
            height: background.height - (items.rows + 1) * items.spacing - anchors.margins
            cellWidth: (background.width - (items.columns + 1) * items.spacing) / items.columns - anchors.margins
            cellHeight: (background.height - (items.rows + 1) * items.spacing) / (items.rows + 0.5) - anchors.margins
            anchors {
                left: background.left
                right: background.right
                top: background.top
                bottom: background.bottom
                margins: 5 * ApplicationInfo.ratio
            }

            model: containerModel

            function getItemAtIndex(i) {
                var xi = (i % items.columns) * cellWidth + anchors.margins
                var yi = (i / items.columns) * cellHeight + anchors.margins
                return itemAt(xi, yi)
            }

            delegate: CardItem {
                pairData: pairData_
                tuxTurn: background.items.tuxTurn
                width: (background.width - (items.columns + 1) * items.spacing) / items.columns - 15 * ApplicationInfo.ratio
                height: (background.height - (items.rows + 1) * items.spacing) / (items.rows + 0.5) - 15 * ApplicationInfo.ratio
                audioVoices: activity.audioVoices
                audioEffects: activity.audioEffects
                onIsFoundChanged: background.keyNavigationVisible = false
            }
            interactive: false
            keyNavigationWraps: true
            highlightFollowsCurrentItem: true
            highlight: Rectangle {
                color: "#AAFFFFFF"
                radius: 10
                visible: background.keyNavigationVisible
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
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

        Keys.enabled: !items.blockClicks
        Keys.onPressed: {
            background.keyNavigationVisible = true
            if(event.key === Qt.Key_Left) {
                grid.moveCurrentIndexLeft()
                // skip the highlight on the already found cards
                while(grid.currentItem.isFound && !items.blockClicks) {
                    grid.moveCurrentIndexLeft()
                }
            }
            else if(event.key === Qt.Key_Right) {
                grid.moveCurrentIndexRight()
                // skip the highlight on the already found cards
                while(grid.currentItem.isFound && !items.blockClicks) {
                    grid.moveCurrentIndexRight()
                }
            }
            else if(event.key === Qt.Key_Up) {
                grid.moveCurrentIndexUp()
                // skip the highlight on the already found cards
                while(grid.currentItem.isFound && !items.blockClicks) {
                    grid.moveCurrentIndexUp()
                }
            }
            else if(event.key === Qt.Key_Down) {
                grid.moveCurrentIndexDown()
                // skip the highlight on the already found cards
                while(grid.currentItem.isFound && !items.blockClicks) {
                    grid.moveCurrentIndexDown()
                }
            }
            else if(event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                if(grid.currentItem.isBack && !grid.currentItem.isFound && !grid.currentItem.tuxTurn && items.selectionCount < 2) grid.currentItem.selected()
        }
    }
}
