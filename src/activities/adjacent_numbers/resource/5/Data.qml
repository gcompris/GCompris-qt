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
            "randomSubLevels": true,
            "lowerBound": -10,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [2],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 5
        },
        {
            "randomSubLevels": true,
            "lowerBound": -10,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 5
        },
        {
            "randomSubLevels": true,
            "lowerBound": -5,
            "upperBound": 3, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [1],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 3
        },
        {
            "randomSubLevels": true,
            "lowerBound": -10,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 4, // Counting the ones to guess
            "indicesToGuess": [0, 3],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 7
        },
        {
            "randomSubLevels": true,
            "lowerBound": -10,
            "upperBound": 6, // inclusive
            "step": 1,
            "numberShown": 5, // Counting the ones to guess
            "indicesToGuess": [1, 2, 3],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 7
        },
    ]
}
