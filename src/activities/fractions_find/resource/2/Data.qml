/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

/**
 Note: to have a specified numerator and denominator, use:
        {
            "chartType": "rectangle",
            "numerator": 1,
            "denominator": 2,
            "fixedNumerator": false,
            "fixedDenominator": true
        },
*/
Data {
    objective: qsTr("Find numerator (with a square).")
    difficulty: 5

    data: [
        [
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 1,
            "random": true
        },
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 1,
            "random": true
        },
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 1,
            "random": true
        },
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 1,
            "random": true
        },
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 1,
            "random": true
        }
        ],
        [
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 2,
            "random": true
        },
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 2,
            "random": true
        },
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 2,
            "random": true
        },
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 2,
            "random": true
        },
        {
            "chartType": "rectangle",
            "fixedNumerator": false,
            "fixedDenominator": true,
            "maxFractions": 2,
            "random": true
        }
        ]
    ]
}
