/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 JB BUTET <ashashiwa@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-math-add-minus-tux/MemoryMathAddMinusTux.qml"
  difficulty: 4
  icon: "memory-math-add-minus-tux/memory-math-add-minus-tux.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  //: Activity title
  title: qsTr("Addition and subtraction memory game against Tux")
  //: Help title
  description: qsTr("Flip the cards to match an addition or a subtraction with its result, playing against Tux.")
//  intro: "Turn over two cards to match the calculation with its answer."
  //: Help goal
  goal: qsTr("Practice additions and subtractions.")
  //: Help prerequisite
  prerequisite: qsTr("Additions and subtractions.")
  //: Help manual
  manual: qsTr("Each card is hiding either an operation (an addition or a subtraction), or a result. You have to match the operations with their result.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "math memory arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8,9,10"
}
