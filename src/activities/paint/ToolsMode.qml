/* GCompris - ToolsMode.qml
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
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
import QtQuick.Controls 1.5
import GCompris 1.0
import "../../core"
import "paint.js" as Activity

Item {
    id: toolsMode
    width: background.width * 0.90
    height: background.height * 0.90

    anchors.centerIn: parent
    property alias modesModel: modes.model
    property alias pencilModes: pencilModes
    property alias geometricModes: geometricModes
    ListModel {
        id: pencilModes
        ListElement { name: "pencil";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/pencil.png" }
        ListElement { name: "dot";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/pattern1.png" }
        ListElement { name: "pattern2";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/pattern3.png" }
        ListElement { name: "pattern3";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/pattern3.png" }
        ListElement { name: "spray";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/spray.png" }
        ListElement { name: "brush3";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/brush3.png" }
        ListElement { name: "brush4";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/brush4.png" }
        ListElement { name: "brush5";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/brush5.png" }
        ListElement { name: "blur";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/blur.png" }
    }

    ListModel {
        id: geometricModes
        ListElement { name: "rectangle";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/rectangle.png" }
        ListElement { name: "circle";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/circle.png" }
        ListElement { name: "lineShift";
            imgSource: "qrc:/gcompris/src/activities/paint/resource/line_straight.svg"
        }
        ListElement { name: "line"
            imgSource: "qrc:/gcompris/src/activities/paint/resource/line_free.png"
        }
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        radius: 10
        color: "grey"
    }

    MultiPointTouchArea {
        anchors.fill: parent
    }

    Rectangle {
        id: container
        z: 1501
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        opacity: 0.9
        radius: 10
        border.width: 2
        border.color: "white"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#fff" }
            GradientStop { position: 0.9; color: "#fff" }
            GradientStop { position: 1.0; color: "#ddd" }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: console.log("Clicked on Grid")
        }

        GridView {
            id: modes
            width: parent.width * 0.85
            height: parent.height * 0.75
            cellWidth: width / 4.2
            cellHeight: height / 4
            y: parent.y + buttonCancel.height + 10
            anchors.centerIn: parent
            model: pencilModes
            delegate: pencilComponent
        }

        Component {
            id: pencilComponent
            Rectangle {
                width: modes.cellWidth
                height: modes.cellHeight
                color: items.toolSelected == name ? "lightblue" : "transparent"
                radius: 10
                Image {
                    source: imgSource
                    width: parent.width * 0.80
                    height: parent.height * 0.80
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        items.toolSelected = name
                        items.lastToolSelected = name
                        background.hideExpandedTools()
                        console.log("Click on " + name)

                        // make the hover over the canvas false
                        area.hoverEnabled = false
                        toolsMode.visible = false

                        // change the selectBrush tool
                        timer.index = 0
                        timer.start()
                        background.reloadSelectedPen()
                        Activity.selectMode(name)
                    }
                }
            }
        }
    }

    GCButtonCancel {
        id: buttonCancel
        z: 1600
        onClose: {
            toolsMode.visible = false
        }
    }
}
