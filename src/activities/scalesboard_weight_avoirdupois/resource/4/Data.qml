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
    objective: qsTr("Balance up to 10 pounds.")
    difficulty: 3

    readonly property string lb_1: qsTr("%1 lb").arg(1)
    readonly property string lb_2: qsTr("%1 lb").arg(2)
    readonly property string lb_3: qsTr("%1 lb").arg(3)
    readonly property string lb_5: qsTr("%1 lb").arg(5)
    function lb(value) {
        /* lb == pound */
        return qsTr("%1 lb").arg(value)
    }

    data: [
            {
                "masses": [[1, lb_1], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
                "targets": [[1, lb_1], [2, lb_2], [3, lb_3]],
                "rightDrop": false,
                "message": qsTr('The "lb" symbol at the end of a number means pound.' + " " +
                                       'The pound is a unit of mass, a property which corresponds to the ' +
                                            'common perception of how "heavy" an object is. This unit is used in the USA.')
            },
            {
                "masses": [[1, lb_1], [2, lb_2], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
                "targets": [[2, lb_2], [4, lb(4)], [5, lb_5],[1, lb_1]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scales.")
            },
            {
                "masses": [[1, lb_1], [2, lb_2], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
                "targets": [[3, lb_3], [4, lb(4)], [5, lb_5],[7, lb(7)],[2, lb_2]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scales.")
            },
            {
                "masses": [[1, lb_1], [2, lb_2], [3, lb_3], [5, lb_5], [2, lb_2], [4, lb(4)], [2, lb_2]],
                "targets": [[3, lb_3], [4, lb(4)], [5, lb_5],[7, lb(7)],[8, lb(8)], [10, lb(10)],[9, lb(9)]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scales.")
            },
            {
                "masses": [[5, lb_5], [7, lb(7)], [9, lb(9)], [6, lb(6)], [5, lb_5], [4, lb(4)], [7, lb(7)]],
                "targets": [[2, lb_2], [3, lb_3],[1, lb_1]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scales."),

            },
            {
                "masses": [[5, lb_5], [7, lb(7)], [9, lb(9)], [6, lb(6)], [5, lb_5], [6, lb(6)], [7, lb(7)]],
                "targets": [[4, lb(4)], [3, lb_3],[5, lb_5]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scales."),

            },
            {
                "masses": [[8, lb(8)], [11, lb(11)], [9, lb(9)], [10, lb(10)], [12, lb(12)], [4, lb(4)], [9, lb(9)]],
                "targets": [[2, lb_2], [6, lb(6)],[7, lb(7)],[5, lb_5]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scales."),

            },
            {
                "masses": [[6, lb(6)], [9, lb(9)], [6, lb(6)], [5, lb_5], [9, lb(9)], [7, lb(7)], [11, lb(11)]],
                "targets": [[3, lb_3], [8, lb(8)], [7, lb(7)],[10, lb(10)]],
                "message": qsTr("Take care, you can drop weights on both sides of the scales."),
                "rightDrop": true
            },
            {
                "masses": [[1, lb_1], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
                "targets": [[1, lb_1], [2, lb_2], [3, lb_3]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in pound: %1")
            },
            {
                "masses": [[1, lb_1], [2, lb_2], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
                "targets": [[3, lb_3], [5, lb_5], [7, lb(7)], [2, lb_2]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in pound: %1")
            },
            {
                "masses": [[1, lb_1], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2], [1, lb_1], [2, lb_2]],
                "targets": [[4, lb(4)], [1, lb_1], [5, lb_5]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in pound: %1")
            },
            {
                "masses": [[1, lb_1], [8, lb(8)], [2, lb_2], [2, lb_2], [7, lb(7)], [9, lb(9)], [6, lb(6)]],
                "targets": [[4, lb(4)], [7, lb(7)], [10, lb(10)],[5, lb_5], [6, lb(6)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in pound: %1")
            }
        ]
    }
