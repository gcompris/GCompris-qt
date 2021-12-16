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
    name: "ordering_numbers/OrderingNumbers.qml"
    difficulty: 2
    icon: "ordering_numbers/ordering_numbers.svg"
    author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;, Emmanuel Charruau &lt;echarruau@gmail.com&gt;, Harsh Kumar &lt;hadron43@yahoo.com&gt;"
    //: Activity title
    title: qsTr("Ordering numbers")
    //: Help title
    description: qsTr("Arrange the given numbers in ascending or descending order as requested.")
    //: intro: "Arrange the numbers in the correct order."
    //: Help goal
    goal: qsTr("Compare numbers.")
    //: Help prerequisite
    prerequisite: qsTr("Counting.")
    //: Help manual
    manual: qsTr("You are provided with some numbers. Drag and drop them to the upper area in ascending or descending order as requested.")
    section: "math numeration"
    createdInVersion: 20000
    levels: "1,2,3,4,5,6,7,8"
}
