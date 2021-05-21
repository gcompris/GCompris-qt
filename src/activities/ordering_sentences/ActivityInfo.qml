/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "ordering_sentences/SentencesOrdering.qml"
    difficulty: 2
    icon: "ordering_sentences/sentences_ordering.svg"
    author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;, Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
    //: Activity title
    title: qsTr("Ordering sentences")
    //: Help title
    description: qsTr("Arrange the given words to form a meaningful sentence.")
    //intro: "Arrange the given words to form a meaningful sentence"
    //: Help goal
    goal: qsTr("Order words to form meaningful sentences.")
    //: Help prerequisite
    prerequisite: qsTr("Move, drag and drop using mouse.")
    //: Help manual
    manual: qsTr("You are provided with few words. Drag and drop the words in their correct position to form a meaningful sentence.")
    section: "reading"
    createdInVersion: 20000
    levels: "1,2"
}
