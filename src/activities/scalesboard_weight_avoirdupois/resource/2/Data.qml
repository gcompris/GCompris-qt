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
    objective: qsTr("Balance up to 10 ounces.")
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
            "masses": [[1, oz(1)], [2, oz(2)], [2, oz(2)], [1, oz(1)], [2, oz(2)], [1, oz(1)], [2, oz(2)]],
            "targets": [[3, oz(3)], [4, oz(4)], [5, oz(5)],[7, oz(7)],[8, oz(8)], [10, oz(10)],[9, oz(9)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[6, oz(6)], [9, oz(9)], [6, oz(6)], [5, oz(5)], [9, oz(9)], [7, oz(7)], [11, oz(11)]],
            "targets": [[3, oz(3)], [8, oz(8)], [7, oz(7)],[10, oz(10)]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
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
