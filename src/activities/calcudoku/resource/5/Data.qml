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

Data {
    //: \u002B is the unicode character for addition mathematical operator (+), \u2212 for subtraction (-), \u00D7 for multiplication (*), \u2215 for division (:)
    objective: qsTr("Large grids with \u002B, \u2212, \u00D7 and \u2215 operators.")
    difficulty: 6

    property var symbols: [
        {"imgName": "1.svg", "text": '1'},
        {"imgName": "2.svg", "text": '2'},
        {"imgName": "3.svg", "text": '3'},
        {"imgName": "4.svg", "text": '4'},
        {"imgName": "5.svg", "text": '5'}
    ]

    data: [
        {
            "random": true,
            "length": 20,
            "symbols": symbols,
            "size": 5,
            "operators": ["+", "-", "*", ":"]
        }
    ]
}
