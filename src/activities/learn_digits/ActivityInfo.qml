/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "learn_digits/Learn_digits.qml"
  difficulty: 1
  icon: "learn_digits/learn_digits.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Count and color the circles")
  //: Help title
  description: qsTr("Learn digits from 0 to 9.")
  //intro: "Click on the circles to match the given digit."
  //: Help goal
  goal: qsTr("Learn digits by counting their corresponding value.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("A digit is displayed on the screen. Fill the corresponding number of circles and validate your answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space: select or deselect a circle") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li><li>") +
          qsTr("Tab: say the digit again") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 10000
  levels: "1,2,3,4,5,6,7,8,9"
}
