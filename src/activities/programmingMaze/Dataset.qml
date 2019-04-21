/* GCompris - Dataset.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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
import QtQuick 2.6

QtObject {
    property var levels: [
        // Level one
        {
            "map": [
                {'x': 1, 'y': 2},
                {'x': 2, 'y': 2},
                {'x': 3, 'y': 2}
            ],
            "fish": {'x': 3, 'y': 2},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right"
            ],
            "maxNumberOfInstructions": 4
        },
        // Level two
        {
            "map": [
                {'x': 1, 'y': 3},
                {'x': 2, 'y': 3},
                {'x': 2, 'y': 2},
                {'x': 2, 'y': 1},
                {'x': 3, 'y': 1}
            ],
            "fish": {'x': 3, 'y': 1},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right"
            ],
            "maxNumberOfInstructions": 8
        },
        // Level three
        {
            "map": [
                {'x': 0, 'y': 3},
                {'x': 0, 'y': 2},
                {'x': 0, 'y': 1},
                {'x': 1, 'y': 1},
                {'x': 2, 'y': 1},
                {'x': 3, 'y': 1},
                {'x': 3, 'y': 2},
                {'x': 3, 'y': 3},
                {'x': 2, 'y': 3}
            ],
            "fish": {'x': 2, 'y': 3},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right"
            ],
            "maxNumberOfInstructions": 14
        },
        // Level four
        {
            "map": [
                {'x': 0, 'y': 1},
                {'x': 1, 'y': 1},
                {'x': 1, 'y': 0},
                {'x': 2, 'y': 0},
                {'x': 3, 'y': 0},
                {'x': 4, 'y': 0},
                {'x': 1, 'y': 2},
                {'x': 1, 'y': 3},
                {'x': 2, 'y': 3},
                {'x': 3, 'y': 3},
                {'x': 4, 'y': 3},
                {'x': 4, 'y': 2}
            ],
            "fish": {'x': 4, 'y': 2},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right"
            ],
            "maxNumberOfInstructions": 14
        },
        // Level five
        {
            "map": [
                {'x': 0, 'y': 1},
                {'x': 0, 'y': 0},
                {'x': 1, 'y': 0},
                {'x': 2, 'y': 0},
                {'x': 3, 'y': 0},
                {'x': 4, 'y': 0},
                {'x': 0, 'y': 2},
                {'x': 0, 'y': 3},
                {'x': 1, 'y': 3},
                {'x': 2, 'y': 3},
                {'x': 3, 'y': 3},
                {'x': 4, 'y': 3},
                {'x': 2, 'y': 1},
                {'x': 2, 'y': 2},
                {'x': 4, 'y': 2}
            ],
            "fish": {'x': 4, 'y': 2},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right"
            ],
            "maxNumberOfInstructions": 15
        },
        // Level six
        {
            "map": [
                {'x': 1, 'y': 1},
                {'x': 2, 'y': 1},
                {'x': 3, 'y': 1},
                {'x': 3, 'y': 2},
                {'x': 3, 'y': 3},
                {'x': 2, 'y': 3},
                {'x': 1, 'y': 3}
            ],
            "fish": {'x': 1, 'y': 3},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "call-procedure"
            ],
            "maxNumberOfInstructions": 7
        },
        // Level seven
        {
            "map": [
                {'x': 0, 'y': 3},
                {'x': 1, 'y': 3},
                {'x': 2, 'y': 3},
                {'x': 2, 'y': 2},
                {'x': 2, 'y': 1},
                {'x': 3, 'y': 1},
                {'x': 4, 'y': 1},
                {'x': 4, 'y': 2},
                {'x': 4, 'y': 3}
            ],
            "fish": {'x': 4, 'y': 3},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "call-procedure"
            ],
            "maxNumberOfInstructions": 10
        },
        // Level eight
        {
            "map": [
                {'x': 0, 'y': 3},
                {'x': 1, 'y': 3},
                {'x': 1, 'y': 2},
                {'x': 2, 'y': 2},
                {'x': 2, 'y': 1},
                {'x': 3, 'y': 1},
                {'x': 3, 'y': 0},
                {'x': 4, 'y': 0}
            ],
            "fish": {'x': 4, 'y': 0},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "call-procedure"
            ],
            "maxNumberOfInstructions": 12
        },
        // Level nine
        {
            "map": [
                {'x': 1, 'y': 1},
                {'x': 0, 'y': 0},
                {'x': 1, 'y': 0},
                {'x': 2, 'y': 0},
                {'x': 2, 'y': 1},
                {'x': 3, 'y': 0},
                {'x': 4, 'y': 0},
                {'x': 4, 'y': 1},
                {'x': 4, 'y': 2},
                {'x': 4, 'y': 3},
                {'x': 3, 'y': 3},
                {'x': 2, 'y': 3},
                {'x': 1, 'y': 3},
                {'x': 0, 'y': 3},
                {'x': 0, 'y': 2}
            ],
            "fish": {'x': 0, 'y': 2},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "call-procedure"
            ],
            "maxNumberOfInstructions": 14
        },
        // Level ten
        {
            "map": [
                {'x': 0, 'y': 3},
                {'x': 0, 'y': 2},
                {'x': 0, 'y': 1},
                {'x': 0, 'y': 0},
                {'x': 1, 'y': 0},
                {'x': 2, 'y': 0},
                {'x': 2, 'y': 1},
                {'x': 2, 'y': 2},
                {'x': 2, 'y': 3},
                {'x': 3, 'y': 3},
                {'x': 4, 'y': 3},
                {'x': 4, 'y': 2},
                {'x': 4, 'y': 1},
                {'x': 4, 'y': 0}
            ],
            "fish": {'x': 4, 'y': 0},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "call-procedure"
            ],
            "maxNumberOfInstructions": 15
        }
    ]
}
