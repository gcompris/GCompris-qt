/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Maximum value: 50.")
    difficulty: 3
    property list<string> colors: [
        "#ee7f7f",
        "#eebf7f",
        "#e0ee7f",
        "#7fee8f",
        "#7fcbee",
        "#b8c8f6"
    ]
    data: [
        [
            {size: 50, circleColor: colors[0], score: 20},
            {size: 100, circleColor: colors[1], score: 10},
            {size: 150, circleColor: colors[2], score: 8},
            {size: 200, circleColor: colors[3], score: 4},
            {size: 250, circleColor: colors[4], score: 2},
            {size: 300, circleColor: colors[5], score: 1}
        ],
        [
            {size: 50, circleColor: colors[0], score: 30},
            {size: 100, circleColor: colors[1], score: 20},
            {size: 150, circleColor: colors[2], score: 10},
            {size: 200, circleColor: colors[3], score: 8},
            {size: 250, circleColor: colors[4], score: 4},
            {size: 300, circleColor: colors[5], score: 2},
            {size: 350, circleColor: colors[5], score: 1}
        ],
        [
            {size: 50, circleColor: colors[0], score: 50},
            {size: 100, circleColor: colors[1], score: 20},
            {size: 150, circleColor: colors[2], score: 10},
            {size: 200, circleColor: colors[3], score: 8},
            {size: 250, circleColor: colors[4], score: 4},
            {size: 300, circleColor: colors[5], score: 2},
            {size: 350, circleColor: colors[5], score: 1}
        ]
    ]
}
