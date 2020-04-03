/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
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
import GCompris 1.0

Data {
    objective: qsTr("Balance the scales until 10.")
    difficulty: 2
    data: [
        {
            "masses": [[1, "1"], [1, "1"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"], [4, "4"], [5, "5"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")
        },
        {
            "masses": [[1, "1"], [2, "2"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"], [4, "4"], [5, "5"],[7,"7"],[8,"8"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")
        },
        {
            "masses": [[1, "1"], [1, "1"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"], [4, "4"], [5, "5"],[7,"7"],[8,"8"],[10,"10"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")
        },
        {
            "masses": [[6, "6"], [7, "7"], [3, "3"], [7, "7"], [6, "6"], [7, "7"], [9, "9"]],
            "targets": [[4, "4"], [8,"8"], [5, "5"]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scale.")
        },
        {
            "masses": [[6, "6"], [9, "9"], [6, "6"], [5, "5"], [9, "9"], [7, "7"], [11, "11"]],
            "targets": [[3, "3"], [8, "8"], [7,"7"],[10,"10"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scale."),
            "rightDrop": true
        },
        {
            "masses": [[1, "1"], [3, "3"], [2, "2"], [5, "5"], [7, "7"], [1, "1"], [2, "2"]],
            "targets": [[4, "4"], [7, "7"], [10, "10"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[1, "1"], [8, "8"], [2, "2"], [2, "2"], [7, "7"], [9, "9"], [6, "6"]],
            "targets": [[4, "4"], [7, "7"], [10, "10"],[5,"5"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        }
    ]
}
