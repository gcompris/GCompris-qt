/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "learn_subtractions/Learn_subtractions.qml"
  difficulty: 2
  icon: "learn_subtractions/learn_subtractions.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Learn subtractions")
  //: Help title
  description: qsTr("Learn subtractions with small numbers.")
  //intro: "Click on the circles to give the operation's result."
  //: Help goal
  goal: qsTr("Learn subtractions by counting their result.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("A subtraction is displayed on the screen. Calculate the result, fill the corresponding number of circles and validate your answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space: select or deselect a circle") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 10000
  levels: "1,2,3,4,5"
}
