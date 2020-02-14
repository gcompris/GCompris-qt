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
    objective: qsTr("Balance the scales until 10 ounces.")
    difficulty: 2

    function oz(value) {
           /* oz == ounce */
           return qsTr("%1 oz").arg(value)
       }

    data: [
        {
            "masses": [[1, oz(1)], [1, oz(1)], [2, oz(2)], [1, oz(1)], [2, oz(2)], [1, oz(1)], [2, oz(2)]],
            "targets": [[3, oz(3)], [4, oz(4)], [5, oz(5)]],
            "rightDrop": false,
            "message": qsTr('The "oz" symbol at the end of a number means ounce. One pound equals sixteen ounces. \n Drop weights on the left side to balance the scale.' )
        },
        {
            "masses": [[1, oz(1)], [2, oz(2)], [2, oz(2)], [1, oz(1)], [2, oz(2)], [1, oz(1)], [2, oz(2)]],
            "targets": [[3, oz(3)], [4, oz(4)], [5, oz(5)],[7, oz(7)],[8, oz(8)], [10, oz(10)],[9, oz(9)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")
        },
        {
            "masses": [[6, oz(6)], [9, oz(9)], [6, oz(6)], [5, oz(5)], [9, oz(9)], [7, oz(7)], [11, oz(11)]],
            "targets": [[3, oz(3)], [8, oz(8)], [7, oz(7)],[10, oz(10)]],
            "message": qsTr("Take care, you can drop weights on both sides of the scale."),
            "rightDrop": true
        },
        {
            "masses": [[1, oz(1)], [1, oz(1)], [2, oz(2)], [1, oz(1)], [2, oz(2)], [1, oz(1)], [2, oz(2)]],
            "targets": [[4, oz(4)], [1, oz(1)], [5, oz(5)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
        {
            "masses": [[1, oz(1)], [8, oz(8)], [2, oz(2)], [2, oz(2)], [7, oz(7)], [9, oz(9)], [6, oz(6)]],
            "targets": [[4, oz(4)], [7, oz(7)], [10, oz(10)],[5, oz(5)], [6, oz(6)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        }
    ]
}
