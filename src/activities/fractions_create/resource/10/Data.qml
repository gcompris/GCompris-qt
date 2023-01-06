/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Specific questions with a square.")
    difficulty: 5

    data: [
        [
        {
            "chartType": "rectangle",
            "numerator": 2,
            "denominator": 5,
            "instruction": qsTr("Select as many parts as you can without taking more than half of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 3,
            "denominator": 7,
            "instruction": qsTr("Select as many parts as you can without taking more than half of the square.")
        }
        ]
    ]
}
