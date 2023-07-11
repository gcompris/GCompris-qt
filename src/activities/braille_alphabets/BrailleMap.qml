/* GCompris - BrailleMap.qml
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "braille_alphabets.js" as Activity

Rectangle {
    id: brailleMap
    color: "#808080"
    z: 1000
    property bool isDialog: true
    signal close
    signal start
    signal stop

    Keys.onPressed: {
        if(event.key === Qt.Key_Space || event.key === Qt.Key_Escape) {
            close();
        }
    }

    onStart: {
        brailleMap.forceActiveFocus();
        activity.Keys.enabled = false;
    }

    onClose: {
        activity.Keys.enabled = true;
        activity.forceActiveFocus();
    }

    // The back button
    Image {
        id: cancel
        source: Activity.url + "back.svg"
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
                easing.type: Easing.InOutQuad
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: close()
        }
    }
    
    Flickable {
        id: flick
        anchors.top: cancel.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
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
                    "U", "V", "X", "Y", "Z", "", "", "", "", "W"
                ]

                Column {
                    width: (grid1.width - grid1.spacing * 10) / 10

                    Rectangle {
                        id: rect1
                        width:  parent.width
                        height: ins.height
                        border.width: ins.thinBorder
                        border.color: "#373737"
                        color: "#f0f0f0"
                        opacity: modelData != "" ? 1 : 0

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
                        styleColor: "#373737"
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
    }
}
