/* GCompris - BrailleMap.qml
 *
 * Copyright (C) 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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
import "braille_alphabets.js" as Activity

Rectangle {
    id: brailleMap
    color: "#808080"
    border.color: "black"
    border.width: 1
    z: 1000
    property bool isDialog: true
    signal close
    signal start
    signal stop

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: (grid1.height + grid2.height) * 1.1
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Flow {
            id: grid1
            width: parent.width * 0.9
            anchors {
                top: parent.top
                topMargin: 10 * ApplicationInfo.ratio
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 5 * ApplicationInfo.ratio

            Repeater {
                id: cardRepeater
                model: [
                    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
                    "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                    "U", "V", "W", "X", "Y", "Z"
                ]

                Column {
                    width:  (grid1.width - grid1.spacing * 10) / 10

                    Rectangle {
                        id: rect1
                        width:  parent.width
                        height: ins.height
                        border.width: 3
                        border.color: "black"
                        color: "white"

                        BrailleChar {
                            id: ins
                            width: parent.width * 0.9
                            anchors.centerIn: parent
                            clickable: false
                            brailleChar: modelData
                        }
                    }
                    GCText {
                        id: text1
                        text: modelData
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: "black"
                        color: "white"
                        fontSize: Math.max(Math.min(parent.width * 0.2, 24), 12)
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }

        Flow {
            id: grid2
            width : parent.width * 0.9
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: grid1.bottom
                topMargin: 10 * ApplicationInfo.ratio
            }
            spacing: 6

            Repeater {
                id: cardRepeater2
                model: [
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                    "+", "-", "*", "/", "#"
                ]

                Column {
                    width:  (grid1.width - grid1.spacing * 10) / 10

                    Rectangle {
                        id: rect2
                        width:  parent.width
                        height: ins2.height
                        border.width: 3
                        border.color: "black"
                        color: "white"

                        BrailleChar {
                            id: ins2
                            width: parent.width * 0.9
                            anchors.centerIn: parent
                            clickable: false
                            brailleChar: modelData
                        }
                    }
                    GCText {
                        id: text2
                        text: modelData
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: "black"
                        color: "white"
                        fontSize: Math.max(Math.min(parent.width * 0.2, 24), 12)
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }

        // The back button
        Image {
            id: cancel
            source: Activity.url + "back.svg"
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            smooth: true
            sourceSize.width: 60 * ApplicationInfo.ratio
            anchors.margins: 10
            SequentialAnimation {
                id: anim
                running: true
                loops: Animation.Infinite
                NumberAnimation {
                    target: cancel
                    property: "rotation"
                    from: -10; to: 10
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: cancel
                    property: "rotation"
                    from: 10; to: -10
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: close()
            }
        }
    }
}
