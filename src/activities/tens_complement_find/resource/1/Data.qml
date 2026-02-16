/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

/**
Global rule:
- ALL NUMBERS MUST BE POSITIVE INTEGERS.
- "shuffleOperands" defines if operands in an addition are shuffled.
- Each addition has 2 operands:
    - If "randomValues: true", the first operands are randomly generated between
      "minimumFirstValue" and "maximumFirstValue". If "randomValues: false", the first operands
      are the numbers in "firstOperands".
    - The second operands are the complement to 10 of first operands, always automatically
      generated.
- The second operands are always added to the list of cards. If "findBothNumbers: true", the first operands are also added to the list of cards.

Rules for datasets with "randomValues: true"
    - "numberOfAdditions" must be 1, 2, or 3 (not more).
    - "numberOfExtraCards" must not be more than 6 - numberOfAdditions,
      or if "findBothNumbers: true" it must not be more than  6 - (2 * numberOfAdditions),
      so we never have more than 6 cards.
    - "minimumFirstValue" must not be less than 1.
    - "maximumFirstValue" must not be more than 9.

Rules for datasets with "randomValues: false"
    - "values" must contain an array of levels with fixed content.
    - Each level must contain:
        - A "firstOperands" array containing 1, 2 or 3 numbers between 1 and 9.
        - An optional "extraCards" array wich can contain extra numbers between 1 and 9.
          The number of extraCards must not be more than 6 - (number of firstOperands),
          or if "findBothNumbers: true" it must not be more than 6 - (2 * (number of firstOperands)), so we never have more than 6 cards.

Example of dataset with randomValues: false
data: [
    {
        randomValues: false,
        shuffleOperands: false,
        values: [
        {
            firstOperands: [2, 1, 4],
            extraCards: [2, 4, 2]
        },
        {
            firstOperands: [2, 1, 3],
            extraCards: [2, 5, 4]
        }
        ]
    }
]
*/
Data {
    objective: qsTr("First number from 1 to 4.")
    difficulty: 4
    data: [
        {
            randomValues: true,
            shuffleOperands: false,
            numberOfSublevels: 5,
            numberOfAdditions: 3,
            numberOfExtraCards: 0,
            findBothNumbers: false,
            minimumFirstValue: 1,
            maximumFirstValue: 4
        },
        {
            randomValues: true,
            shuffleOperands: false,
            numberOfSublevels: 5,
            numberOfAdditions: 3,
            numberOfExtraCards: 0,
            findBothNumbers: false,
            minimumFirstValue: 1,
            maximumFirstValue: 4
        }
    ]
}
