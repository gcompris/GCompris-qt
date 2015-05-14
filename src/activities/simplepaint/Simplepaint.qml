/* GCompris - Simplepaint.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
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

import QtQuick 2.2
import GCompris 1.0

import "../../core"
import "simplepaint.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true

    pageComponent: Image {
        id: background
        source: items.backgroundImg
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        focus: true

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias paintModel: paintModel
            property int numberOfColor: 7
            property int colorSelector: 0
            property string backgroundImg: Activity.backgrounds[bar.level - 1]
        }

        onStart: Activity.start(main, items)
        onStop: Activity.stop()

        MultiPointTouchArea {
            anchors.fill: parent
            onPressed: checkTouchPoint(touchPoints)
            onTouchUpdated: checkTouchPoint(touchPoints)
        }

        function checkTouchPoint(touchPoints) {
            for(var i in touchPoints) {
                var touch = touchPoints[i]
                var block = rootItem.childAt(touch.x, touch.y)
                if(block)
                    block.touched()
            }
        }

        Item {
            id: rootItem
            anchors.fill: parent
        }

        ListModel {
            id: paintModel
        }

        Row {
            id: row
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
                bottom: bar.top
            }
            anchors.margins: 10
            spacing: 20

            // The color selector
            Column {
                id: colorSelector
                property int cellSize: Math.min(parent.height / items.numberOfColor,
                                                70 * ApplicationInfo.ratio)
                Repeater {
                    model: items.numberOfColor
                    Item {
                        width: colorSelector.cellSize
                        height: width
                        Image {
                            id: img
                            source: "qrc:/gcompris/src/activities/redraw/resource/" +
                                    Activity.colorShortcut[modelData] + ".svg"
                            sourceSize.width: parent.width
                            z: iAmSelected ? 10 : 1

                            property bool iAmSelected: modelData == items.colorSelector

                            states: [
                                State {
                                    name: "notclicked"
                                    when: !img.iAmSelected && !mouseArea.containsMouse
                                    PropertyChanges {
                                        target: img
                                        scale: 0.8
                                    }
                                },
                                State {
                                    name: "clicked"
                                    when: mouseArea.pressed
                                    PropertyChanges {
                                        target: img
                                        scale: 0.7
                                    }
                                },
                                State {
                                    name: "hover"
                                    when: mouseArea.containsMouse
                                    PropertyChanges {
                                        target: img
                                        scale: 1.1
                                    }
                                },
                                State {
                                    name: "selected"
                                    when: img.iAmSelected
                                    PropertyChanges {
                                        target: img
                                        scale: 1
                                    }
                                }
                            ]

                            SequentialAnimation {
                                id: anim
                                running: img.iAmSelected
                                loops: Animation.Infinite
                                alwaysRunToEnd: true
                                NumberAnimation {
                                    target: img
                                    property: "rotation"
                                    from: 0; to: 10
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: img
                                    property: "rotation"
                                    from: 10; to: -10
                                    duration: 400
                                    easing.type: Easing.InOutQuad
                                }
                                NumberAnimation {
                                    target: img
                                    property: "rotation"
                                    from: -10; to: 0
                                    duration: 200
                                    easing.type: Easing.InQuad
                                }
                            }

                            Behavior on scale { NumberAnimation { duration: 70 } }
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                                    items.colorSelector = modelData
                                }
                            }
                        }
                    }
                }
            }

            Item {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                width: parent.width - colorSelector.width - row.spacing

                Repeater {
                    model: paintModel
                    parent: rootItem

                    PaintItem {
                        initialX: colorSelector.width + colorSelector.spacing
                        ix: m_ix
                        iy: m_iy
                        nbx: m_nbx
                        nby: m_nby
                        color: Activity.colors[0]
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload | level }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onReloadClicked: Activity.initLevel()
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }
    }

}
