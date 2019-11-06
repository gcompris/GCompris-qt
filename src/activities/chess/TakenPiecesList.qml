/* GCompris - TakenPiecesList.qml
 *
 * Copyright (C) 2018 Smit S. Patil <smit17av@gmail.com>
 *
 * Authors:
 *   Smit S. Patil <smit17av@gmail.com>
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
import "chess.js" as Activity

Rectangle {

    property alias takenPiecesModel: pieceList
    property var pushedLast: []
    property double openWidth
    property bool open: false

    // left = false, right = true
    property bool edge

    height: parent.height
    width: open ? openWidth : 0
    color: edge ? "#88EEEEEE" : "#88111111"

    Behavior on width {
        NumberAnimation { duration: 200 }
    }

    anchors {
        left: edge ? undefined : parent.left
        right: edge ? parent.right : undefined
    }

    Flow {
        anchors.fill:parent
        layoutDirection: edge ? Qt.RightToLeft : Qt.LeftToRight

        Repeater {
            model: ListModel { id:pieceList }
            Piece {
                id: piece
                sourceSize.width: width
                width: open ? piece.height : 0
                height: parent.height / 18
                source: img ? Activity.url + img + '.svg' : ''
                img: model.img
                newPos: model.pos

                Behavior on width {
                    NumberAnimation { duration: 200 }
                }
            }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            whiteTakenPieces.open = false
            blackTakenPieces.open = false
        }
    }
}
