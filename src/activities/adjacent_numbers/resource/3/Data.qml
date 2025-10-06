/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Find numbers between 0 and 100.")
    difficulty: 4
    data: [
        {
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
