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
import "../../programmingMaze.js" as Activity

Data {
    objective: qsTr("Using both the main area and the loop area.")
    difficulty: 3
    data: [
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
                Activity.MOVE_FORWARD,
                Activity.TURN_LEFT,
                Activity.TURN_RIGHT,
                Activity.EXECUTE_LOOPS
            ],
            "maxNumberOfInstructions": 5
        },
        // Level two
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
                Activity.MOVE_FORWARD,
                Activity.TURN_LEFT,
                Activity.TURN_RIGHT,
                Activity.EXECUTE_LOOPS
            ],
            "maxNumberOfInstructions": 4
        },
        // Level three
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
                Activity.MOVE_FORWARD,
                Activity.TURN_LEFT,
                Activity.TURN_RIGHT,
                Activity.EXECUTE_LOOPS
            ],
            "maxNumberOfInstructions": 6
        },
        // Level four
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
                Activity.MOVE_FORWARD,
                Activity.TURN_LEFT,
                Activity.TURN_RIGHT,
                Activity.EXECUTE_LOOPS
            ],
            "maxNumberOfInstructions": 8
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
                Activity.MOVE_FORWARD,
                Activity.TURN_LEFT,
                Activity.TURN_RIGHT,
                Activity.EXECUTE_LOOPS
            ],
            "maxNumberOfInstructions": 8
        }
    ]
}
