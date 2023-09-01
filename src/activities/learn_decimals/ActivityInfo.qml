/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "learn_decimals/Learn_decimals.qml"
  difficulty: 5
  icon: "learn_decimals/learn_decimals.svg"
  author: "Mariam Fahmy &lt;mariamfahmy66@gmail.com&gt;"
  //: Activity title
  title: qsTr("Learn decimal numbers")
  //: Help title
  description: qsTr("Learn decimals with small numbers.")
  //intro: "Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area to represent the decimal number."
  //: Help goal
  goal: qsTr("Learn decimals by counting how many squares are needed to represent the decimal number.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("A decimal number is displayed. Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area. Repeat these steps until the number of dropped bars corresponds to the displayed decimal number. Then click on the OK button to validate your answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 20000
  levels: "1,2"
}
