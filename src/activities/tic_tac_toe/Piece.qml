/* GCompris - TicTacToe.qml
 *
 * Copyright (C) 2014 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
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
