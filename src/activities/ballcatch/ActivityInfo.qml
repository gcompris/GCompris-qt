/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "ballcatch/Ballcatch.qml"
    difficulty: 1
    icon: "ballcatch/ballcatch.svg"
    author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
    //: Activity title
    title: qsTr("Make the ball go to Tux")
    //: Help title
    description: qsTr("Press the left and right arrow keys at the same time, to make the ball go in a straight line.")
//    intro: "Press the left and right arrows at the same time to send the ball straight on"
    goal: ""
    prerequisite: ""
    //: Help manual
    manual: qsTr("Press the left and right arrow keys at the same time, to make the ball go in a straight line. On a touch screen you have to touch the two hands at the same time.")
    credit: ""
    section: "computer keyboard"
  createdInVersion: 0
}
