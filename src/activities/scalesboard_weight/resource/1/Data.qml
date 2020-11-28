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
    objective: qsTr("Balance up to 5 grams.")
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
            "message": qsTr('The "g" symbol at the end of a number means gram.')
        },
        {
            "masses": [[6, g(6)], [9, g(9)], [2, g(2)], [7, g(7)], [6, g(6)], [7, g(7)], [8, g(8)]],
            "targets": [[4, g(4)], [3, g(3)], [5, g(5)]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scale."),
        },
        {
            "masses": [[1, g(1)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)]],
            "targets": [[4, g(4)], [3, g(3)], [5, g(5)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in grams: %1")
        }
    ]
}
