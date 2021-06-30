/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 JB BUTET <ashashiwa@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-math-add-minus-mult-div/MemoryMathAddMinusMultDiv.qml"
  difficulty: 6
  icon: "memory-math-add-minus-mult-div/memory-math-add-minus-mult-div.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  //: Activity title
  title: qsTr("All operations memory game")
  //: Help title
  description: qsTr("Flip the cards to match an operation with its result.")
//  intro: "Turn over two cards to match the calculation with its answer."
  //: Help goal
  goal: qsTr("Practice additions, subtractions, multiplications, divisions.")
  //: Help prerequisite
  prerequisite: qsTr("Additions, subtractions, multiplications, divisions.")
  //: Help manual
  manual: qsTr("Each card is hiding either an operation, or a result. You have to match the operations with their result.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "math memory arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8,9,10"
}
