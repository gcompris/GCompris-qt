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
    objective: qsTr("Balance the scales until 10 pounds.")
    difficulty: 3

    function lb(value) {
        /* lb == pound */
        return qsTr("%1 lb").arg(value)
    }

    data: [
            {
                "masses": [[1, lb(1)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
                "targets": [[1, lb(1)], [2, lb(2)], [3, lb(3)]],
                "rightDrop": false,
                "message": qsTr('The "lb" symbol at the end of a number means pound.' + " " +
                                       'The pound is a unit of mass, a property which corresponds to the ' +
                                            'common perception of how "heavy" an object is. This unit is used in the USA.')
            },
            {
                "masses": [[1, lb(1)], [2, lb(2)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
                "targets": [[2, lb(2)], [4, lb(4)], [5, lb(5)],[1, lb(1)]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scale.")
            },
            {
                "masses": [[1, lb(1)], [2, lb(2)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
                "targets": [[3, lb(3)], [4, lb(4)], [5, lb(5)],[7, lb(7)],[2, lb(2)]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scale.")
            },
            {
                "masses": [[1, lb(1)], [2, lb(2)], [3, lb(3)], [5, lb(5)], [2, lb(2)], [4, lb(4)], [2, lb(2)]],
                "targets": [[3, lb(3)], [4, lb(4)], [5, lb(5)],[7, lb(7)],[8, lb(8)], [10, lb(10)],[9, lb(9)]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scale.")
            },
            {
                "masses": [[5, lb(5)], [7, lb(7)], [9, lb(9)], [6, lb(6)], [5, lb(5)], [4, lb(4)], [7, lb(7)]],
                "targets": [[2, lb(2)], [3, lb(3)],[1, lb(1)]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale."),

            },
            {
                "masses": [[5, lb(5)], [7, lb(7)], [9, lb(9)], [6, lb(6)], [5, lb(5)], [6, lb(6)], [7, lb(7)]],
                "targets": [[4, lb(4)], [3, lb(3)],[5, lb(5)]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale."),

            },
            {
                "masses": [[8, lb(8)], [11, lb(11)], [9, lb(9)], [10, lb(10)], [12, lb(12)], [4, lb(4)], [9, lb(9)]],
                "targets": [[2, lb(2)], [6, lb(6)],[7, lb(7)],[5, lb(5)]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale."),

            },
            {
                "masses": [[6, lb(6)], [9, lb(9)], [6, lb(6)], [5, lb(5)], [9, lb(9)], [7, lb(7)], [11, lb(11)]],
                "targets": [[3, lb(3)], [8, lb(8)], [7, lb(7)],[10, lb(10)]],
                "message": qsTr("Take care, you can drop weights on both sides of the scale."),
                "rightDrop": true
            },
            {
                "masses": [[1, lb(1)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
                "targets": [[1, lb(1)], [2, lb(2)], [3, lb(3)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in pound: %1")
            },
            {
                "masses": [[1, lb(1)], [2, lb(2)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
                "targets": [[3, lb(3)], [5, lb(5)], [7, lb(7)], [2, lb(2)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in pound: %1")
            },
            {
                "masses": [[1, lb(1)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
                "targets": [[4, lb(4)], [1, lb(1)], [5, lb(5)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in pound: %1")
            },
            {
                "masses": [[1, lb(1)], [8, lb(8)], [2, lb(2)], [2, lb(2)], [7, lb(7)], [9, lb(9)], [6, lb(6)]],
                "targets": [[4, lb(4)], [7, lb(7)], [10, lb(10)],[5, lb(5)], [6, lb(6)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in pound: %1")
            }
        ]
    }
