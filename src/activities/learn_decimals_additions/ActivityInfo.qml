/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "learn_decimals_additions/Learn_decimals_additions.qml"
  difficulty: 5
  icon: "learn_decimals_additions/learn_decimals_additions.svg"
  author: "Mariam Fahmy &lt;mariamfahmy66@gmail.com&gt;"
  //: Activity title
  title: qsTr("Additions with decimal numbers")
  //: Help title
  description: qsTr("Learn additions with decimal numbers.")
  //intro: "Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area to represent the result of the addition."
  //: Help goal
  goal: qsTr("Learn additions with decimal numbers by counting how many squares are needed to represent the result.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("An addition with two decimal numbers is displayed. Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area. Repeat these steps until the number of dropped bars corresponds to the result of the addition, and click on the OK button to validate your answer.")+ ("<br><br>") +
  qsTr("If the answer is correct, type the corresponding result, and click on the OK button to validate your answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Enter: validate your answer") + ("</li><li>") +
          qsTr("Numbers: type the result") + ("</li></ul>")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 20000
  levels: "1,2,3"
}
