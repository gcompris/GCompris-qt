/* GCompris - ActivityInfo.qml
 * 
 * SPDX-FileCopyrightText: 2015 Sayan Biswas <techsayan01@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "algebra_div/AlgebraDiv.qml"
  difficulty: 6
  icon: "algebra_div/algebra_div.svg"
  author: "Sayan Biswas &lt;techsayan01@gmail.com&gt;"
  //: Activity title
  title: qsTr("Division of numbers")
  //: Help title
  description: qsTr("Practice the division operation.")
  //  intro: "Find the result of the division and type in your answer before the balloon lands in the water"
  //: Help goal
  goal: qsTr("Find the result of the division within a limited period of time.")
  //: Help prerequisite
  prerequisite: qsTr("Division of small numbers.")
  //: Help manual
  manual: qsTr("A division is displayed on the screen. Quickly find the result and use your computer's keyboard or the on-screen keypad to type it. You have to be fast and submit the answer before the penguins in their balloon land!") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: type your answer") + ("</li><li>") +
          qsTr("Backspace: delete the last digit in your answer") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "math division arithmetic"
  createdInVersion: 4000
  levels: "1,2,3,4,5,6,7,8,9,10,11"
}
