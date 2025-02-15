/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Find numbers between 0 and 20.")
    difficulty: 3
    data: [
        {
            //~ we show two numbers and the third one needs to be found
            "title": qsTr("Find the next number."),
            "lowerBound": 0,
            "upperBound": 18, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [2],

            "numberRandomLevel": 5,
            "fixedLevels": [10, 8, 6, 13, 5, 16, 7, 11, 4, 1], // Defined by the first number of the set
            "numberPropositions": 5
        },
        {
            //~ we show two of three numbers and the first one needs to be found
            "title": qsTr("Find the previous number."),
            "lowerBound": 0,
            "upperBound": 18, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the one to guess
            "indicesToGuess": [0],

            "numberRandomLevel": 5,
            "fixedLevels": [7, 11, 16, 2, 9, 14, 10, 6, 17], // Defined by the first number of the set
            "numberPropositions": 5
        },
        {
            //~ we show two of three numbers and the one in the middle needs to be found
            "title": qsTr("Find the in-between number."),
            "lowerBound": 0,
            "upperBound": 18, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [1],

            "numberRandomLevel": 5,
            "fixedLevels": [17, 10, 8, 6, 12, 3, 0, 15], // Defined by the first number of the set
            "numberPropositions": 5
        },
        {
            //~ we show one of three numbers and first and third need to be found
            "title": qsTr("Find the missing numbers."),
            "lowerBound": 0,
            "upperBound": 18, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0, 2],

            "numberRandomLevel": 5,
            "fixedLevels": [15, 1, 8, 13, 10, 8, 5, 14, 3], // Defined by the first number of the set
            "numberPropositions": 7
        }
    ]
}
