/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Simplified fractions with a rectangle.")
    difficulty: 5

    data: [
        [
        {
            "chartType": "rectangle",
            "numerator": 1,
            "denominator": 2,
            "instruction": qsTr("Select one half of the rectangle.")
        },
        {
            "chartType": "rectangle",
            "numerator": 1,
            "denominator": 3,
            "instruction": qsTr("Select one-third of the rectangle.")
        },
        {
            "chartType": "rectangle",
            "numerator": 2,
            "denominator": 3,
            "instruction": qsTr("Select two-thirds of the rectangle.")
        },
        {
            "chartType": "rectangle",
            "numerator": 1,
            "denominator": 4,
            "instruction": qsTr("Select one-quarter of the rectangle.")
        },
        {
            "chartType": "rectangle",
            "numerator": 2,
            "denominator": 5,
            "instruction": qsTr("Select two-fifths of the rectangle.")
        }
        ],
        [
        {
            "chartType": "rectangle",
            "numerator": 5,
            "denominator": 4,
            "instruction": qsTr("Select one rectangle and one-quarter of a rectangle.")
        },
        {
            "chartType": "rectangle",
            "numerator": 7,
            "denominator": 5,
            "instruction": qsTr("Select one rectangle and two-fifths of a rectangle.")
        },
        {
            "chartType": "rectangle",
            "numerator": 4,
            "denominator": 3,
            "instruction": qsTr("Select one rectangle and one-third of a rectangle.")
        },
        {
            "chartType": "rectangle",
            "numerator": 9,
            "denominator": 6,
            "instruction": qsTr("Select one rectangle and one half of a rectangle.")
        },
        {
            "chartType": "rectangle",
            "numerator": 14,
            "denominator": 8,
            "instruction": qsTr("Select one rectangle and three-quarters of a rectangle.")
        }
        ]
    ]
}
