/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Decimal numbers with a square.")
    difficulty: 5

    data: [
        [
        {
            "chartType": "rectangle",
            "numerator": 1,
            "denominator": 2,
            "instruction": qsTr("Select 0.5 square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 1,
            "denominator": 4,
            "instruction": qsTr("Select 0.25 square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 2,
            "denominator": 5,
            "instruction": qsTr("Select 0.4 square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 3,
            "denominator": 4,
            "instruction": qsTr("Select 0.75 square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 4,
            "denominator": 5,
            "instruction": qsTr("Select 0.8 square.")
        }
        ],
        [
        {
            "chartType": "rectangle",
            "numerator": 5,
            "denominator": 4,
            "instruction": qsTr("Select 1.25 squares.")
        },
        {
            "chartType": "rectangle",
            "numerator": 7,
            "denominator": 5,
            "instruction": qsTr("Select 1.4 squares.")
        },
        {
            "chartType": "rectangle",
            "numerator": 3,
            "denominator": 2,
            "instruction": qsTr("Select 1.5 squares.")
        },
        {
            "chartType": "rectangle",
            "numerator": 9,
            "denominator": 6,
            "instruction": qsTr("Select 1.5 squares.")
        },
        {
            "chartType": "rectangle",
            "numerator": 14,
            "denominator": 8,
            "instruction": qsTr("Select 1.75 squares.")
        }
        ]
    ]
}
