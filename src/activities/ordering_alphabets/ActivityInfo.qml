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
    name: "ordering_alphabets/OrderingAlphabets.qml"
    difficulty: 2
    icon: "ordering_alphabets/ordering_alphabets.svg"
    author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;, Harsh Kumar &lt;hadron43@yahoo.com&gt;"
    //: Activity title
    title: qsTr("Ordering letters")
    //: Help title
    description: qsTr("Arrange the given letters in alphabetical order or in reverse alphabetical order as requested.")
    //intro: "Arrange the letters in the correct order."
    //: Help goal
    goal: qsTr("Learn the alphabetical order.")
    //: Help prerequisite
    prerequisite: qsTr("Reading.")
    //: Help manual
    manual: qsTr("You are provided with some letters. Drag and drop them to the upper area in alphabetical order or in reverse alphabetical order as requested.")
    section: "reading letters"
    createdInVersion: 20000
    levels: "1,2,3,4,5,6"
}
