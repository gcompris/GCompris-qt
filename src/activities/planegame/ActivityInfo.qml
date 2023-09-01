/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "planegame/Sequence.qml"
    difficulty: 2
    icon: "planegame/planegame.svg"
    author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
    //: Activity title
    title: qsTr("Numbers in order")
    //: Help title
    description: qsTr("Move the helicopter to catch the clouds in the correct order.")
//  intro: "Move the helicopter with the arrow keys and catch the numbers in the clouds, in ascending order."
    //: Help goal
    goal: qsTr("Numeration training.")
    prerequisite: ""
    //: Help manual
    manual: qsTr("Catch the clouds in increasing order. With a keyboard, use the arrow keys to move the helicopter. With a pointing device, just click or tap on the target location. To know which number you have to catch you can either remember it or check the number on the bottom right corner.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move the helicopter") + ("</li></ul>")
    credit: ""
  section: "math numeration"
  createdInVersion: 0
}
