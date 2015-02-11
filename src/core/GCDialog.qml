/* GCompris - GCDialog.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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

Item {
    id: gcdialog
    focus: true
    opacity: 0

    anchors {
        fill: parent
    }

    property alias message: instructionTxt.text
    property alias button1Text: button1.text
    property alias button2Text: button2.text

    // start and stop trigs the animation
    signal start
    signal stop

    // emitted at stop animation end
    signal close
    // emitted when the optional button is hit
    signal button1Hit
    signal button2Hit

    onStart: opacity = 1
    onStop: opacity = 0
    onClose: destroy()

    Behavior on opacity { NumberAnimation { duration: 200 } }
    onOpacityChanged: opacity === 0 ? close() : null

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        color: "grey"
    }

    MultiPointTouchArea {
        // Just to catch mouse events
        anchors.fill: parent
    }

    /* Message */
    Item {
        id: instruction
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: buttonCancel.height
        }
        width: parent.width * 0.8

        Rectangle {
            id: instructionTxtBg
            anchors.top: instruction.top
            z: 1
            width: parent.width
            height: gcdialog.height - button1.height * 5
            opacity: 0.9
            radius: 10
            border.width: 2
            border.color: "white"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fff" }
                GradientStop { position: 0.9; color: "#fff" }
                GradientStop { position: 1.0; color: "#ddd" }
            }

            Flickable {
                id: flick
                anchors.margins: 8
                anchors.fill: parent
                contentWidth: instructionTxt.contentWidth
                contentHeight: instructionTxt.contentHeight
                flickableDirection: Flickable.VerticalFlick
                clip: true

                GCText {
                    id: instructionTxt
                    fontSize: regularSize
                    color: "black"
                    // @FIXME This property breaks the wrapping
//                    horizontalAlignment: Text.AlignHCenter
                    width: instruction.width
                    wrapMode: TextEdit.WordWrap
                    z: 2
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }

        Button {
            id: button1
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: instructionTxtBg.bottom
                topMargin: 10
            }
            style: GCButtonStyle {
            }
            visible: text != ""
            onClicked: {
                gcdialog.button1Hit()
                gcdialog.stop()
            }
        }

        Button {
            id: button2
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: button1.bottom
                topMargin: 10
            }
            style: GCButtonStyle {
            }
            visible: text != ""
            onClicked: {
                gcdialog.button2Hit()
                gcdialog.stop()
            }
        }
    }


    // Fixme not working, need to properly get the focus on this dialog
    Keys.onEscapePressed: {
        stop()
        event.accepted = true;
    }

    // The cancel button
    GCButtonCancel {
        id: buttonCancel
        onClose: parent.stop()
    }
}
