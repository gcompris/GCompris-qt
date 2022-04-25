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
            //: These sentences should not need to be translated word by word. Please add at least 10 sentences, each one being between 6 and 10 words. Use | to separate group of words. The aim of the string is to shuffle the group of words and let the child reorder them correctly. We should not be able to form a correct sentence by shuffling some words in the final sentence.
            sentences: qsTr('The|sun|is|shining|in|the|sky.\n' +
            'Kids|enjoy|playing|outside|in|the|evening.\n' +
            'Are|you|going|out|for|lunch?\n'+
            'The|girl|tied|her|tennis|shoes|and|went|outside.\n'+
            'Sam|felt|sick|after|eating|five|huge|candy|bars.\n'+
            'Our|family|takes|a|vacation|to|the|beach|every|year.\n'+
            'Uncle|Joe|gave|me|a|red|toy|truck.\n'+
            'When|you|finish|your|rice|you|can|eat|dessert.\n'+
            'Mom|has|asked|me|to|play|in|the|room.\n'+
            'I|think|we|are|going|to|have|a|good|day.'
            )
        }
    ]
}
