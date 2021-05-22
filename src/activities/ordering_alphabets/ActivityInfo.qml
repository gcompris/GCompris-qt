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
    name: "ordering_alphabets/AlphabeticalOrder.qml"
    difficulty: 2
    icon: "ordering_alphabets/alphabetical_order.svg"
    author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;, Harsh Kumar &lt;hadron43@yahoo.com&gt;"
    //: Activity title
    title: qsTr("Ordering alphabets")
    //: Help title
    description: qsTr("Arrange the given alphabets in ascending or descending order as instructed.")
    //intro: "Arrange the alphabets in the correct order by placing an alphabet in its correct position"
    //: Help goal
    goal: qsTr("Compare alphabets.")
    //: Help prerequisite
    prerequisite: qsTr("Move, drag and drop using mouse.")
    //: Help manual
    manual: qsTr("You are provided with few alphabets. Drag and drop the alphabets in their correct position to reorder the letters in ascending or descending order as instructed.")
    section: "reading"
    createdInVersion: 20000
    levels: "1,2,3,4,5,6"
}
