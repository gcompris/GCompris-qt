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
    objective: qsTr("Balance the scales until 20.")
    difficulty: 3
    data: [
        {
            "masses": [[1, "1"], [1, "1"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"], [4, "4"], [5, "5"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")
        },
        {
            "masses": [[1, "1"], [2, "2"], [2, "2"], [4, "4"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"], [4, "4"], [5, "5"],[7,"7"],[8,"8"], [10,"10"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")
        },
        {
            "masses": [[3, "3"], [5, "5"], [7, "7"], [8, "8"], [9, "9"], [2, "2"], [5, "5"]],
            "targets": [[8, "8"], [13, "13"], [15, "15"],[17,"17"],[20,"20"],[10,"10"],[11,"11"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")
        },
        {
            "masses": [[6, "6"], [9, "9"], [2, "2"], [5 ,"5"], [6, "6"], [10, "10"], [11, "11"]],
            "targets": [[7, "7"], [8,"8"], [1, "1"]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scale.")
        },
        {
            "masses": [[6, "6"], [4, "4"], [12, "12"], [11, "11"], [4, "4"], [13, "13"], [14, "14"]],
            "targets": [[3, "3"], [8,"8"], [9, "9"], [7,"7"],[10,"10"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scale."),
            "rightDrop": true
        },
        {
            "masses": [[10, "10"], [7, "7"], [6, "6"], [11, "11"], [13, "13"], [11, "11"], [3, "3"]],
            "targets": [[12, "12"], [15,"15"], [19, "19"], [20,"20"],[17,"17"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scale."),
            "rightDrop": true
        },
        {
            "masses": [[1, "1"], [3, "3"], [2, "2"], [5, "5"], [7, "7"], [1, "1"], [2, "2"]],
            "targets": [[4, "4"], [7, "7"], [10, "10"],[6,"6"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[1, "1"], [8, "8"], [2, "2"], [1, "1"], [7, "7"], [9, "9"], [10, "10"]],
            "targets": [[4, "4"], [7, "7"], [10, "10"],[5,"5"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[3, "3"], [5, "5"], [7, "7"], [8, "8"], [9, "9"], [2, "2"], [4, "4"]],
            "targets": [[8, "8"], [13, "13"], [15, "15"],[17,"17"],[20,"20"],[10,"10"],[11,"11"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        }
    ]
}
