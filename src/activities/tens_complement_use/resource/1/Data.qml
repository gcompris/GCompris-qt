/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

/**
Global rule:
ALL NUMBERS MUST BE POSITIVE INTEGERS.

Rules for datasets with "randomValues: true"
    - "numberOfAdditions" must be 1 or 2 (not more).
    - "numberOfExtraCards" must not be more than 6 - (2 * numberOfAdditions),
      so maximum is 2 for "numberOfAdditions: 2", or 4 for "numberOfAdditions: 1".
    - "minResult" must not be less than 11.
    - "maxResult" must not be more than 99.
    - "shuffle" is not used.

Rules for datasets with "randomValues: false"
    - "values" must contain an array of levels with fixed content.
    - Each level must contain:
        - An "additions" array containing 1 or 2 additions.
          Each addition is a string containing 2 numbers.
          The first number of each question must be between 1 and 9.
        - An optional "extraCards" array wich can contain 1 or 2
          extra proposed numbers (the numbers needed to solve the
          questions are added automatically).
    - "shuffle" defines if subLevels in "values" should be shuffled.

Example of dataset with randomValues: false
data: [
    {
        randomValues: false,
        shuffle: true,
        values: [
            {
                additions: [
                    "7 + 9",
                    "6 + 7"
                ],
                extraCards: [7, 2]
            },
            {
                additions: [
                    "4 + 8",
                    "5 + 6"
                ],
                extraCards: [4, 6]
            }
        ]
    }
]
*/

Data {
    objective: qsTr("Result between 11 and 19.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            numberOfSubLevels: 5,
            numberOfAdditions: 2,
            numberOfExtraCards: 2,
            minResult: 11,
            maxResult: 19
        },
        {
            randomValues: true,
            numberOfSubLevels: 5,
            numberOfAdditions: 2,
            numberOfExtraCards: 2,
            minResult: 11,
            maxResult: 19
        }
    ]
}
