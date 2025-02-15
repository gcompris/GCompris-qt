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
    objective: qsTr("Balance up to 10 kilograms.")
    difficulty: 3

    readonly property string kg_1: qsTr("%1 kg").arg(1)
    readonly property string kg_2: qsTr("%1 kg").arg(2)
    readonly property string kg_3: qsTr("%1 kg").arg(3)
    readonly property string kg_5: qsTr("%1 kg").arg(5)
    function kg(value) {
           /* kg == kilogram */
           return qsTr("%1 kg").arg(value)
       }

    data: [
        {
            "masses": [[1, kg_1], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2]],
            "targets": [[1, kg_1], [2, kg_2], [3, kg_3]],
            "rightDrop": false,
            "message": qsTr('The "kg" symbol at the end of a number means kilogram.') + " " +
                                       qsTr('The kilogram is a unit of mass, a property which corresponds to the ' +
                                            'common perception of how "heavy" an object is. \n Drop weights on the left side to balance the scales.')
        },
        {
            "masses": [[1, kg_1], [2, kg_2], [2, kg_2], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2]],
            "targets": [[2, kg_2], [4, kg(4)], [5, kg_5],[1, kg_1]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[1, kg_1], [2, kg_2], [2, kg_2], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2]],
            "targets": [[3, kg_3], [4, kg(4)], [5, kg_5],[7, kg(7)],[2, kg_2]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[1, kg_1], [2, kg_2], [3, kg_3], [5, kg_5], [2, kg_2], [4, kg(4)], [2, kg_2]],
            "targets": [[3, kg_3], [4, kg(4)], [5, kg_5],[7, kg(7)],[8, kg(8)], [10, kg(10)],[9, kg(9)]],
            "rightDrop": false,
            "message": qsTr("Drop weights on the left side to balance the scales.")
        },
        {
            "masses": [[5, kg_5], [7, kg(7)], [9, kg(9)], [6, kg(6)], [5, kg_5], [4, kg(4)], [7, kg(7)]],
            "targets": [[2, kg_2], [3, kg_3],[1, kg_1]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),

        },
        {
            "masses": [[5, kg_5], [7, kg(7)], [9, kg(9)], [6, kg(6)], [5, kg_5], [6, kg(6)], [7, kg(7)]],
            "targets": [[4, kg(4)], [3, kg_3],[5, kg_5]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),

        },
        {
            "masses": [[8, kg(8)], [11, kg(11)], [9, kg(9)], [10, kg(10)], [12, kg(12)], [4, kg(4)], [9, kg(9)]],
            "targets": [[2, kg_2], [6, kg(6)],[7, kg(7)],[5, kg_5]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),

        },
        {
            "masses": [[6, kg(6)], [9, kg(9)], [6, kg(6)], [5, kg_5], [9, kg(9)], [7, kg(7)], [11, kg(11)]],
            "targets": [[3, kg_3], [8, kg(8)], [7, kg(7)],[10, kg(10)]],
            "message": qsTr("Take care, you can drop weights on both sides of the scales."),
            "rightDrop": true
        },
        {
            "masses": [[1, kg_1], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2]],
            "targets": [[1, kg_1], [2, kg_2], [3, kg_3]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in kilogram: %1")
        },
        {
            "masses": [[1, kg_1], [2, kg_2], [2, kg_2], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2]],
            "targets": [[3, kg_3], [5, kg_5], [7, kg(7)], [2, kg_2]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in kilogram: %1")
        },
        {
            "masses": [[1, kg_1], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2], [1, kg_1], [2, kg_2]],
            "targets": [[4, kg(4)], [1, kg_1], [5, kg_5]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in kilogram: %1")
        },
        {
            "masses": [[1, kg_1], [8, kg(8)], [2, kg_2], [2, kg_2], [7, kg(7)], [9, kg(9)], [6, kg(6)]],
            "targets": [[4, kg(4)], [7, kg(7)], [10, kg(10)],[5, kg_5], [6, kg(6)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in kilogram: %1")
        }
    ]
}
