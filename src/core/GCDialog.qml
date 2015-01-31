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
    property alias buttonText: button.text

    // start and stop trigs the animation
    signal start
    signal stop

    // emitted at stop animation end
    signal close
    // emitted when the optional button is hit
    signal buttonHit

    onStart: opacity = 1
    onStop: opacity = 0

    Behavior on opacity { NumberAnimation { duration: 200 } }
    onOpacityChanged: opacity === 0 ? close() : null

    Rectangle {
        anchors.fill: parent
        opacity: 0.6
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

        GCText {
            id: instructionTxt
            fontSize: mediumSize
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: TextEdit.WordWrap
            z: 2
            onLinkActivated: Qt.openUrlExternally(link)
        }

        Rectangle {
            anchors.fill: instructionTxt
            z: 1
            opacity: 0.9
            radius: 10
            border.width: 2
            border.color: "white"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fff" }
                GradientStop { position: 0.9; color: "#fff" }
                GradientStop { position: 1.0; color: "#ddd" }
            }
        }

        Button {
            id: button
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: instructionTxt.bottom
                topMargin: 10
            }
            style: GCButtonStyle {
            }
            visible: text != ""
            onClicked: {
                gcdialog.buttonHit()
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
