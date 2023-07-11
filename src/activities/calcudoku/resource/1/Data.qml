/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

/**
Create a manual level:
    data: [
        {
            "random": false,
            "symbols": symbols,
            "data": [
                {
                    "cages": [
                        {
                            indexes: [0, 4, 5],
                            result: 6,
                            operator: "*"
                        },
                        {
                            indexes: [8, 12],
                            result: 1,
                            operator: "-"
                        },
                        {
                            indexes: [1, 2, 6],
                            result: 16,
                            operator: "*"
                        },
                        {
                            indexes: [9, 10],
                            result: 1,
                            operator: "-"
                        },
                        {
                            indexes: [13],
                            result: 1,
                            operator: ""
                        },
                        {
                            indexes: [14, 15],
                            result: 2,
                            operator: ":"
                        },
                        {
                            indexes: [3, 7, 11],
                            result: 6,
                            operator: "+"
                        }
                    ],
                    "size": 4
                }
            ]
        }
    ]
*/

Data {
    //: \u002B is the unicode character for addition mathematical operator (+)
    objective: qsTr("Small grids with \u002B operator.")
    difficulty: 3

    property var symbols: [
        {"imgName": "1.svg", "text": '1'},
        {"imgName": "2.svg", "text": '2'},
        {"imgName": "3.svg", "text": '3'}
    ]

    data: [
        {
            "random": true,
            "length": 20,
            "symbols": symbols,
            "size": 3,
            "operators": ["+"]
        }
    ]
}
