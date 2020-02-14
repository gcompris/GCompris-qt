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
import "../../../../core"

Dataset {
    objective: qsTr("Balance the scales until 10 grams.")
    difficulty: 2

    function g(value) {
        /* g == gram */
        return qsTr("%1 g").arg(value)
    }

    data: [
        {
            "masses": [[1, g(1)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)]],
            "targets": [[3, g(3)], [4, g(4)], [5, g(5)]],
            "rightDrop": false,
            "message": qsTr('The "g" symbol at the end of a number means gram. \n Drop weights on the left side to balance the scale.')
        },
        {
            "masses": [[1, g(1)], [2, g(2)], [2, g(2)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)]],
            "targets": [[3, g(3)], [4, g(4)], [5, g(5)],[7,g(7)],[8,g(8)], [10,g(10)],[9,g(9)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")
        },
        {
            "masses": [[6, g(6)], [9, g(9)], [6, g(6)], [5, g(5)], [9, g(9)], [7, g(7)], [11, g(11)]],
            "targets": [[3, g(3)], [8, g(8)], [7, g(7)],[10, g(10)]],
            "message": qsTr("Take care, you can drop weights on both sides of the scale."),
            "rightDrop": true
        },
        {
            "masses": [[1, g(1)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)]],
            "targets": [[4, g(4)], [1, g(1)], [5, g(5)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in gram: %1")
        },
        {
            "masses": [[1, g(1)], [8, g(8)], [2, g(2)], [2, g(2)], [7, g(7)], [9, g(9)], [6, g(6)]],
            "targets": [[4, g(4)], [7, g(7)], [10, g(10)],[5, g(5)], [6, g(6)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in gram: %1")
        }
    ]
}
