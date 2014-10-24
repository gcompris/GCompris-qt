/* GCompris - mosaic.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Clement coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Bruno.coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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

import "../../core"
import "mosaic.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svgz"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
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
            property alias question: question
            property alias answer: answer
            property alias selector: selector
            property alias nbItems: column.nbItems
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Column {
            id: column
            spacing: 10
            x: parent.width * 0.05
            y: parent.height * 0.05
            width: parent.width * 0.9

            property int nbItems: 24
            property bool horizontal: activity.width > activity.height
            property int nbColumns: Activity.questionLayout[nbItems][0]
            property int nbLines: Activity.questionLayout[nbItems][1]
            property int itemWidth: horizontal ?
                                        Math.min(width / 2 / nbColumns - 10 - 10 / nbColumns / 2,
                                                 parent.height / 2 / nbLines - 10 - 10 / nbLines / 2) :
                                        Math.min(width / nbColumns - 10 - 10 / nbColumns / 2,
                                                 parent.height * 0.25 / nbLines - 10 - 10 / nbLines / 2)
            property int itemHeight: itemWidth

            property int nbSelectorColumns: horizontal ?
                                                Activity.selectorLayout[nbItems][0] :
                                                Activity.selectorLayout[nbItems][0] / 2
            property int nbSelectorLines: horizontal ?
                                              Activity.selectorLayout[nbItems][1] :
                                              Activity.selectorLayout[nbItems][1] * 2

            Grid {
                id: row
                spacing: 10
                columns: column.horizontal ? 2 : 1

                // === The Question Area ===
                Rectangle {
                    height: (column.itemHeight + 10) * column.nbLines
                    width: column.horizontal ? column.width / 2 : column.width + 10
                    color: "#55333333"
                    border.color: "black"
                    border.width: 2
                    radius: 5

                    Grid {
                        columns: column.nbColumns
                        anchors.topMargin: 4
                        anchors.bottomMargin: 4
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.fill: parent
                        spacing: 10
                        Repeater {
                            id: question
                            Image {
                                source: Activity.url + modelData
                                sourceSize.height:  column.itemHeight
                                width: column.itemWidth
                                height: column.itemHeight
                            }
                        }
                    }
                }

                // === The Answer Area ===
                Rectangle {
                    height: (column.itemHeight + 10) * column.nbLines
                    width: column.horizontal ? column.width / 2 : column.width + 10
                    color: "#55333333"
                    border.color: "black"
                    border.width: 2
                    radius: 5

                    Grid {
                        columns: column.nbColumns
                        anchors.topMargin: 4
                        anchors.bottomMargin: 4
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.fill: parent
                        spacing: 10
                        Repeater {
                            id: answer
                            Image {
                                id: imageAnswerId
                                source: Activity.url + modelData
                                sourceSize.height:  column.itemHeight
                                width: column.itemWidth
                                height: column.itemHeight

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        Activity.answerSelected(index)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // === The Selector ===
            Rectangle {
                height: (column.itemWidth + 10) * column.nbSelectorLines
                width: column.width + 10
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5

                Grid {
                    columns: column.nbSelectorColumns
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.fill: parent
                    spacing: 10 + 20 / 12.0
                    Repeater {
                        id: selector
                        Image {
                            id: imageId
                            source: Activity.url + modelData
                            sourceSize.height:  column.itemHeight
                            width: column.itemWidth
                            height: column.itemHeight

                            property string basename: modelData

                            signal select
                            signal deselect

                            onSelect: {
                                anim.start()
                                state = "selected"
                            }
                            onDeselect: {
                                anim.stop()
                                state = "notclicked"
                            }

                            states: [
                                State {
                                    name: "notclicked"
                                    PropertyChanges {
                                        target: imageId
                                        scale: 1.0
                                        rotation: 0
                                    }
                                },
                                State {
                                    name: "clicked"
                                    when: mouseArea.pressed
                                    PropertyChanges {
                                        target: imageId
                                        scale: 0.9
                                    }
                                },
                                State {
                                    name: "hover"
                                    when: mouseArea.containsMouse
                                    PropertyChanges {
                                        target: imageId
                                        scale: 1.3
                                    }
                                },
                                State {
                                    name: "selected"
                                    PropertyChanges {
                                        target: imageId
                                        scale: 1.3
                                    }
                                }
                            ]

                            SequentialAnimation {
                                  id: anim
                                  running: false
                                  loops: Animation.Infinite
                                  NumberAnimation {
                                      target: imageId
                                      property: "rotation"
                                      from: -10; to: 10
                                      duration: 400
                                      easing.type: Easing.InOutQuad
                                  }
                                  NumberAnimation {
                                      target: imageId
                                      property: "rotation"
                                      from: 10; to: -10
                                      duration: 400
                                      easing.type: Easing.InOutQuad }
                            }

                            Behavior on scale { NumberAnimation { duration: 70 } }
                            Behavior on rotation { NumberAnimation { duration: 200 } }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: imageId
                                hoverEnabled: true
                                onClicked: Activity.select(imageId)
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
