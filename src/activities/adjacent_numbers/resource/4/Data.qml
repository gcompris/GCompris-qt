/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Find numbers between -10 and -1.")
    difficulty: 6
    data: [
        {
            "lowerBound": -10,
            "upperBound": -3, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the one to guess
            "indicesToGuess": [2],

            "numberRandomLevel": 5,
            "fixedLevels": [-4, -7, -5, -10, -6, -8, -3], // Defined by the first number of the set
            "numberPropositions": 3
        },
        {
            "lowerBound": -10,
            "upperBound": -3, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0],

            "numberRandomLevel": 5,
            "fixedLevels": [-3, -5, -4, -6, -9, -8, -7], // Defined by the first number of the set
            "numberPropositions": 3
        },
        {
            "lowerBound": -10,
            "upperBound": -3, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [1],

            "numberRandomLevel": 5,
            "fixedLevels": [-6, -4, -8, -9, -5, -10, -3, -7], // Defined by the first number of the set
            "numberPropositions": 3
        },
        {
            "lowerBound": -10,
            "upperBound": -3, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0, 2],

            "numberRandomLevel": 5,
            "fixedLevels": [-3, -6, -4, -7, -10, -5, -8], // Defined by the first number of the set
            "numberPropositions": 5
        },
    ]
}
