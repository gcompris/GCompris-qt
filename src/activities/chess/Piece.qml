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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

Image {
    id: piece
    property int pos
    Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    z: 10

    property string img
    property bool acceptMove: false
    property int newPos
    // color = -1 if no piece, 0 is black and 1 is white
    property int isWhite: img.length != 2 ? -1 : img[0] == 'w' ? 1 : 0


    SequentialAnimation {
        id: hideAnim
        NumberAnimation {
            target: piece
            property: "scale"
            duration: 200
            to: 0
        }
        PropertyAction {
             target: piece
             property: 'img'
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
        PropertyAction {
            target: piece
            property: 'z'
            value: 2
        }
    }

    SequentialAnimation {
        id: promotionAnim
        PauseAnimation {
            duration: 200
        }
        NumberAnimation {
            target: piece
            property: 'scale'
            to: 0
        }
        PropertyAction {
            target: piece
            property: 'img'
            value: isWhite ? 'wq' : 'bq'
        }
        NumberAnimation {
            target: piece
            property: 'scale'
            to: 1
            easing.type: Easing.OutElastic
        }
    }

    function hide(newPos) {
        piece.newPos = newPos
        hideAnim.start()
    }

    function promotion() {
        promotionAnim.start()
    }

    function move(to) {
        piece.newPos = to
        piece.pos = to
        piece.z = 2
    }
}

