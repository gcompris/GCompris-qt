/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Thibaut ROMAIN <thibrom@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "magic-hat-minus/MagicHat.qml"
  difficulty: 2
  icon: "magic-hat-minus/magic-hat-minus.svg"
  author: "Thibaut ROMAIN &lt;thibrom@gmail.com&gt;"
  //: Activity title
  title: qsTr("The magician hat")
  //: Help title
  description: qsTr("Calculate how many stars are under the magic hat.")
//  intro: "Click on the hat. How many stars are still hiding under the hat."
  //: Help goal
  goal: qsTr("Learn subtractions.")
  //: Help prerequisite
  prerequisite: qsTr("Subtractions.")
  //: Help manual
  manual: qsTr("Click on the hat to open it. Stars go in and a few stars escape. You have to calculate how many stars are still under the hat. Click on the bottom area to input your answer and on the OK button to validate it.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8"
}
