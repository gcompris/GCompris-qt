/* GCompris - redraw.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import QtQuick 2.1

import "../../core"
import "redraw.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool symmetry: false

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width

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
            property string colorSelector: Activity.colors['white']
            property alias userModel: userModel
            property alias targetModel: targetModel
            property variant targetModelData
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 20

            // The color selector
            Column {
                Repeater {
                    model: [ "white", "red", "orange", "green", "blue" ]
                    Image {
                        source: Activity.url + modelData + ".svg"
                        sourceSize.width: Math.min(background.width * 0.10, background.height * 0.15)
                        height: width
                        scale: staticColor == items.colorSelector ? 1.3 : 1
                        z: staticColor == items.colorSelector ? 10 : 1

                        property string staticColor: Activity.colors[modelData]

                        Behavior on scale { NumberAnimation { duration: 100 } }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: items.colorSelector = Activity.colors[modelData]
                        }
                    }
                }
            }

            // The drawing area
            Grid {
                id: drawingArea
                width: parent.width * 0.4
                columns: 4
                Repeater {
                    id: userModel
                    model: 20

                    function reset() {
                        for(var i=0; i < items.userModel.count; ++i)
                            userModel.itemAt(i).color = Activity.colors['white']
                    }

                    Rectangle {
                        id: userRect
                        width: Math.min(background.width * 0.10, background.height * 0.15)
                        height: width
                        border.width: 1
                        border.color: 'black'

                        function paint() {
                            color = items.colorSelector
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                onRunningChanged: {
                                    if(!running && Activity.checkModel()) bonus.good("flower")
                                }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: parent.paint()
                        }
                    }
                }
            }

            // The painting to reproduce
            Grid {
                width: parent.width * 0.4
                columns: 4
                LayoutMirroring.enabled: activity.symmetry
                LayoutMirroring.childrenInherit: true
                Repeater {
                    id: targetModel
                    model: items.targetModelData
                    Rectangle {
                        color: Activity.colors[modelData]
                        width: Math.min(background.width * 0.10, background.height * 0.15)
                        height: width
                        border.width: 1
                        border.color: 'black'
                    }
                }
            }
        }

        function checkTouchPoint(touchPoints) {
            for(var i in touchPoints) {
                var touch = touchPoints[i]
                var block = drawingArea.childAt(touch.x, touch.y)
                if(block)
                    block.paint()
            }
        }

        MultiPointTouchArea {
            x: drawingArea.x
            y: drawingArea.y
            width: drawingArea.width
            height: drawingArea.height
            onPressed: checkTouchPoint(touchPoints)
            onTouchUpdated: checkTouchPoint(touchPoints)
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
