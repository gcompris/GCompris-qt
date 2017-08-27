/* GCompris - ReadyButton.qml
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

Rectangle {
    
    
    property string theme: "dark"

    /**
     * type:variant
     * existing themes for the button.
     * A theme is composed of:
     *   the button's border color
     *   the text color
    */
    property variant themes: {
        "dark": {
            borderColor: "#FF373737",
            fillColor0: "#A8FFFFFF",
            fillColor1: "#68FFFFFF",
            textColor: "#FF373737"
        },
        "light": {
            borderColor: "white",
            fillColor0: "#42FFFFFF",
            fillColor1: "#23FFFFFF",
            textColor: "white"
        }
    }

    
    
    id: iamReady
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    border.color: themes[theme].borderColor
    visible: true
    radius: 10
    smooth: true
    border.width: 4
    width: iamReadyText.width + 50 * ApplicationInfo.ratio
    height: iamReadyText.height + 50 * ApplicationInfo.ratio
    gradient: Gradient {
            GradientStop { position: 0 ; color: themes[theme].fillColor0 }
            GradientStop { position: 1 ; color: themes[theme].fillColor1 }
        }
    signal clicked

    GCText {
        id: iamReadyText
        color: themes[theme].textColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
        fontSize: mediumSize
        text: qsTr("I am Ready")
        visible: iamReady.visible
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            iamReady.visible = false
            iamReady.clicked()
        }
    }

    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: iamReady
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: iamReady
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: iamReady
                scale: 1.1
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
}
