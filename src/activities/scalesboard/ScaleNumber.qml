/* GCompris - Scalesboard.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

Scalesboard {
    dataset: [
            {
                "masses": [[1, "1"], [2, "2"], [2, "2"], [5, "5"], [5, "5"], [10, "10"], [10, "10"]],
                "targets": [[3, "3"], [4, "4"], [6, "6"], [7, "7"], [8, "8"], [9, "9"]],
                "rightDrop": false
            },
            {
                "masses": [[1, "1"], [2, "2"], [2, "2"], [5, "5"], [5, "5"], [10, "10"], [10, "10"]],
                "targets": [[3, "3"], [4, "4"], [6, "6"], [7, "7"], [8, "8"], [9, "9"]],
                "rightDrop": false
            },
            {
                "masses": [[1, "1"], [2, "2"], [2, "2"], [5, "5"], [5, "5"], [10, "10"], [10, "10"]],
                "targets": [[12, "12"], [13, "13"], [14, "14"], [15, "15"], [16, "16"]],
                "rightDrop": false
            },
            {
                "masses": [[2, "2"], [2, "2"], [5, "5"], [5, "5"], [5, "5"]],
                "targets": [[8, "8"], [11, "11"], [13, "13"]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale.")
            },
            {
                "masses": [[2, "2"], [5, "5"], [10, "10"], [10, "10"], [12, "12"]],
                "targets": [[3, "3"], [8, "8"], [13, "13"]],
                "rightDrop": true
            },
            {
                "masses": [[2, "2"], [4, "4"], [7, "7"], [10, "10"], [12, "12"]],
                "targets": [[3, "3"], [5, "5"], [8, "8"], [9, "9"]],
                "rightDrop": true
            },
            {
                "masses": [[5, "5"], [8, "8"], [9, "9"], [10, "10"], [11, "11"], [12, "12"]],
                "targets": [[6, "6"], [7, "7"], [13, "13"], [14, "14"], [15, "15"], [16, "16"],
                           [17, "17"], [18, "18"]],
                "rightDrop": true
            },
            {
                "masses": [[1, "1"], [2, "2"], [2, "2"], [5, "5"], [5, "5"], [10, "10"], [10, "10"]],
                "targets": [[3, "3"], [4, "4"], [6, "6"], [7, "7"], [8, "8"], [9, "9"]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift: %1")
            },
            {
                "masses": [[2, "2"], [2, "2"], [5, "5"], [5, "5"], [5, "5"]],
                "targets": [[8, "8"], [11, "11"], [13, "13"]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale."),
                "question": qsTr("Enter the weight of the gift: %1")
            },
            {
                "masses": [[2, "2"], [5, "5"], [10, "10"], [10, "10"], [12, "12"]],
                "targets": [[3, "3"], [8, "8"], [13, "13"]],
                "rightDrop": true,
                "question": qsTr("Enter the weight of the gift: %1")
            },
            {
                "masses": [[2, "2"], [4, "4"], [7, "7"], [10, "10"], [12, "12"]],
                "targets": [[3, "3"], [5, "5"], [8, "8"], [9, "9"]],
                "rightDrop": true,
                "question": qsTr("Enter the weight of the gift: %1")
            },
            {
                "masses": [[5, "5"], [8, "8"], [9, "9"], [10, "10"], [11, "11"], [12, "12"]],
                "targets": [[6, "6"], [7, "7"], [13, "13"], [14, "14"], [15, "15"], [16, "16"],
                           [17, "17"], [18, "18"]],
                "rightDrop": true,
                "question": qsTr("Enter the weight of the gift: %1")
            },
]



}
