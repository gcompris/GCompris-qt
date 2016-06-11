/* GCompris - Piece.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitnsit@gmail.com>
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

import QtGraphicalEffects 1.0
import "../../core"
import "nine_men_morris.js" as Activity

import GCompris 1.0

Image {
    id: piece
    property QtObject pieceParent 
    property double moveX
    property double moveY
    property int parentIndex: -1
    property bool canBeRemoved: false
    property bool initial: true
    property bool firstPhase
    property bool isSelected: false
    property bool playSecond
    property bool gameDone
    property int chance
    opacity: 1.0//0.5

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
            //piece.sourceSize.height = pieceParent.width*2.5
            //piece.sourceSize.height = Qt.binding(function() { return pieceParent.parent.width/8 })
            //piece.sourceSize.height = Qt.binding(function() { return pieceParent.width*2.5 })
        }
        onStopped: {
            //tileImage.parent = tileImage.tileImageParent
            //tileImage.anchors.centerIn = tileImage.currentTargetSpot == null ? tileImage.parent : tileImage.currentTargetSpot
            //updateOkButton()
            piece.parent = pieceParent
            piece.anchors.centerIn = pieceParent
            piece.parent.state = piece.state
            if (Activity.checkMill(piece))
				Activity.UpdateRemovablePiece()
            else if (firstPhase)
				Activity.continueGame()
			else
				Activity.checkGameWon()
        }
    }
	/*ParentAnimation {
		id: pieceAnimation
		target: piece
		newParent: pieceParent
        NumberAnimation { properties: "x,y"; duration: 1000 }
        onStarted: {
            console.log("start")
        }
        onStopped: {
            console.log("stop")
        }
    }*/

    states: [
		State {
			name: "invisible"
			PropertyChanges {
				target: piece
				visible: false
			}
		},
		State {
			name: "1" // Player 1
			PropertyChanges{
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
		enabled: ((canBeRemoved && !turn) || (!firstPhase && turn)) 
				  && (piece.parentIndex != -1) && !gameDone
		anchors.centerIn: parent
		width: parent.width
		height: parent.height
		onClicked: {
			//console.log("gameDone",gameDone,"enabled",enabled)
			if (canBeRemoved)
				Activity.removePiece(index)
			else {
				isSelected = true
				Activity.pieceSelected(index);
			}
		}
	}
	
	Rectangle {
		id: boundary
		anchors.centerIn: parent
		width: parent.width
		height: parent.height
		visible: ((parent.visible && area.enabled && firstPhase) || isSelected) || canBeRemoved
		opacity: 1
		radius: width/2
		border.width: 3
		border.color: "green"
		color: "transparent"
		z: -1
	}
	
    /*
    Behavior on parent {
		//ParentAnimation {
			//NumberAnimation { properties: "x,y"; duration: 1000 }
		//}
		NumberAnimation { duration: 1000 }
	}*/
	
	function move(pieceChangeParent) {
		piece.pieceParent = pieceChangeParent
		piece.parentIndex = pieceChangeParent.index
		piece.sourceSize.height = Qt.binding(function() { return pieceParent.width*2.5 })
		var coord = piece.parent.mapFromItem(pieceChangeParent.parent, pieceChangeParent.x + pieceChangeParent.width/2 -
						piece.width/2, pieceChangeParent.y + pieceChangeParent.height/2 - piece.height/2)
		piece.moveX = coord.x
		piece.moveY = coord.y
		pieceAnimation.start()
	}
}
