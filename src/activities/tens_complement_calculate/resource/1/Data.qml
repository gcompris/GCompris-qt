/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2024 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

/*
data usage:
"value": [
  [
    // First part of dataset is 2 levels with 3 random elements in the row (1 pair equals to 10).
    {
      "randomValues": true,
      "numberOfElements": 3
    },
    {
      "randomValues": true,
      "numberOfElements": 3
    }
  ],
  [
    // Level 2 is with fixed numbers, we write them all. Make sure they pair well. If randomizeOrder is not specified, default is true.
    {
      "randomizeOrder": false,
      "numberValue": [1, 3, 9]
    },
    {
      "randomizeOrder": true,
      "numberValue": [7, 6, 4]
    }
  ]
]
*/
Data {
    objective: qsTr("1 pair to make from 3 numbers.")
    difficulty: 4
    data: [
        {
            "value": [
                [
                    {
                        "randomValues": true,
                        "numberOfElements": 3
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 3
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 3
                    }
                ],
                [
                    {
                        "randomValues": true,
                        "numberOfElements": 3
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 3
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 3
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 3
                    }
                ]
            ]
        }
    ]
}
