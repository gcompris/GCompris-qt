/* GCompris - LoadDrawings.qml
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
import "paint.js" as Activity

Rectangle {
            id: load
            color: background.color
            width: background.width
            height: background.height
            opacity: 0
            z: 5

            anchors {
                top: main.top
                right: main.left
            }

            GridView {
                id: gridView
                anchors.fill: parent
                cellWidth: (background.width - exitButton.width) / 2 * slider1.value; cellHeight: cellWidth
                model: Activity.loadImagesSource

                delegate: Item {
                    width: gridView.cellWidth
                    height: gridView.cellHeight
                    property alias loadImage: loadImage
                    Image {
                        id: loadImage
                        source: modelData
                        anchors.centerIn: parent
                        sourceSize.width: parent.width * 0.7
                        sourceSize.height: parent.height * 0.7
                        width: parent.width * 0.9
                        height: parent.height * 0.9
                        mirror: false
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                canvas.url = loadImage.source
                                canvas.loadImage(loadImage.source)

                                main.x = 0
                            }
                        }
                    }
                }
            }

            Behavior on x {
                NumberAnimation {
                    target: load
                    property: "x"
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }

            Behavior on y {
                NumberAnimation {
                    target: load
                    property: "y"
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }

            GCButtonCancel {
                id: exitButton
                onClose: {
                    items.mainAnimationOnX = true
                    main.x = 0
                }
            }

            Image {
                id: switchToSavedPaintings
                source: "qrc:/gcompris/src/activities/paint/paint.svg"
                anchors.right: parent.right
                anchors.top: exitButton.bottom
                smooth: true
                sourceSize.width: 60 * ApplicationInfo.ratio
                anchors.margins: 10

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (loadSavedPainting.opacity == 0)
                            loadSavedPainting.opacity = 1

                        items.mainAnimationOnX = false

                        // move down the loadPaintings screen
                        main.y = main.height

                        loadSavedPainting.anchors.left =  load.left

                        // change the images sources from "saved images" to "load images"
                        items.loadSavedImage = true
                    }
                }
            }


            Slider {
                id: slider1
                minimumValue: 0.3
                value: 0.65
                height: parent.height * 0.5
                width: 60

                opacity: 1
                enabled: true

                anchors.right: parent.right
                anchors.rightMargin: switchToSavedPaintings.width / 2 - 10
                anchors.top: switchToSavedPaintings.bottom

                orientation: Qt.Vertical

                style: SliderStyle {
                    handle: Rectangle {
                        height: 80
                        width: height
                        radius: width / 2
                        color: background.color
                    }

                    groove: Rectangle {
                        implicitHeight: slider1.width
                        implicitWidth: slider1.height
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
