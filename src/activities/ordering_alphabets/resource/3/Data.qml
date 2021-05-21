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
    objective: qsTr("Ascending order, 5 random letters.")
    difficulty: 4
    data: [
        {
            mode: "ascending",      // Either ascending or descending
            // To override the default hardcoded instruction, define instruction string
            // instruction: "overridden instruction"
            random: true,          // Set this true to override values array with random values
            numberOfElementsToOrder: 5,
            //: Translate the below string to the set of alphabets in ascending order in your language. The objective is to give children some random letters from this string, and ask them to order them in ascending order.
            string: qsTr("a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z")
        }
    ]
}
