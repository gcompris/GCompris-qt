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
    objective: qsTr("Balance up to 10 kilograms including grams.")
    difficulty: 4

    function g(value) {
           /* g == gram */
           return qsTr("%1 g").arg(value)
       }

    function kg(value) {
           /* kg == kilogram */
           return qsTr("%1 kg").arg(value)
       }

        data: [

            {
                "masses": [[1, kg(1)], [1, kg(1)], [2, kg(2)], [1, kg(1)], [2, kg(2)], [1, kg(1)], [2, kg(2)]],
                "targets": [[1, kg(1)], [2, kg(2)], [3, kg(3)], [5, kg(5)]],
                "rightDrop": false,
                "message": qsTr('The "kg" symbol at the end of a number means kilogram.' + " " + 'The kilogram is a unit of mass, a property which corresponds to the ' + 'common perception of how "heavy" an object is. \n Drop weights on the left side to balance the scales.')
            },
            {
                "masses": [[1, kg(1)], [2, kg(2)], [3, kg(3)], [5, kg(5)], [2, kg(2)], [4, kg(4)], [2, kg(2)]],
                "targets": [[3, kg(3)], [4, kg(4)], [5, kg(5)],[7, kg(7)],[8, kg(8)], [10, kg(10)],[9, kg(9)]],
                "rightDrop": false,
                "message": qsTr("Drop weights on the left side to balance the scales.")
            },
            {
                "masses": [[100, g(100)], [200, g(200)], [200, g(200)], [2000, kg(2)],[500, g(500)], [1000, kg(1)], [1000, kg(1)]],
                "targets": [[2200, kg(2.2)], [1300, kg(1.3)], [2400, kg(2.4)],[3500, kg(3.5)], [1600, kg(1.6)]],
                "rightDrop": false,
                "message": qsTr('Remember, one kilogram ("kg") equals 1000 grams ("g"). \n Drop weights on the left side to balance the scales.')
            },
            {
                "masses": [[5000, kg(5)], [2000, kg(2)], [200, g(200)], [500, g(500)],[400, g(400)], [1000, kg(1)], [1000, kg(1)]],
                "targets": [[5200, kg(5.2)], [7200, kg(7.2)], [9400, kg(9.4)],[5500, kg(5.5)], [8900, kg(8.9)]],
                "rightDrop": false,
                "message": qsTr('Remember, one kilogram ("kg") equals 1000 grams ("g"). \n Drop weights on the left side to balance the scales.')
            },
            {
                "masses": [[1, kg(1)], [1, kg(1)], [2, kg(2)], [1, kg(1)], [2, kg(2)], [1, kg(1)], [2, kg(2)]],
                "targets": [[4, kg(4)], [1, kg(1)], [5, kg(5)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in kilogram: %1")
            },
            {
                "masses": [[1, kg(1)], [8, kg(8)], [2, kg(2)], [2, kg(2)], [7, kg(7)], [9, kg(9)], [6, kg(6)]],
                "targets": [[4, kg(4)], [7, kg(7)], [10, kg(10)],[5, kg(5)], [6, kg(6)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in kilogram: %1")
            },
            {
                "masses": [[100, g(100)], [200, g(200)], [200, g(200)], [2000, kg(2)],[500, g(500)], [1000, kg(1)], [1000, kg(1)]],
                "targets": [[2200, kg(2.2)], [1300, kg(1.3)], [2400, kg(2.4)],[3500, kg(3.5)], [1600, kg(1.6)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[5000, kg(5)], [2000, kg(2)], [200, g(200)], [500, g(500)],[400, g(400)], [1000, kg(1)], [1000, kg(1)]],
                "targets": [[5200, kg(5.2)], [7200, kg(7.2)], [9400, kg(9.4)],[5500, kg(5.5)], [8900, kg(8.9)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },

        ]
}
