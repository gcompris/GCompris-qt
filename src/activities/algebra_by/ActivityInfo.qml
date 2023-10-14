/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "algebra_by/AlgebraBy.qml"
  difficulty: 3
  icon: "algebra_by/algebra_by.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Multiplication of numbers")
  //: Help title
  description: qsTr("Practice the multiplication operation.")
//  intro: "Multiply the two numbers together and type in your answer before the balloon lands in the water"
  //: Help goal
  goal: qsTr("Learn to multiply numbers within a limited period of time.")
  //: Help prerequisite
  prerequisite: qsTr("Multiplication tables from 1 to 10.")
  //: Help manual
  manual: qsTr("A multiplication is displayed on the screen. Quickly find the result and use your computer's keyboard or the on-screen keypad to type the product of the numbers. You have to be fast and submit the answer before the penguins in their balloon land!") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: type your answer") + ("</li><li>") +
          qsTr("Backspace: delete the last digit in your answer") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "math multiplication arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8,9,10,11"
}
