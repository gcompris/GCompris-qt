/* GCompris - Dataset.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
    property var levels: [
        // Level one
        {
            "map": [
                {'x': 1, 'y': 3},
                {'x': 1, 'y': 2},
                {'x': 1, 'y': 1},
                {'x': 2, 'y': 1},
                {'x': 3, 'y': 1}
            ],
            "fish": {'x': 3, 'y': 1},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "execute-loops"
            ],
            "maxNumberOfInstructions": 8
        },
        // Level two
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
                "turn-right",
                "execute-loops"
            ],
            "maxNumberOfInstructions": 5
        },
        // Level three
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
                "execute-loops"
            ],
            "maxNumberOfInstructions": 10
        },
        // Level four
        {
            "map": [
                {'x': 0, 'y': 3},
                {'x': 0, 'y': 2},
                {'x': 0, 'y': 1},
                {'x': 0, 'y': 0},
                {'x': 1, 'y': 0},
                {'x': 2, 'y': 0},
                {'x': 3, 'y': 0},
                {'x': 3, 'y': 1},
                {'x': 3, 'y': 2},
                {'x': 3, 'y': 3}
            ],
            "fish": {'x': 3, 'y': 3},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "execute-loops"
            ],
            "maxNumberOfInstructions": 14
        },
        // Level five
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
                "execute-loops"
            ],
            "maxNumberOfInstructions": 15
        },
        // Level six
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
                "turn-right",
                "execute-loops"
            ],
            "maxNumberOfInstructions": 15
        },
        // Level seven
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
                "execute-loops"
            ],
            "maxNumberOfInstructions": 15
        },
        // Level eight
        {
            "map": [
                {'x': 0, 'y': 1},
                {'x': 1, 'y': 1},
                {'x': 1, 'y': 0},
                {'x': 2, 'y': 0},
                {'x': 3, 'y': 0},
                {'x': 4, 'y': 0},
                {'x': 1, 'y': 2},
                {'x': 2, 'y': 2},
                {'x': 3, 'y': 2},
                {'x': 4, 'y': 2}
            ],
            "fish": {'x': 4, 'y': 2},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "execute-loops"
            ],
            "maxNumberOfInstructions": 14
        },
        // Level nine
        {
            "map": [
                {'x': 0, 'y': 0},
                {'x': 0, 'y': 1},
                {'x': 0, 'y': 2},
                {'x': 0, 'y': 3},
                {'x': 1, 'y': 3},
                {'x': 2, 'y': 3},
                {'x': 3, 'y': 3},
                {'x': 3, 'y': 2},
                {'x': 3, 'y': 1},
                {'x': 3, 'y': 0},
                {'x': 2, 'y': 0}
            ],
            "fish": {'x': 2, 'y': 0},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "execute-loops"
            ],
            "maxNumberOfInstructions": 12
        },
        // Level ten
        {
            "map": [
                {'x': 1, 'y': 0},
                {'x': 1, 'y': 1},
                {'x': 0, 'y': 0},
                {'x': 2, 'y': 0},
                {'x': 2, 'y': 1},
                {'x': 3, 'y': 0},
                {'x': 4, 'y': 0},
                {'x': 4, 'y': 1},
                {'x': 4, 'y': 2},
                {'x': 4, 'y': 3},
                {'x': 3, 'y': 3},
                {'x': 2, 'y': 3},
                {'x': 1, 'y': 3}
            ],
            "fish": {'x': 1, 'y': 3},
            "instructions": [
                "move-forward",
                "turn-left",
                "turn-right",
                "execute-loops"
            ],
            "maxNumberOfInstructions": 14
        }
    ]
}
