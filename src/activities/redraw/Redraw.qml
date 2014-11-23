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
            property int colorSelector: 0
            property alias userModel: userModel
            property int numberOfColumn
            property int numberOfColor
            property int numberOfLine: targetModelData.length / numberOfColumn
            property alias targetModel: targetModel
            property variant targetModelData
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.onPressed: {
            if(event.key >= Qt.Key_0 && event.key <= Qt.Key_0 + items.numberOfColor)
                items.colorSelector = event.key - Qt.Key_0
        }

        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 20

            // The color selector
            Column {
                Repeater {
                    model: items.numberOfColor
                    Item {
                        width: Math.min(background.width * 0.10,
                                        background.height * 0.8 / items.numberOfColor)
                        height: width
                        Image {
                            id: img
                            source: Activity.url + Activity.colorShortcut[modelData] + ".svg"
                            sourceSize.width: parent.width
                            height: width
                            scale: modelData == items.colorSelector ? 1.3 : 1
                            z: modelData == items.colorSelector ? 10 : 1

                            Behavior on scale { NumberAnimation { duration: 100 } }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: items.colorSelector = modelData
                            }
                        }
                        GCText {
                            anchors.fill: parent
                            text: modelData
                            font.pointSize: 14
                            z: modelData == items.colorSelector ? 12 : 2
                            font.bold: true
                            style: Text.Outline
                            styleColor: "black"
                            color: "white"
                        }
                    }
                }
            }

            // The drawing area
            Grid {
                id: drawingArea
                width: parent.width * 0.4
                height: parent.height * 0.8
                columns: items.numberOfColumn
                Repeater {
                    id: userModel
                    model: items.targetModelData.length

                    function reset() {
                        for(var i=0; i < items.userModel.count; ++i)
                            userModel.itemAt(i).paint(0)
                    }

                    Item {
                        id: userItem
                        width: Math.min(drawingArea.width / items.numberOfColumn,
                                        drawingArea.height / items.numberOfLine)
                        height: width
                        property color color: Activity.colors[colorIndex]
                        property int colorIndex

                        function paint() {
                            colorIndex = items.colorSelector
                        }

                        Rectangle {
                            id: userRect
                            anchors.fill: parent
                            border.width: 1
                            border.color: 'black'
                            color: parent.color

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
                                onClicked: userItem.paint()
                            }
                        }
                        GCText {
                            anchors.fill: parent
                            anchors.margins: 4
                            text: parent.colorIndex == 0 ? "" : parent.colorIndex
                            font.pointSize: 14
                            z: modelData == items.colorSelector ? 12 : 2
                            font.bold: true
                            style: Text.Outline
                            styleColor: "black"
                            color: "white"
                        }
                    }
                }
            }

            // The painting to reproduce
            Grid {
                id: imageArea
                width: drawingArea.width
                height: drawingArea.height
                columns: items.numberOfColumn
                LayoutMirroring.enabled: activity.symmetry
                LayoutMirroring.childrenInherit: true
                Repeater {
                    id: targetModel
                    model: items.targetModelData
                    Item {
                        width: Math.min(imageArea.width / items.numberOfColumn,
                                        imageArea.height / items.numberOfLine)
                        height: width
                        property alias color: targetRect.color

                        Rectangle {
                            id: targetRect
                            anchors.fill: parent
                            color: Activity.colors[modelData]
                            border.width: 1
                            border.color: 'black'
                        }
                        GCText {
                            anchors.fill: parent
                            anchors.margins: 4
                            text: modelData == 0 ? "" : modelData
                            font.pointSize: 14
                            z: modelData == items.colorSelector ? 12 : 2
                            font.bold: true
                            style: Text.Outline
                            styleColor: "black"
                            color: "white"
                        }
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
