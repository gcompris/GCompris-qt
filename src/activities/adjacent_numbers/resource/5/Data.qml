/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Find numbers between -10 and 10.")
    difficulty: 6
    data: [
        {
            "lowerBound": -10,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [2],

            "numberRandomLevel": 5,
            "fixedLevels": [-9, 7, 2, -4, 6, -10, -1, -8, -7, -2], // Defined by the first number of the set
            "numberPropositions": 5
        },
        {
            "lowerBound": -10,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0],

            "numberRandomLevel": 5,
            "fixedLevels": [4, -6, -7, 7, 0, -3, 2, -10, -9, 8], // Defined by the first number of the set
            "numberPropositions": 5
        },
        {
            "lowerBound": -5,
            "upperBound": 3, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [1],

            "numberRandomLevel": 5,
            "fixedLevels": [-4, 2, 3, -2, 0, -1, 1, -3], // Defined by the first number of the set
            "numberPropositions": 3
        },
        {
            "lowerBound": -10,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 4, // Counting the ones to guess
            "indicesToGuess": [0, 3],

            "numberRandomLevel": 5,
            "fixedLevels": [2, -1, -2, -4, 6, -7, 3, 0, -5], // Defined by the first number of the set
            "numberPropositions": 7
        },
        {
            "lowerBound": -10,
            "upperBound": 6, // inclusive
            "step": 1,
            "numberShown": 5, // Counting the ones to guess
            "indicesToGuess": [1, 2, 3],

            "numberRandomLevel": 5,
            "fixedLevels": [2, -1, -2, -4, 6, -7, 3, 0, -5], // Defined by the first number of the set
            "numberPropositions": 7
        },
    ]
}
