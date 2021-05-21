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
    name: "ordering_chronology/ChronologicalOrder.qml"
    difficulty: 2
    icon: "ordering_chronology/chronological_order.svg"
    author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;"
    //: Activity title
    title: qsTr("Ordering chronology")
    //: Help title
    description: qsTr("Arrange the given events in their chronological order.")
    //intro: "Arrange the given events in their chronological order"
    //: Help goal
    goal: qsTr("Can decide chronological order of events.")
    //: Help prerequisite
    prerequisite: qsTr("Move, drag and drop using mouse.")
    //: Help manual
    manual: qsTr("You are provided with few images in the bottom box. Drag and drop these images to the upper box in their correct chronological order.")
    section: "reading"
    createdInVersion: 20000
    levels: "1,2,3"
    enabled: false
}
