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
            "randomSubLevels": true,
            "lowerBound": 0,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3,
            "indicesToGuess": [2],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 3
        },
        {
            "randomSubLevels": true,
            "lowerBound": 0,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the one to guess
            "indicesToGuess": [0],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 3
        },
        {
            "randomSubLevels": true,
            "lowerBound": 0,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [1],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 3
        },
        {
            "randomSubLevels": true,
            "lowerBound": 0,
            "upperBound": 8, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0, 2],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 5
        },
    ]
}
