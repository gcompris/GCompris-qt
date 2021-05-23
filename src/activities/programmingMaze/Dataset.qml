/* GCompris - Dataset.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

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
