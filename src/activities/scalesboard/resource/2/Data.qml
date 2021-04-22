/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Balance up to %1.").arg(3)
    difficulty: 1
    data: [
        {
            "masses": [[1, "1"], [1, "1"], [3, "3"], [1, "1"], [1, "1"], [1, "1"], [1, "1"]],
            "targets": [[2, "2"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[1, "1"], [1, "1"], [2, "2"], [1, "1"], [1, "1"], [2, "2"], [1, "1"]],
            "targets": [[3, "3"]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[3, "3"], [1, "1"], [1, "1"], [1, "1"], [3, "3"], [1, "1"], [1, "1"]],
            "targets": [[2, "2"]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scales.")
        },
        {
            "masses": [[2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scales.")
        },
        {
            "masses": [[3, "3"], [1, "1"], [1, "1"], [1, "1"], [3, "3"], [1, "1"], [1, "1"]],
            "targets": [[2, "2"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        },
        {
            "masses": [[2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"], [1, "1"], [2, "2"]],
            "targets": [[3, "3"]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift: %1")
        }
    ]
}
