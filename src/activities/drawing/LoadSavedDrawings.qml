/* GCompris - LoadSavedDrawings.qml
 *
 * Copyright (C) 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 *               2018 Amit Sagtani <asagtani06@gmail.com>
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
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import "../../core"
import "drawing.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: loadSavedPainting
    color: background.color
    width: background.width
    height: background.height
    opacity: 0
    z: 100

    property alias gridView2: gridView2

    anchors {
        bottom: main.top
        left: load.left
    }

    GCText {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: - rightFrame.width / 2
        fontSize: largeSize
        text: qsTr("No paintings saved")
        opacity: gridView2.count == 0
    }

    GridView {
        id: gridView2
        anchors.fill: parent
        cellWidth: (main.width - sizeOfImages.width) * slider.value
        cellHeight: main.height * slider.value
        flow: GridView.FlowTopToBottom
        z: 1

        delegate: Rectangle {
            width: gridView2.cellWidth
            height: gridView2.cellHeight
            color: "transparent"

            Image {
                id: loadImage2
                source: modelData.url
                anchors.centerIn: parent
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                width: parent.width * 0.9
                height: parent.height * 0.9

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        loadSavedPainting.anchors.left = main.left

                        canvas.url = loadImage2.source
                        canvas.loadImage(loadImage2.source)

                        main.x = 0
                        main.y = 0
                    }
                }

                GCButtonCancel {
                    anchors.right: undefined
                    anchors.left: parent.left
                    sourceSize.width: 40 * ApplicationInfo.ratio

                    onClose: {
                        Activity.dataset.splice(index, 1)
                        gridView2.model = Activity.dataset
                        Activity.saveToFile(false)
                    }
                }
            }
        }
    }

    Behavior on x { NumberAnimation { target: loadSavedPainting; property: "x"; duration: 800; easing.type: Easing.InOutQuad } }

    Behavior on y { NumberAnimation { target: loadSavedPainting; property: "y"; duration: 800; easing.type: Easing.InOutQuad } }


    Rectangle {
        id: rightFrame
        width: sizeOfImages.width + sizeOfImages.anchors.margins * 2
        color: background.color
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        z: 2

        Image {
            id: sizeOfImages
            source: "qrc:/gcompris/src/activities/drawing/drawing.svg"
            anchors.right: parent.right
            anchors.top: parent.top
            smooth: true
            sourceSize.width: 60 * ApplicationInfo.ratio
            anchors.margins: 10

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    items.mainAnimationOnX = true

                    // move down the loadPaintings screen
                    main.y = 0

                    // change the images sources from "saved images" to "load images"
                    items.loadSavedImage = false
                }
            }
        }

        Slider {
            id: slider
            minimumValue: 0.3
            value: 0.65
            height: parent.height * 0.5
            width: 60

            opacity: 1
            enabled: true

            anchors.right: parent.right
            anchors.rightMargin: sizeOfImages.width / 2 - 10
            anchors.top: sizeOfImages.bottom

            orientation: Qt.Vertical

            style: SliderStyle {
                handle: Rectangle {
                    height: 80
                    width: height
                    radius: width / 2
                    color: background.color
                }

                groove: Rectangle {
                    implicitHeight: slider.width
                    implicitWidth: slider.height
                    radius: height / 2
                    border.color: "#6699ff"
                    color: "#99bbff"

                    Rectangle {
                        height: parent.height
                        width: styleData.handlePosition
                        implicitHeight: 100
                        implicitWidth: 6
                        radius: height/2
                        color: "#4d88ff"
                    }
                }
            }
        }
    }
}
