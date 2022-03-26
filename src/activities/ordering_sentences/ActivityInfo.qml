/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "ordering_sentences/OrderingSentences.qml"
    difficulty: 2
    icon: "ordering_sentences/ordering_sentences.svg"
    author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;, Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
    //: Activity title
    title: qsTr("Ordering sentences")
    //: Help title
    description: qsTr("Arrange the given words to form a meaningful sentence.")
    //intro: "Arrange the given words to form a meaningful sentence."
    //: Help goal
    goal: qsTr("Order words to form meaningful sentences.")
    //: Help prerequisite
    prerequisite: qsTr("Reading.")
    //: Help manual
    manual: qsTr("You are provided with some words. Drag and drop them to the upper area to form a meaningful sentence.")
    section: "reading words"
    createdInVersion: 20000
    levels: "1,2"
}
