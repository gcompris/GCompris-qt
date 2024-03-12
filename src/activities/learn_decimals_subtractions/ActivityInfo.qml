/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "learn_decimals_subtractions/Learn_decimals_subtractions.qml"
  difficulty: 5
  icon: "learn_decimals_subtractions/learn_decimals_subtractions.svg"
  author: "Mariam Fahmy &lt;mariamfahmy66@gmail.com&gt;"
  //: Activity title
  title: qsTr("Subtraction with decimal numbers")
  //: Help title
  description: qsTr("Learn subtraction with decimal numbers.")
  //intro: "Click on the squares to represent the result of the subtraction."
  //: Help goal
  goal: qsTr("Learn subtraction with decimal numbers by manipulating their visual representation.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("A subtraction with two decimal numbers is displayed. The first number from the subtraction is represented with bars. Each bar represents one unit, and each square in the bar represent one tenth of this unit. Click on the squares to subtract the second number and represent the result of the operation")+ ("<br><br>") +
  qsTr("If the answer is correct, type the corresponding result, and click on the OK button to validate your answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Enter: validate your answer") + ("</li><li>") +
          qsTr("Numbers: type the result") + ("</li></ul>")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 20000
  levels: "1,2,3"
}
