/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Balance up to 10 pounds including ounces.")
    difficulty: 4

    function oz(value) {
               /* oz == ounce */
               return qsTr("%1 oz").arg(value)
           }
    readonly property string lb_1: qsTr("%1 lb").arg(1)
    readonly property string lb_2: qsTr("%1 lb").arg(2)
    readonly property string lb_3: qsTr("%1 lb").arg(3)
    readonly property string lb_4: qsTr("%1 lb").arg(4)
    readonly property string lb_5: qsTr("%1 lb").arg(5)
    function lb(value) {
            /* lb == pound */
            return qsTr("%1 lb").arg(value)
        }

    data: [
        {
            "masses": [[1, lb_1], [2, lb_2], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
            "targets": [[3, lb_3], [4, lb_4], [5, lb_5]],
            "rightDrop": false,
            "message": qsTr('The "lb" symbol at the end of a number means pound.' + " " +
                                     'The pound is a unit of mass, a property which corresponds to the ' +
                                          'common perception of how "heavy" an object is. This unit is used in the USA.')


        },
        {
            "masses": [[1, lb_1], [2, lb_2], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
            "targets": [[3, lb_3], [4, lb_4], [5, lb_5], [7, lb(7)], [9, lb(9)], [10, lb(10)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")

        },
        {
            "masses": [[8, oz(8)], [16, lb_1], [16, lb_1], [8, oz(8)], [48, lb_3], [16, lb_1]],
            "targets": [[16, lb_1], [64, lb_4], [32, lb_2],[80, lb_5]],
            "rightDrop": false,
            "message": qsTr('Remember, one pound ("lb") equals sixteen ounces ("oz"). \n Drop the weights on the left side of the scales to balance it.')
        },
        {
            "masses": [[32, oz(32)], [80, lb_5], [16, oz(16)], [64, lb_4], [32, lb_2], [16, lb_1]],
            "targets": [[96, lb(6)], [64, oz(64)], [32, lb_2],[80, oz(80)],[128, lb(8)], [160, lb(10)]],
            "rightDrop": false,
            "message": qsTr('Remember, one pound ("lb") equals sixteen ounces ("oz"). \n Drop the weights on the left side of the scales to balance it.')
        },
        {
            "masses": [[1, lb_1], [2, lb_2], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
            "targets": [[3, lb_3], [4, lb_4], [5, lb_5]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in pound: %1")
        },
        {
            "masses": [[6, oz(6)], [16, lb_1], [32, lb_2], [10, oz(10)], [16, lb_1], [16, lb_1]],
            "targets": [[16, lb_1], [64, lb_4], [32, lb_2],[80, lb_5]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
        {
            "masses": [[1, lb_1], [2, lb_2], [4, lb_4], [1, lb_1], [2, lb_2], [1, lb_1], [3, lb_3]],
            "targets": [[3, lb_3], [4, lb_4], [5, lb_5], [7, lb(7)], [9, lb(9)], [10, lb(10)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in pound: %1")
        },
        {
            "masses": [[32, oz(32)], [80, lb_5], [16, oz(16)], [64, lb_4], [32, lb_2], [16, lb_1]],
            "targets": [[96, lb(6)], [64, lb_4], [32, lb_2],[80, lb_5],[128, lb(8)], [160, lb(10)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        },
    ]
}
