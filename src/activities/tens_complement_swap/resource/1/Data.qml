/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

/*
data usage:
"value": [
  [
    // First part of dataset is 2 levels with 4 random elements in the row (2 pairs equals to 10).
    {
      "randomValues": true,
      "numberOfElements": 4
    },
    {
      "randomValues": true,
      "numberOfElements": 4
    }
  ],
  [
    // Level 2 is with fixed numbers, we write them all. Make sure they pair well. If randomizeOrder is not specified, default is true.
    {
      "randomizeOrder": false,
      "numberValue": [1, 3, 9, 7]
    },
    {
      "randomizeOrder": true,
      "numberValue": [7, 6, 4, 3]
    }
  ]
]
*/
Data {
    objective: qsTr("2 pairs to make from 4 numbers.")
    difficulty: 4
    data: [
        {
            "value": [
                [
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    }
                ],
                [
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    }
                ],
                [
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    }
                ],
                [
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 4
                    }
                ]
            ]
        }
    ]
}
