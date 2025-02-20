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
import core 1.0
import "../../core"
import "braille_alphabets.js" as Activity

Rectangle {
    id: brailleMap
    color: GCStyle.midGrayBg
    z: 1000
    property bool isDialog: true
    signal close
    signal start
    signal stop

    Keys.onPressed: (event) => {
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
        sourceSize.width: GCStyle.bigButtonHeight
        anchors.margins: GCStyle.baseMargins
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
        anchors.margins: GCStyle.baseMargins
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.9
        contentWidth: width
        contentHeight: (grid1.height + grid2.height) * 1.1
        flickableDirection: Flickable.VerticalFlick
        maximumFlickVelocity: brailleMap.height
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        Flow {
            id: grid1
            width: parent.width
            spacing: GCStyle.halfMargins

            Repeater {
                id: cardRepeater
                model: [
                    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
                    "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                    "U", "V", "X", "Y", "Z", "", "", "", "", "W"
                ]

                Column {
                    width: grid1.width * 0.1 - grid1.spacing

                    Rectangle {
                        id: rect1
                        width:  parent.width
                        height: ins.height + GCStyle.halfMargins
                        border.width: GCStyle.thinnestBorder
                        border.color: GCStyle.darkBorder
                        color: GCStyle.lightBg
                        opacity: modelData != "" ? 1 : 0

                        BrailleChar {
                            id: ins
                            width: parent.width - GCStyle.halfMargins
                            anchors.centerIn: parent
                            clickable: false
                            brailleChar: modelData
                        }
                    }

                    GCText {
                        id: text1
                        text: modelData
                        width: parent.width
                        height: rect1.height * 0.4
                        fontSize: largeSize
                        fontSizeMode: Text.Fit
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: GCStyle.darkText
                        color: GCStyle.whiteText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }

        Flow {
            id: grid2
            width : parent.width
            anchors {
                top: grid1.bottom
                topMargin: GCStyle.halfMargins
            }
            spacing: GCStyle.halfMargins

            Repeater {
                id: cardRepeater2
                model: [
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                    "+", "-", "*", "/", "#"
                ]

                Column {
                    width: grid1.width * 0.1 - grid1.spacing

                    Rectangle {
                        id: rect2
                        width:  parent.width
                        height: ins2.height + GCStyle.halfMargins
                        border.width: GCStyle.thinnestBorder
                        border.color: GCStyle.darkBorder
                        color: GCStyle.lightBg

                        BrailleChar {
                            id: ins2
                            width: parent.width - GCStyle.halfMargins
                            anchors.centerIn: parent
                            clickable: false
                            brailleChar: modelData
                        }
                    }

                    GCText {
                        id: text2
                        text: modelData
                        width: parent.width
                        height: rect2.height * 0.4
                        fontSize: largeSize
                        fontSizeMode: Text.Fit
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: GCStyle.darkText
                        color: GCStyle.whiteText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }
    }
}
