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
    objective: qsTr("Balance the scales until 10 pound including ounces.")
    difficulty: 4

    function oz(value) {
               /* oz == ounce */
               return qsTr("%1 oz").arg(value)
           }

    function lb(value) {
            /* lb == pound */
            return qsTr("%1 lb").arg(value)
        }

    data: [
        {
            "masses": [[1, lb(1)], [2, lb(2)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
            "targets": [[3, lb(3)], [4, lb(4)], [5, lb(5)]],
            "rightDrop": false,
            "message": qsTr('The "lb" symbol at the end of a number means pound.' + " " +
                                     'The pound is a unit of mass, a property which corresponds to the ' +
                                          'common perception of how "heavy" an object is. This unit is used in the USA.')


        },
        {
            "masses": [[1, lb(1)], [2, lb(2)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
            "targets": [[3, lb(3)], [4, lb(4)], [5, lb(5)], [7, lb(7)], [9, lb(9)], [10, lb(10)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scale.")

        },
        {
            "masses": [[8, oz(8)], [16, lb(1)], [16, lb(1)], [8, oz(8)], [48, lb(3)], [16, lb(1)]],
            "targets": [[16, lb(1)], [64, lb(4)], [32, lb(2)],[80, lb(5)]],
            "rightDrop": false,
            "message": qsTr('Remember, one pound ("lb") equals sixteen ounces ("oz"). \n Drop the weights on the left side of the scale to balance the scale.')
        },
        {
            "masses": [[32, oz(32)], [80, lb(5)], [16, oz(16)], [64, lb(4)], [32, lb(2)], [16, lb(1)]],
            "targets": [[96, lb(6)], [64, oz(64)], [32, lb(2)],[80, oz(80)],[128, lb(8)], [160, lb(10)]],
            "rightDrop": false,
            "message": qsTr('Remember, one pound ("lb") equals sixteen ounces ("oz"). \n Drop the weights on the left side of the scale to balance the scale.')
        },
        {
            "masses": [[1, lb(1)], [2, lb(2)], [2, lb(2)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [2, lb(2)]],
            "targets": [[3, lb(3)], [4, lb(4)], [5, lb(5)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in pound: %1")
        },
        {
            "masses": [[6, oz(6)], [16, lb(1)], [32, lb(2)], [10, oz(10)], [16, lb(1)], [16, lb(1)]],
            "targets": [[16, lb(1)], [64, lb(4)], [32, lb(2)],[80, lb(5)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
        {
            "masses": [[1, lb(1)], [2, lb(2)], [4, lb(4)], [1, lb(1)], [2, lb(2)], [1, lb(1)], [3, lb(3)]],
            "targets": [[3, lb(3)], [4, lb(4)], [5, lb(5)], [7, lb(7)], [9, lb(9)], [10, lb(10)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in pound: %1")
        },
        {
            "masses": [[32, oz(32)], [80, lb(5)], [16, oz(16)], [64, lb(4)], [32, lb(2)], [16, lb(1)]],
            "targets": [[96, lb(6)], [64, lb(4)], [32, lb(2)],[80, lb(5)],[128, lb(8)], [160, lb(10)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
    ]
}
