/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Balance up to 10 pounds including ounces.")
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
            "message": qsTr("Drop weights on the left side to balance the scales.")

        },
        {
            "masses": [[8, oz(8)], [16, lb(1)], [16, lb(1)], [8, oz(8)], [48, lb(3)], [16, lb(1)]],
            "targets": [[16, lb(1)], [64, lb(4)], [32, lb(2)],[80, lb(5)]],
            "rightDrop": false,
            "message": qsTr('Remember, one pound ("lb") equals sixteen ounces ("oz"). \n Drop the weights on the left side of the scales to balance it.')
        },
        {
            "masses": [[32, oz(32)], [80, lb(5)], [16, oz(16)], [64, lb(4)], [32, lb(2)], [16, lb(1)]],
            "targets": [[96, lb(6)], [64, oz(64)], [32, lb(2)],[80, oz(80)],[128, lb(8)], [160, lb(10)]],
            "rightDrop": false,
            "message": qsTr('Remember, one pound ("lb") equals sixteen ounces ("oz"). \n Drop the weights on the left side of the scales to balance it.')
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
