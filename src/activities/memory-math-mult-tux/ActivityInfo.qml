/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 JB BUTET <ashashiwa@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-math-mult-tux/MemoryMathMultTux.qml"
  difficulty: 5
  icon: "memory-math-mult-tux/memory-math-mult-tux.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  //: Activity title
  title: qsTr("Multiplication memory game against Tux")
  //: Help title
  description: qsTr("Flip the cards to match a multiplication with its result, playing against Tux.")
//  intro: "Turn over two cards to match the calculation with its answer."
  //: Help goal
  goal: qsTr("Practice multiplications.")
  //: Help prerequisite
  prerequisite: qsTr("Multiplications.")
  //: Help manual
  manual: qsTr("Each card is hiding either a multiplication, or a result. You have to match the multiplications with their result.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "math memory arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8,9,10"
}
