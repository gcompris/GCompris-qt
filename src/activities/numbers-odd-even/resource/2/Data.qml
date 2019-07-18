
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
    objective: qsTr("Select even and odd numbers upto 30")
    difficulty: 1
    data: [
        {
            data: "0 2 4 6 8 10 12 14 16 18 20".split(" "),
            showNext: true
        },
        {
            data: "1 3 5 7 9 11 13 15 17 19 21".split(" "),
            showNext: true
        },
        {
            data: "0 2 4 6 8 10 12 14 16 18 20 22 24 26".split(" "),
            showNext: false
        },
        {
            data: "1 3 5 7 9 11 13 15 17 19 21 23 25 27".split(" "),
            showNext: false
        },
        {
            data: "0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30".split(" "),
            showNext: false
        },
        {
            data: "1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31".split(" "),
            showNext: false
        }
    ]
}