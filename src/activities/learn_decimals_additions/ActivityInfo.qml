/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "learn_decimals_additions/Learn_decimals_additions.qml"
  difficulty: 1
  icon: "learn_decimals_additions/learn_decimals_additions.svg"
  author: "Mariam Fahmy &lt;mariamfahmy66@gmail.com&gt;"
  //: Activity title
  title: qsTr("Addition with decimal numbers")
  //: Help title
  description: qsTr("Learn addition with decimal number.")
  //intro: "Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area to represent the result of the addition."
  //: Help goal
  goal: qsTr("Learn addition with decimal number by counting how many squares needed to represent the result.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("An addition with two decimal numbers is displayed. Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area. Repeat these steps until the number of dropped bars corresponds to the result of the addition, and click on the OK button to validate your answer.")+ ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 20000
  levels: "1,2,3"
}
