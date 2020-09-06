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
    objective: qsTr("Balance up to 5.")
    difficulty: 2
    data: [
        {
            "masses": [[1, "1"], [1, "1"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"], [4, "4"], [5, "5"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[6, "6"], [9, "9"], [2, "2"], [7, "7"], [6, "6"], [7, "7"], [8, "8"]],
            "targets": [[4, "4"], [3, "3"], [5, "5"]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
        },
        {
            "masses": [[1, "1"], [1, "1"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[4, "4"], [3, "3"], [5, "5"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        }
    ]
}
