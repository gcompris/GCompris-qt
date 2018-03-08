/* GCompris - BuyMeOverlayInapp.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0

Item {

    anchors {
        fill: parent
        bottomMargin: bar.height * 1.2
    }
    Rectangle {
        anchors.fill: parent
        opacity: 0.5
        color: "grey"
    }
    /* Activation Instruction */
    Rectangle {
        id: instructionsArea
        z: 99
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: - cancelButton.width / 2
            top: parent.top
            topMargin: 40
        }
        width: parent.width - cancelButton.width * 2
        height: Math.max(instructionTxt.height, lock.height) + 2*row.anchors.margins
        radius: 10
        border.width: 2
        border.color: "black"
        color: 'white'

        Row {
            id: row
            anchors {
                fill: parent
                margins: 10
            }

            Image {
                id: lock
                source: "qrc:/gcompris/src/activities/menu/resource/lock.svg"
                sourceSize.width: 30 * ApplicationInfo.ratio
            }

            GCText {
                id: instructionTxt
                fontSize: mediumSize
                color: "black"
                style: Text.Outline
                styleColor: "white"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - lock.width
                wrapMode: TextEdit.WordWrap
                z: 2
                text: qsTr("This activity is only available in the full version of GCompris.")
            }
        }

        Button {
            width: instructionsArea.width * 0.9
            height: 60 * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: instructionsArea.bottom
                topMargin: 10
            }
            text: qsTr("Buy the full version").toUpperCase()
            style: GCButtonStyle {
                 theme: "highContrast"
           }

            onClicked: {
                if(ApplicationSettings.isDemoMode)
                    ApplicationSettings.isDemoMode = false
            }
        }
    }

    MultiPointTouchArea {
        // Just to catch mouse events
        anchors.fill: parent
    }

    Keys.onEscapePressed: home()
    Keys.onPressed: {
        event.accepted = true
        if (event.modifiers === Qt.ControlModifier &&
                event.key === Qt.Key_Q) {
            // Ctrl+Q exit the application
            Core.quit(page);
        } else if (event.modifiers === Qt.ControlModifier &&
                   event.key === Qt.Key_B) {
            // Ctrl+B toggle the bar
            ApplicationSettings.isBarHidden = !ApplicationSettings.isBarHidden;
        } else if (event.modifiers === Qt.ControlModifier &&
                   event.key === Qt.Key_F) {
            // Ctrl+F toggle fullscreen
            ApplicationSettings.isFullscreen = !ApplicationSettings.isFullscreen
        } else if (event.modifiers === Qt.ControlModifier &&
                   event.key === Qt.Key_M) {
            // Ctrl+M toggle sound
            ApplicationSettings.isAudioEffectsEnabled = !ApplicationSettings.isAudioEffectsEnabled
        } else if (event.modifiers === Qt.ControlModifier &&
                   event.key === Qt.Key_W) {
            // Ctrl+W exit the current activity
            home()
        }
    }

    // The cancel button
    GCButtonCancel {
        id: cancelButton
        onClose: home()
    }
}
