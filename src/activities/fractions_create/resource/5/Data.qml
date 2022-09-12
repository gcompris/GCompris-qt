/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Decimal numbers with a pie.")
    difficulty: 5

    data: [
        [
        {
            "chartType": "pie",
            "numerator": 1,
            "denominator": 2,
            "instruction": qsTr("Select 0.5 pie.")
        },
        {
            "chartType": "pie",
            "numerator": 1,
            "denominator": 4,
            "instruction": qsTr("Select 0.25 pie.")
        },
        {
            "chartType": "pie",
            "numerator": 2,
            "denominator": 5,
            "instruction": qsTr("Select 0.4 pie.")
        },
        {
            "chartType": "pie",
            "numerator": 3,
            "denominator": 4,
            "instruction": qsTr("Select 0.75 pie.")
        },
        {
            "chartType": "pie",
            "numerator": 4,
            "denominator": 5,
            "instruction": qsTr("Select 0.8 pie.")
        }
        ],
        [
        {
            "chartType": "pie",
            "numerator": 5,
            "denominator": 4,
            "instruction": qsTr("Select 1.25 pies.")
        },
        {
            "chartType": "pie",
            "numerator": 7,
            "denominator": 5,
            "instruction": qsTr("Select 1.4 pies.")
        },
        {
            "chartType": "pie",
            "numerator": 3,
            "denominator": 2,
            "instruction": qsTr("Select 1.5 pies.")
        },
        {
            "chartType": "pie",
            "numerator": 9,
            "denominator": 6,
            "instruction": qsTr("Select 1.5 pies.")
        },
        {
            "chartType": "pie",
            "numerator": 14,
            "denominator": 8,
            "instruction": qsTr("Select 1.75 pies.")
        }
        ]
    ]
}
