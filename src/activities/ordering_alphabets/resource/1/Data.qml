/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Ascending order, 5 defined letters.")
    difficulty: 4
    data: [
        {
            mode: "ascending",      // Either ascending or descending
            // To override the default hardcoded instruction, define instruction string
            // instruction: "overridden instruction"
            random: false,
            //: Add 5 letters in ascending lexicographical order, separated by | character. The objective is to give children these letters in random order and ask them to sort in ascending lexicographical order.
            string: qsTr("a|b|c|d|e")
        },
        {
            mode: "ascending",      // Either ascending or descending
            random: false,
            //: Add 5 letters in ascending lexicographical order, separated by | character. The objective is to give children these letters in random order and ask them to sort in ascending lexicographical order.
            string: qsTr("c|f|g|l|m")
        }
    ]
}
