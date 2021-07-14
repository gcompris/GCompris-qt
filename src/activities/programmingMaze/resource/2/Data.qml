/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Using both the main area and the procedure area.")
    difficulty: 2
    data: [
        // Level one
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
        // Level two
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
        // Level three
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
        // Level four
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
        // Level five
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
