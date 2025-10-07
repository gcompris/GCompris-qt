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
            "randomSubLevels": true,
            "lowerBound": 0,
            "upperBound": 18, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [2],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 5
        },
        {
            "randomSubLevels": true,
            "lowerBound": 0,
            "upperBound": 18, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the one to guess
            "indicesToGuess": [0],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 5
        },
        {
            "randomSubLevels": true,
            "lowerBound": 0,
            "upperBound": 18, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [1],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 5
        },
        {
            "randomSubLevels": true,
            "lowerBound": 0,
            "upperBound": 18, // inclusive
            "step": 1,
            "numberShown": 3, // Counting the ones to guess
            "indicesToGuess": [0, 2],

            "numberRandomLevel": 5,
            "fixedLevels": [],
            "numberPropositions": 7
        }
    ]
}
