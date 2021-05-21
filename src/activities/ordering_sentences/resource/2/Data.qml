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
    objective: qsTr("Below 10 words.")
    difficulty: 4
    data: [
        {
            //: These sentences should not need to be translated word by word. Please add several sentences (between 2 and 4), each one being between 6 and 10 words. Use | to separate group of words. The aim of the string is to shuffle the group of words and let the child reorder them correctly.
            sentences: qsTr('The|sun|is|shining|bright|in|the|sky.\n' +
            'Kids|enjoy|playing|outside|in|the|evening.')
        }
    ]
}
