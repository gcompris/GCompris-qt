/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Thib ROMAIN <thibrom@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "guessnumber/Guessnumber.qml"
  difficulty: 3
  icon: "guessnumber/guessnumber.svg"
  author: "Thib ROMAIN &lt;thibrom@gmail.com&gt;"
  //: Activity title
  title: qsTr("Guess a number")
  //: Help title
  description: qsTr("Help Tux escape the cave by finding the hidden number.")
//  intro: "Find out the number by typing a number from the range proposed."
  goal: ""
  //: Help prerequisite
  prerequisite: qsTr("Numbers.")
  //: Help manual
  manual: qsTr("Read the instructions that give you the range of the number to find. Enter a number in the top right entry box. You will be told if your number is higher or lower than the one to find. Then try again until you find the correct answer. The distance between Tux and the right side of the screen represents how far you are from the number to find. If Tux is over or under the vertical center of the screen, it means your number is over or under the number to find.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: enter a number") + ("</li><li>") +
          qsTr("Backspace: erase a number") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
  levels: "1,2,3,4,5"
}
