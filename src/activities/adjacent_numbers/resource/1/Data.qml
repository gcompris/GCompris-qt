/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Find numbers between 1 and 10.")
    difficulty: 2
    data: [
        {
            "lowerBound": 0,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3,
            "indicesToGuess": [2],

            "numberRandomLevel": 5,
            "fixedLevels": [1, 6, 3, 7, 5, 2, 4, 8, 0], // Defined by the first number of the set
            "numberPropositions": 3
        },
        {
            "lowerBound": 0,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the one to guess
            "indicesToGuess": [0],

            "numberRandomLevel": 5,
            "fixedLevels": [4, 7, 5, 2, 6, 1, 3, 8, 0], // Defined by the first number of the set
            "numberPropositions": 3
        },
        {
            "lowerBound": 0,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [1],

            "numberRandomLevel": 5,
            "fixedLevels": [4, 2, 7, 6, 3, 1, 0, 8], // Defined by the first number of the set
            "numberPropositions": 3
        },
        {
            "lowerBound": 0,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0, 2],

            "numberRandomLevel": 5,
            "fixedLevels": [3, 6, 4, 7, 2, 1, 0, 5, 8], // Defined by the first number of the set
            "numberPropositions": 5
        },
    ]
}
