/* GCompris - chess.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
import QtQuick 2.1

Image {
    id: piece
    property int pos
    Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    z: 10

    property bool acceptMove : false
    property int newPos
    // color = -1 if no piece, 0 is black and 1 is white
    property int isWhite

    SequentialAnimation {
        id: moveAnim
        NumberAnimation {
            target: piece
            property: "scale"
            duration: 200
            to: 0
        }
         PropertyAction {
             target: piece
             property: 'source'
             value: ""
         }
         PropertyAction {
             target: piece
             property: 'pos'
             value: piece.newPos
         }
         PropertyAction {
             target: piece
             property: 'scale'
             value: 1
         }
    }

    Rectangle {
        id: possibleMove
        anchors.fill: parent
        color: 'transparent'
        border.width: parent.acceptMove ? 5 : 0
        border.color: "black"
        z: 1
    }

    function hide(newPos) {
        piece.newPos = newPos
        moveAnim.start()
    }
}

