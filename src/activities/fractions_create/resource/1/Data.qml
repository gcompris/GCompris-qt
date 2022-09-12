/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Simplified fractions with a pie.")
    difficulty: 5

    data: [
        [
        {
            "chartType": "pie",
            "numerator": 1,
            "denominator": 2,
            "instruction": qsTr("Select one half of the pie.")
        },
        {
            "chartType": "pie",
            "numerator": 1,
            "denominator": 3,
            "instruction": qsTr("Select one-third of the pie.")
        },
        {
            "chartType": "pie",
            "numerator": 2,
            "denominator": 3,
            "instruction": qsTr("Select two-thirds of the pie.")
        },
        {
            "chartType": "pie",
            "numerator": 1,
            "denominator": 4,
            "instruction": qsTr("Select one-quarter of the pie.")
        },
        {
            "chartType": "pie",
            "numerator": 2,
            "denominator": 5,
            "instruction": qsTr("Select two-fifths of the pie.")
        }
        ],
        [
        {
            "chartType": "pie",
            "numerator": 5,
            "denominator": 4,
            "instruction": qsTr("Select one pie and one-quarter of a pie.")
        },
        {
            "chartType": "pie",
            "numerator": 7,
            "denominator": 5,
            "instruction": qsTr("Select one pie and two-fifths of a pie.")
        },
        {
            "chartType": "pie",
            "numerator": 4,
            "denominator": 3,
            "instruction": qsTr("Select one pie and one-third of a pie.")
        },
        {
            "chartType": "pie",
            "numerator": 9,
            "denominator": 6,
            "instruction": qsTr("Select one pie and one half of a pie.")
        },
        {
            "chartType": "pie",
            "numerator": 14,
            "denominator": 8,
            "instruction": qsTr("Select one pie and three-quarters of a pie.")
        }
        ]
    ]
}
