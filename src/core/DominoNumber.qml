/* GCompris - Domino.qml
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
import GCompris 1.0

Item {
    id: item
    property int value
    property int valueMax
    property color color
    property color borderColor
    property int borderWidth
    property int radius

    function isVisible(index) {
        var value = item.value
        var visible = false
        switch(index) {
        case 0:
            if(value >= 2) visible = true
            break
        case 1:
            if(value >= 6) visible = true
            break
        case 2:
            if(value >= 4) visible = true
            break
        case 3:
            if(value >= 8) visible = true
            break
        case 4:
            if(value == 1 || value == 3 || value == 5 ||
               value == 7 || value == 9) visible = true
            break
        case 5:
            if(value >= 8) visible = true
            break
        case 6:
            if(value >= 4) visible = true
            break
        case 7:
            if(value >= 6) visible = true
            break
        case 8:
            if(value >= 2) visible = true
            break
        }
        return visible
    }

    Grid {
        columns: 3
        spacing: 3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        horizontalItemAlignment: Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter

        Repeater {
            model: 9
            Rectangle {
                width: radius
                height: radius
                border.width: item.borderWidth
                color: item.color
                border.color: item.borderColor
                radius: item.radius
                opacity: isVisible(index)

                Behavior on opacity { PropertyAnimation { duration: 200 } }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                if(item.value == item.valueMax)
                    item.value = 0
                else
                    item.value++
            } else {
                if(item.value == 0)
                    item.value = item.valueMax
                else
                    item.value--
            }
        }
    }

}
