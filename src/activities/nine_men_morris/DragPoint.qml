/* GCompris - DragPoint.qml
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

Rectangle {
    id: dragPoint
    width: parent.width * 0.05
    height: width
    radius: width * 0.5
    opacity: 1.0
    border.color: "#505050"
    border.width: width * 0.15
    state: "AVAILABLE"

    property int index
    property bool firstPhase
    property bool pieceBeingMoved
    property int pieceIndex
    property QtObject leftPoint
    property QtObject rightPoint
    property QtObject upperPoint
    property QtObject lowerPoint

    states: [
        State {
            name: "AVAILABLE" // Green color
            PropertyChanges {
                target: dragPoint
                color: "#74F474"
            }
        },
        State {
            name: "UNAVAILABLE" // Red color
            PropertyChanges {
                target: dragPoint
                color: "#DC3D3D"
            }
        },
        State {
            name: "EMPTY" // Brown color
            PropertyChanges {
                target: dragPoint
                color: "#505050"
            }
        },
        State {
            name: "1"
            PropertyChanges {
                target: dragPoint
                color: "#DC3D3D"
            }
        },
        State {
            name: "2"
            PropertyChanges {
                target: dragPoint
                color: "#DC3D3D"
            }
        }
    ]

    MouseArea {
        id: area
        enabled: parent.state == "AVAILABLE" && !pieceBeingMoved
        anchors.centerIn: parent
        width: 2.5 * parent.width
        height: 2.5 * parent.height
        onClicked: {
            if (firstPhase)
                Activity.handleCreate(index)
            else
                Activity.movePiece(index)
        }
    }
}
