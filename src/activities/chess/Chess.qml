/* GCompris - chess.qml
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import GCompris 1.0

import "../../core"
import "chess.js" as Activity

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
            property int cellSize: Math.min(background.width / (8 + 1),
                                            background.height / (8 + 3))
            property var state
            property int from
            property bool blackTurn
            property var whiteAtBottom
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // TODO Imprement a vertical layout
        Grid {
            anchors {
                top: parent.top
                topMargin: items.cellSize / 2
                leftMargin: 10 * ApplicationInfo.ratio
            }
            columns: 3
            rows: 1
            width: background.width
            spacing: 10
            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter

            Column {
                id: controls
                spacing: 10
                width: undo.width + (background.width * 0.9 - undo.width - grid.width) / 2
                Button {
                    id: undo
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 30 * ApplicationInfo.ratio
                    text: qsTr("Undo");
                    style: GCButtonStyle {}
                    onClicked: Activity.undo()
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 30 * ApplicationInfo.ratio
                    text: qsTr("Swap");
                    style: GCButtonStyle {}
                    onClicked: Activity.swap()
                }
            }

            Grid {
                id: grid
                spacing: 5
                columns: 8
                rows: 8

                Repeater {
                    id: repeater
                    model: items.state
                    delegate: blueSquare

                    Component {
                        id: blueSquare
                        Rectangle {
                            color: index % 2 + (Math.floor(index / 8) % 2) == 1 ?
                                       "#FF9999FF" : '#FFFFFF99';
                            width: items.cellSize
                            height: items.cellSize
                            border.color: items.from == index ? "#FFCC2211" : "#FFFFFFFF"
                            border.width: 2
                            Image {
                                anchors.fill: parent
                                source: modelData ? Activity.url + modelData + ".svg" : ''
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(Activity.isWhite(modelData) == true && !items.blackTurn ||
                                            Activity.isWhite(modelData) == false && items.blackTurn) {
                                        items.from = index
                                    } else if(items.from != -1) {
                                        Activity.moveTo(items.from, index)
                                    }
                                }
                            }
                        }
                    }
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
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
