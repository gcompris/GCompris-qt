/* GCompris - BrailleMap.qml
 *
 * Copyright (C) 2014 <Arkit Vora>
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
import QtQuick 2.2
import QtQuick.Controls 1.1
import GCompris 1.0

Rectangle {
    id: dialogBackground
    color: "#808080"
    border.color: "black"
    border.width: 1
    z: 1000
    property bool isDialog: true
    property string title
    property string content
    signal close
    signal start
    signal pause
    signal play
    signal stop

    Item {
        id: outer
        x: parent.width / 2
        y: parent.height / 15
        width : parent.width / 1.06
        height :  parent.height / 6
        anchors.horizontalCenter: parent.horizontalCenter

        Grid {
            id: grid
            spacing: 6
            columns: 10
            rows: 3

            Repeater {
                id: cardRepeater
                model: mapContainerModel

                Item {
                    id: inner
                    height: outer.height/1.05
                    width: outer.width / 12
                    scale: 0.7

                    Rectangle {
                        id: rect1
                        width:  outer.width / 13; height: outer.height / 1.1
                        border.width: 3
                        border.color: "black"
                        color: "white"


                        BrailleChar {
                            id: ins
                            dotWidth: rect1.height / 3.4
                            dotHeight: rect1.height / 3.4
                            anchors.centerIn: rect1
                            clickable: false
                        }
                    }

                    Text {
                        text: letter
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: "black"
                        color: "white"
                        font.pointSize: Math.max(parent.width * 0.2, 12)
                        anchors {
                            top: rect1.bottom
                            topMargin: 6 * ApplicationInfo.ratio
                            horizontalCenter: rect1.horizontalCenter
                        }
                    }
                }

            }
        }
    }

    Item {
        id: outer2
        x: parent.width / 2
        y: parent.height / 1.7
        width : parent.width / 1.06
        height :  parent.height / 6
        anchors.horizontalCenter: parent.horizontalCenter


        Grid {
            id: grid2
            spacing: 6
            columns: 10
            rows: 2

            Repeater {
                id: cardRepeater2
                model: mapContainerModel2

                Item {
                    id: inner2
                    height: outer2.height / 1.05
                    width: outer2.width / 12
                    scale: 0.7

                    Rectangle {
                        id: rect2
                        width:  outer2.width / 13; height: outer2.height / 1.1
                        border.width: 3
                        border.color: "black"
                        color: "white"


                        BrailleChar {
                            id: ins2
                            dotWidth: rect2.height / 3.4
                            dotHeight: rect2.height / 3.4
                            anchors.centerIn: rect2
                            clickable: false
                        }
                    }

                    Text {
                        text: letter
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: "black"
                        color: "white"
                        font.pointSize: Math.max(parent.width * 0.2, 12)
                        anchors {
                            top: rect2.bottom
                            topMargin: 6 * ApplicationInfo.ratio
                            horizontalCenter: rect2.horizontalCenter
                        }
                    }
                }

            }
        }
    }

    // The back button
    Image {
        id: cancel
        source: "qrc:/gcompris/src/activities/braille_alphabets/resource/back.svg"
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        anchors.top: parent.top
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
                easing.type: Easing.InOutQuad }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: close()
        }
    }

}
