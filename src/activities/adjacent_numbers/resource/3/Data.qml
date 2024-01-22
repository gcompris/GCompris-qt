/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Find numbers between 0 and 100.")
    difficulty: 4
    data: [
        {
            //~ we show two numbers and the third one needs to be found (i.e.: 10, 20, ?)
            "title": qsTr("Find the next number."),
            "lowerBound": 0,
            "upperBound": 80, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [2],

            "numberRandomLevel": 5,
            "fixedLevels": [0, 20, 50, 70, 80, 10, 30, 40, 60], // Defined by the first number of the set
            "numberPropositions": 4
        },
        {
            //~ we show two numbers and the first one needs to be found (i.e.: ?, 10, 20)
            "title": qsTr("Find the previous number."),
            "lowerBound": 0,
            "upperBound": 80, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0],

            "numberRandomLevel": 5,
            "fixedLevels": [10, 30, 20, 0, 80, 60, 50, 70, 40], // Defined by the first number of the set
            "numberPropositions": 4
        },
        {
            //~ we show two numbers and the one in the middle needs to be found (i.e.: 10, ?, 30)
            "title": qsTr("Find the in-between number."),
            "lowerBound": 0,
            "upperBound": 80, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [1],

            "numberRandomLevel": 5,
            "fixedLevels": [70, 40, 60, 50, 20, 10, 0, 50, 80], // Defined by the first number of the set
            "numberPropositions": 4
        },
        {
            //~ we show one number and the first and third need to be found (i.e.: ?, 20, ?)
            "title": qsTr("Find the missing numbers."),
            "lowerBound": 0,
            "upperBound": 80, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0, 2],

            "numberRandomLevel": 5,
            "fixedLevels": [30, 80, 10, 70, 60, 40, 0, 50, 20], // Defined by the first number of the set
            "numberPropositions": 8
        },
        {
            //~ we show two of four numbers and the two last need to be found
            "title": qsTr("Find the next numbers."),
            "lowerBound": 0,
            "upperBound": 97, // inclusive
            "step": 1,
            "numberShown": 4, // Counting the ones to guess
            "indicesToGuess": [2, 3],

            "numberRandomLevel": 5,
            "fixedLevels": [44, 76, 69, 42, 15, 85, 91, 74, 59, 50], // Defined by the first number of the set
            "numberPropositions": 5
        },
        {
            //~ we show two of four numbers and two first need to be found
            "title": qsTr("Find the previous numbers."),
            "lowerBound": 0,
            "upperBound": 97, // inclusive
            "step": 1,
            "numberShown": 4, // Counting the ones to guess
            "indicesToGuess": [0, 1],

            "numberRandomLevel": 5,
            "fixedLevels": [36, 22, 21, 66, 96, 29, 41, 82, 88, 45], // Defined by the first number of the set
            "numberPropositions": 5
        },
        {
            //~ we show two of four numbers, first and last need to be found
            "title": qsTr("Find the missing numbers."),
            "lowerBound": 0,
            "upperBound": 97, // inclusive
            "step": 1,
            "numberShown": 4, // Counting the ones to guess
            "indicesToGuess": [0, 3],

            "numberRandomLevel": 5,
            "fixedLevels": [40, 64, 86, 8, 43, 3, 73, 48, 60, 81], // Defined by the first number of the set
            "numberPropositions": 7
        },
        {
            //~ we show two of four numbers and ones in the middle need to be found
            "title": qsTr("Find the in-between numbers."),
            "lowerBound": 0,
            "upperBound": 97, // inclusive
            "step": 1,
            "numberShown": 4, // Counting the ones to guess
            "indicesToGuess": [1, 2],

            "numberRandomLevel": 5,
            "fixedLevels": [45, 56, 72, 78, 29, 31, 76, 93, 1, 94], // Defined by the first number of the set
            "numberPropositions": 7
        },
    ]
}
