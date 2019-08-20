
/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import "../../../../core"

Dataset {
    objective: qsTr("Practice addition on targets with max value 50000")
    difficulty: 5
    property var colors: [
        "#ff1b00",
        "#7edee2",
        "#f1f500",
        "#3dff00",
        "#b7d2d4",
        "#6db5ba"
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
            {size: 50, color: colors[0], score: 10000},
            {size: 100, color: colors[1], score: 4000},
            {size: 150, color: colors[1], score: 1000},
            {size: 200, color: colors[2], score: 300},
            {size: 250, color: colors[2], score: 100},
            {size: 300, color: colors[3], score: 30},
            {size: 350, color: colors[3], score: 10},
            {size: 400, color: colors[4], score: 8},
            {size: 450, color: colors[4], score: 4},
            {size: 500, color: colors[5], score: 2},
            {size: 550, color: colors[5], score: 1}
        ],
        [
            {size: 50, color: colors[0], score: 50000},
            {size: 100, color: colors[1], score: 10000},
            {size: 150, color: colors[1], score: 4000},
            {size: 200, color: colors[2], score: 1000},
            {size: 250, color: colors[2], score: 300},
            {size: 300, color: colors[3], score: 100},
            {size: 350, color: colors[3], score: 30},
            {size: 400, color: colors[4], score: 10},
            {size: 450, color: colors[4], score: 8},
            {size: 500, color: colors[5], score: 4},
            {size: 550, color: colors[5], score: 2},
            {size: 600, color: colors[5], score: 1},
        ]
    ]
}
