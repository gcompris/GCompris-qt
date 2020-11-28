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
    objective: qsTr("Balance up to 10 grams.")
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
            "message": qsTr('The "g" symbol at the end of a number means gram. \n Drop weights on the left side to balance the scales.')
        },
        {
            "masses": [[1, g(1)], [2, g(2)], [2, g(2)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)]],
            "targets": [[3, g(3)], [4, g(4)], [5, g(5)],[7,g(7)],[8,g(8)], [10,g(10)],[9,g(9)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[6, g(6)], [9, g(9)], [6, g(6)], [5, g(5)], [9, g(9)], [7, g(7)], [11, g(11)]],
            "targets": [[3, g(3)], [8, g(8)], [7, g(7)],[10, g(10)]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
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
