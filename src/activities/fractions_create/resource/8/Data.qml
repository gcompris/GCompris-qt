/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Percentages with a rectangle.")
    difficulty: 5

    data: [
        [
        {
            "chartType": "rectangle",
            "numerator": 1,
            "denominator": 2,
            //: Select %1 percent of the rectangle.
            "instruction": qsTr("Select %1% of the rectangle.").arg(50)
        },
        {
            "chartType": "rectangle",
            "numerator": 3,
            "denominator": 10,
            //: Select %1 percent of the rectangle.
            "instruction": qsTr("Select %1% of the rectangle.").arg(30)
        },
        {
            "chartType": "rectangle",
            "numerator": 9,
            "denominator": 12,
            //: Select %1 percent of the rectangle.
            "instruction": qsTr("Select %1% of the rectangle.").arg(75)
        }
        ],
        [
        {
            "chartType": "rectangle",
            "numerator": 5,
            "denominator": 4,
            //: Select %1 percent of the rectangle.
            "instruction": qsTr("Select %1% of the rectangle.").arg(125)
        },
        {
            "chartType": "rectangle",
            "numerator": 3,
            "denominator": 2,
            //: Select %1 percent of the rectangle.
            "instruction": qsTr("Select %1% of the rectangle.").arg(150)
        },
        {
            "chartType": "rectangle",
            "numerator": 17,
            "denominator": 10,
            //: Select %1 percent of the rectangle.
            "instruction": qsTr("Select %1% of the rectangle.").arg(170)
        }
        ]
    ]
}
