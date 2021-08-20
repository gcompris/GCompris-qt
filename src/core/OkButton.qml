/* GCompris - OkButton.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
            clientNetworkMessages.sendActivityData(ActivityInfoTree.currentActivity.name, data)
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
