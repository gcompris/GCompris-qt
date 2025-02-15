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

import core 1.0

Image {
    id: piece

    opacity: 1.0
    sourceSize.width: width
    sourceSize.height: height

    states: [
        State {
            name: "invisible"
            PropertyChanges {
                piece {
                    opacity: 0
                }
            }
        },
	State {
            name: "2" // Player 2
            PropertyChanges {
                piece {
                    source: Activity.url + "circle.svg"
                }
            }
        },
        State {
            name: "1" // Player 1
            PropertyChanges {
                piece {
                    source: Activity.url + "cross.svg"
                }
            }
        }
    ]
}
