/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "numbers-odd-even/NumbersOddEven.qml"
    difficulty: 2
    icon: "numbers-odd-even/numbers-odd-even.svg"
    author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
    //: Activity title
    title: qsTr("Even and odd numbers")
    //: Help title
    description: qsTr("Move the helicopter to catch the clouds having even or odd numbers.")
//  intro: "Move the helicopter to catch the clouds having even or odd numbers, in the shown order."
    //: Help goal
    goal: qsTr("Learn to recognize even and odd numbers and their numerical order.")
    prerequisite: ""
    //: Help manual
    manual: qsTr("Follow the instructions: catch the clouds with an odd or even number in the right order. With a keyboard, use the arrow keys to move the helicopter. With a pointing device, just click or tap on the target location. On the first levels, you can see which number you have to catch on the counter in the bottom right corner. On the later levels, you need to remember it.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move the helicopter") + ("</li></ul>")
    credit: ""
    section: "math numeration"
  createdInVersion: 0
}
