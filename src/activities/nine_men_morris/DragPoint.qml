/* GCompris - DragPoint.qml
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

import "../../core"
import "nine_men_morris.js" as Activity

import GCompris 1.0

Rectangle {
    id: dragPoint
	width: parent.width/26
    height: width
    radius: width/2
    opacity: 1.0
    border.color: "#803300"
    border.width: state == "EMPTY" ? 0 : width/6    
    state: "AVAILABLE"
	
	property int index
	property bool test
    property bool pieceBeingRemoved
    property bool firstPhase
    property QtObject leftPiece
    property QtObject rightPiece
    property QtObject upperPiece
    property QtObject lowerPiece
    
    states: [
		State {
            name: "AVAILABLE" // Green color
            PropertyChanges{
                target: dragPoint
                color: "#00ff00"
            }
        },
        State {
            name: "UNAVAILABLE" // Red color
            PropertyChanges{
                target: dragPoint
                color: "Red"
            }
        },
        State {
            name: "EMPTY" // Brown color
            PropertyChanges{
                target: dragPoint
                color: "#803300"
            }
        },
        State {
            name: "1" // Red color
            PropertyChanges {
                target: dragPoint
                color: "Red"
            }
        },
        State {
            name: "2" // Red color
            PropertyChanges {
                target: dragPoint
                color: "Red"
            }
        }
    ]
    
    MouseArea {
		id: area
		enabled: parent.state == "AVAILABLE" && !pieceBeingRemoved
		anchors.centerIn: parent
		width: 2.5*parent.width
		height: 2.5*parent.height
		onClicked: {
			if (firstPhase)
				Activity.handleCreate(index)
			else
				Activity.movePiece(index)
		}
	}
}
