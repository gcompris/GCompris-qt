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
    objective: qsTr("Balance up to %1.").arg(10)
    difficulty: 3
    data: [
        {
            "masses": [[1, "1"], [1, "1"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"], [4, "4"], [5, "5"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[1, "1"], [2, "2"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"], [4, "4"], [5, "5"],[7,"7"],[8,"8"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[3, "3"], [1, "1"], [2, "2"], [3, "3"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[4, "4"], [5, "5"],[7,"7"],[8,"8"],[10,"10"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[6, "6"], [7, "7"], [3, "3"], [7, "7"], [6, "6"], [7, "7"], [9, "9"]],
            "targets": [[4, "4"], [8,"8"], [5, "5"]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scales.")
        },
        {
            "masses": [[6, "6"], [9, "9"], [6, "6"], [5, "5"], [9, "9"], [7, "7"], [11, "11"]],
            "targets": [[3, "3"], [8, "8"], [7,"7"],[10,"10"]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[1, "1"], [3, "3"], [2, "2"], [5, "5"], [7, "7"], [1, "1"], [2, "2"]],
            "targets": [[4, "4"], [7, "7"], [10, "10"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[1, "1"], [8, "8"], [2, "2"], [2, "2"], [7, "7"], [9, "9"], [6, "6"]],
            "targets": [[4, "4"], [7, "7"], [10, "10"],[5,"5"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        }
    ]
}
