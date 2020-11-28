/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Maximum value: 500.")
    difficulty: 4
    property var colors: [
        "#ee7f7f",
        "#eebf7f",
        "#e0ee7f",
        "#7fee8f",
        "#7fcbee",
        "#b8c8f6"
    ]
    data: [
        [
            {size: 50, color: colors[0], score: 100},
            {size: 100, color: colors[1], score: 20},
            {size: 150, color: colors[2], score: 10},
            {size: 200, color: colors[3], score: 8},
            {size: 250, color: colors[4], score: 4},
            {size: 300, color: colors[5], score: 2},
            {size: 350, color: colors[5], score: 1}
        ],
        [
            {size: 50, color: colors[0], score: 300},
            {size: 100, color: colors[1], score: 100},
            {size: 150, color: colors[2], score: 30},
            {size: 200, color: colors[3], score: 20},
            {size: 250, color: colors[3], score: 10},
            {size: 300, color: colors[4], score: 8},
            {size: 350, color: colors[4], score: 4},
            {size: 400, color: colors[5], score: 2},
            {size: 450, color: colors[5], score: 1},
        ],
        [
            {size: 50, color: colors[0], score: 500},
            {size: 100, color: colors[1], score: 300},
            {size: 150, color: colors[2], score: 100},
            {size: 200, color: colors[2], score: 30},
            {size: 250, color: colors[3], score: 20},
            {size: 300, color: colors[3], score: 10},
            {size: 350, color: colors[4], score: 8},
            {size: 400, color: colors[4], score: 4},
            {size: 450, color: colors[5], score: 2},
            {size: 450, color: colors[5], score: 1}
        ]
    ]
}
