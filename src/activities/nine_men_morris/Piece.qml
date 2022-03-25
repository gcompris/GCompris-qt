/* GCompris - Piece.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitnsit@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "nine_men_morris.js" as Activity

import GCompris 1.0

Image {
    id: piece
    property QtObject pieceParent
    property QtObject visualParent
    property double moveX
    property double moveY
    property int parentIndex: -1
    property bool canBeRemoved: false
    property bool firstPhase
    property bool isSelected: false
    property bool playSecond
    property bool gameDone
    property bool pieceBeingMoved
    property int chance
    opacity: 1.0
    sourceSize.height: height
    width: height

    ParallelAnimation {
        id: pieceAnimation
        NumberAnimation {
            target: piece
            easing.type: Easing.OutQuad
            property: "x"
            to: moveX
            duration: 430
        }
        NumberAnimation {
            target: piece
            easing.type: Easing.OutQuad
            property: "y"
            to: moveY
            duration: 430
        }
        onStarted: {
            piece.anchors.verticalCenter = undefined
            piece.anchors.centerIn = undefined
        }
        onStopped: {
            piece.parent = visualParent
            piece.anchors.centerIn = visualParent
            piece.pieceParent.state = piece.state
            piece.pieceParent.pieceIndex = index
            if (Activity.checkMill(piece.parentIndex,piece.state))
                Activity.updateRemovablePiece()
            else if (firstPhase)
                Activity.continueGame()
            else
                Activity.checkGameWon()
        }
    }

    NumberAnimation {
        id: removePieceAnimation
        target: piece
        property: "opacity"
        to: 0
        duration: 430
        onStarted: { Activity.removePieceSelected(index) }
        onStopped: { Activity.removePiece(index) }
    }

    states: [
        State {
            name: "1" // Player 1
            PropertyChanges {
                target: piece
                source: playSecond ? Activity.url + "black_piece.svg" : Activity.url + "white_piece.svg"
            }
        },
        State {
            name: "2" // Player 2
            PropertyChanges {
                target: piece
                source: playSecond ? Activity.url + "white_piece.svg" : Activity.url + "black_piece.svg"
            }
        }
    ]

    MouseArea {
        id: area
        property bool turn: chance ? piece.state == "2" : piece.state == "1"
        enabled: ((canBeRemoved && !turn) || (!firstPhase && turn)) &&
                  (piece.parentIndex != -1) && !gameDone && (!pieceBeingMoved || canBeRemoved)
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        onClicked: {
            if (canBeRemoved)
                removePieceAnimation.start()
            else {
                isSelected = true
                Activity.pieceSelected(index);
            }
        }
    }

    Rectangle {
        id: boundary
        anchors.centerIn: piece
        width: piece.width
        height: width
        visible: ((piece.visible && area.enabled && firstPhase) || isSelected) || canBeRemoved
        opacity: 1
        radius: width * 0.5
        border.width: width * 0.1
        border.color: canBeRemoved ? "#DC3D3D" : "#74F474" // red : green same as in DragPoint.qml
        color: "transparent"
        z: -1
    }

    function move(pieceChangeParent) {
        piece.pieceParent = pieceChangeParent
        piece.parentIndex = pieceChangeParent.index
        piece.visualParent = items.piecesLayout.itemAt(piece.parentIndex)
        piece.height = Qt.binding(function() { return pieceParent.width * 2.5 })
        var coord = piece.parent.mapFromItem(pieceChangeParent.parent, pieceChangeParent.x + pieceChangeParent.width / 2 -
                    piece.width / 2, pieceChangeParent.y + pieceChangeParent.height / 2 - piece.height / 2)
        piece.moveX = coord.x
        piece.moveY = coord.y
        pieceAnimation.start()
    }

    function remove() {
        removePieceAnimation.start()
    }
}
