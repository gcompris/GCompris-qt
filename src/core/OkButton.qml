/* GCompris - OkButton.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
import GCompris 1.0

/**
 * Helper QML component for a "OK" (translatable string) button.
 * @ingroup components
 *
 */
Rectangle {
    id: button
    color: "#62ba62"
    border.color: "white"
    border.width:2
    width: 20
    height: width
    radius: width

    state: "notclicked"
    signal clicked

    function buttonClicked() {
        if(getDataCallback) {
            var data = getDataCallback()
            ClientNetworkMessages.sendActivityData(ActivityInfoTree.currentActivity.name, data)
        }
        button.clicked()
    }

    property var getDataCallback: null

    GCText {
        anchors.centerIn: parent
        text: qsTr("OK")
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: TextEdit.WordWrap
        color: "white"
        font.bold: true
        fontSize: largeSize
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: buttonClicked()
    }

    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: button
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: button
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: button
                scale: 1.1
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
    Behavior on opacity { PropertyAnimation { duration: 200 } }

}

