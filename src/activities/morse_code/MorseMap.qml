/* GCompris - MorseMap.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Arkit Vora <arkitvora123@gmail.com> (Original version in Braille activity)
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"

Rectangle {
    id: morseMap
    color: "#808080"
    border.color: "black"
    border.width: 1
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
        morseMap.forceActiveFocus();
        activity.Keys.enabled = false;
    }

    onClose: {
        activity.Keys.enabled = true;
        activity.resetFocus();
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: grid.height * 1.1
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Flow {
            id: grid
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
                    "U", "V", "W", "X", "Y", "Z", "", "", "", "",
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                ]

                Column {
                    width: (grid.width - grid.spacing * 10) / 10

                    Rectangle {
                        id: rect
                        width: 100
                        height: ins.height
                        border.width: 3
                        border.color: "black"
                        color: "white"
                        opacity: modelData != "" ? 1 : 0

                        GCText {
                            id: ins
                            text: modelData == "" ? "" : morseConverter.alpha2morse(modelData).replace(/\./g, items.middleDot)
                            style: Text.Outline
                            styleColor: "white"
                            color: "black"
                            fontSize: 10
                            anchors.centerIn: parent
                        }
                    }
                    GCText {
                        id: text
                        text: modelData
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: "black"
                        color: "white"
                        fontSize: Math.max(Math.min(parent.width * 0.2, 24), 12)
                        anchors.horizontalCenter: rect.horizontalCenter
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
