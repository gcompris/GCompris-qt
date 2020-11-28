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
    objective: qsTr("Balance up to 5 ounces.")
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
            "message": qsTr('The "oz" symbol at the end of a number means ounce. One pound equals sixteen ounces. \n Drop weights on the left side to balance the scales.' )
        },
        {
            "masses": [[6, oz(6)], [9, oz(9)], [2, oz(2)], [7, oz(7)], [6, oz(6)], [7, oz(7)], [8, oz(8)]],
            "targets": [[4, oz(4)], [3, oz(3)], [5, oz(5)]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
        },
        {
            "masses": [[1, oz(1)], [1, oz(1)], [2, oz(2)], [1, oz(1)], [2, oz(2)], [1, oz(1)], [2, oz(2)]],
            "targets": [[4, oz(4)], [3, oz(3)], [5, oz(5)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in ounce: %1")
        }
    ]
}
