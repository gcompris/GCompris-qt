/* GCompris - MelodyList.qml
 *
 * Copyright (C) 2017 Divyam Madaan <divyam3897@gmail.com>
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

import "../../core"
import "piano_composition.js" as Activity
import "melodies.js" as Dataset

Rectangle {
    id: dialogBackground
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000 
    anchors.fill: parent
    visible: false
    signal close
    property alias melodiesModel: melodiesModel
    property bool horizontalLayout: dialogBackground.width > dialogBackground.height ? true : false

    ListModel {
        id: melodiesModel
    }

    Row {
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                id: titleRectangle
                color: "#e6e6e6"
                radius: 6.0
                width: dialogBackground.width - 30
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                GCText {
                    id: title
                    text: qsTr("Melodies")
                    width: dialogBackground.width - 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    fontSize: 20
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                }
            }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogBackground.width - 30
                height: dialogBackground.height - 100
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    anchors.fill: parent
                    contentWidth: melodiesGrid.width
                    contentHeight: melodiesGrid.height
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    Grid {
                        id: melodiesGrid
                        rows: 10
                        columns: horizontalLayout ? 4 : 3
                        spacing: 40

                        Repeater {
                            id: melodiesRepeater
                            model: melodiesModel

                            Item {
                                id: melodiesItem
                                width: dialogBackground.width > dialogBackground.height ? dialogBackground.width * 0.2 : dialogBackground.width * 0.25
                                height: dialogBackground.height * 0.2

                                Rectangle {
                                    anchors.fill: parent
                                    color: "orange"
                                    radius: 10

                                    Rectangle {
                                        width: parent.width - anchors.margins
                                        height: parent.height - anchors.margins
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.margins: parent.height/4
                                        radius: 10
                                        color: "#E8E8E8" //paper white

                                        GCText {
                                            anchors.fill: parent
                                            text: title
                                            fontSizeMode: Text.Fit
                                            wrapMode: Text.WordWrap
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                items.staff2.loadFromData(melody)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Item { width: 1; height: 10 }
        }
    }
    GCButtonCancel {
        onClose: parent.close()
    }
}
