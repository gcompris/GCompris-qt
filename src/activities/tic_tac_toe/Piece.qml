/* GCompris - TicTacToe.qml
 *
 * SPDX-FileCopyrightText: 2014 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "tic_tac_toe.js" as Activity

import GCompris 1.0

Image {
    id: piece

    opacity: 1.0

    states: [
        State {
            name: "invisible"
            PropertyChanges {
                target: piece
                opacity: 0
            }
        },
	State {
            name: "2" // Player 2
            PropertyChanges{
                target: piece
                source: Activity.url + "circle.svg"
            }
        },
        State {
            name: "1" // Player 1
            PropertyChanges {
                target: piece
                source: Activity.url + "cross.svg"
            }
        }
    ]
}
