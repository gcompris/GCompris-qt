/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "algebra_plus/AlgebraPlus.qml"
  difficulty: 3
  icon: "algebra_plus/algebra_plus.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Addition of numbers")
  //: Help title
  description: qsTr("Practice the addition of numbers.")
//  intro: "Add the two numbers together and type in your answer before the balloon lands in the water"
  //: Help goal
  goal: qsTr("Learn to find the sum of two numbers within a limited period of time.")
  //: Help prerequisite
  prerequisite: qsTr("Simple addition. Can recognize written numbers.")
  //: Help manual
  manual: qsTr("An addition is displayed on the screen. Quickly find the result and use your computer's keyboard or the on-screen keypad to type it. You have to be fast and submit the answer before the penguins land in their balloon!") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: type your answer") + ("</li><li>") +
          qsTr("Backspace: delete the last digit in your answer") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "math addition arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8,9,10,11,12,13"
}
