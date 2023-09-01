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
    goal: qsTr("Numeration training.")
    prerequisite: ""
    //: Help manual
    manual: qsTr("Catch the clouds with an odd or even number, in the right order. With a keyboard, use the arrow keys to move the helicopter. With a pointing device, just click or tap on the target location. To know which number you have to catch you can either remember it or check the number on the bottom right corner.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move the helicopter") + ("</li></ul>")
    credit: ""
    section: "math numeration"
  createdInVersion: 0
}
