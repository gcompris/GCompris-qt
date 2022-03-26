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
    name: "ordering_chronology/OrderingChronology.qml"
    difficulty: 2
    icon: "ordering_chronology/ordering_chronology.svg"
    author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;"
    //: Activity title
    title: qsTr("Ordering chronology")
    //: Help title
    description: qsTr("Arrange the given events in their chronological order.")
    //intro: "Arrange the given events in their chronological order."
    //: Help goal
    goal: qsTr("Can decide chronological order of events.")
    //: Help prerequisite
    prerequisite: qsTr("Tell a short story.")
    //: Help manual
    manual: qsTr("You are provided with some images. Drag and drop them to the upper area in their chronological order.")
    section: "discovery logic"
    createdInVersion: 20000
    levels: "1,2,3"
    enabled: false
}
