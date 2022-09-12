/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Percentages with a pie.")
    difficulty: 5

    data: [
        [
        {
            "chartType": "pie",
            "numerator": 1,
            "denominator": 4,
            //: Select %1 percent of the pie.
            "instruction": qsTr("Select %1% of the pie.").arg(25)
        },
        {
            "chartType": "pie",
            "numerator": 3,
            "denominator": 10,
            //: Select %1 percent of the pie.
            "instruction": qsTr("Select %1% of the pie.").arg(30)
        },
        {
            "chartType": "pie",
            "numerator": 1,
            "denominator": 2,
            //: Select %1 percent of the pie.
            "instruction": qsTr("Select %1% of the pie.").arg(50)
        },
        {
            "chartType": "pie",
            "numerator": 3,
            "denominator": 5,
            //: Select %1 percent of the pie.
            "instruction": qsTr("Select %1% of the pie.").arg(60)
        },
        {
            "chartType": "pie",
            "numerator": 9,
            "denominator": 12,
            //: Select %1 percent of the pie.
            "instruction": qsTr("Select %1% of the pie.").arg(75)
        }
        ],
        [
        {
            "chartType": "pie",
            "numerator": 5,
            "denominator": 4,
            //: Select %1 percent of the pie.
            "instruction": qsTr("Select %1% of the pie.").arg(125)
        },
        {
            "chartType": "pie",
            "numerator": 3,
            "denominator": 2,
            //: Select %1 percent of the pie.
            "instruction": qsTr("Select %1% of the pie.").arg(150)
        },
        {
            "chartType": "pie",
            "numerator": 17,
            "denominator": 10,
            //: Select %1 percent of the pie.
            "instruction": qsTr("Select %1% of the pie.").arg(170)
        }
        ]
    ]
}
