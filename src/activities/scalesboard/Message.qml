/* GCompris - Message.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
