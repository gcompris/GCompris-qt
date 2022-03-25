/* GCompris - Message.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"

Item {
    id: message

    property alias text: messageText.text
    property bool displayed: messageText.text != "" ? true : false

    Rectangle {
        id: messageBg
        x: messageText.x - 4
        y: messageText.y - 4
        width: messageText.width + 8
        height: messageText.height + 8
        color: "#ddd6e598"
        border.color: "black"
        border.width: 2
        radius: 8
        opacity: message.displayed ? 1 : 0

        MouseArea {
            anchors.fill: parent
            onClicked: message.text = ""
        }
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }
    
    GCText {
        id: messageText
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
        color: "black"
        fontSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: TextEdit.WordWrap
        opacity: message.displayed ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }
}
