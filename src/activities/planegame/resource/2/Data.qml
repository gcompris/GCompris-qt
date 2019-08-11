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
    objective: qsTr("Count numbers up to 20")
    difficulty: 2
    //: If the value of variable showNext is true then the next number to be selected is shown as hint, otherwise not.
    data: [
        {
            data: "0 1 2 3 4 5 6 7 8 9 10".split(" "),
            showNext: true
        },
        {
            data: "0 1 2 3 4 5 6 7 8 9 10 11 12".split(" "),
            showNext: true
        },
        {
            data: "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14".split(" "),
            showNext: false
        },
        {
            data: "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16".split(" "),
            showNext: false
        },
        {
            data: "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18".split(" "),
            showNext: false
        },
        {
            data: "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20".split(" "),
            showNext: false
        }
    ]
}
