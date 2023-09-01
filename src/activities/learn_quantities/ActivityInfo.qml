/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "learn_quantities/Learn_quantities.qml"
  difficulty: 1
  icon: "learn_quantities/learn_quantities.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Learn quantities")
  //: Help title
  description: qsTr("Learn to represent a quantity of objects.")
  //intro: "Drag the arrow to select a number of oranges, and drag the oranges to the empty area to represent the requested quantity."
  //: Help goal
  goal: qsTr("Learn quantities by counting how many oranges are needed to represent the requested quantity.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("A quantity is requested. Drag the arrow to select a number of oranges, and drag the selected oranges to the empty area. Repeat these steps until the number of dropped oranges corresponds to the requested quantity. Then click on the OK button to validate your answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 20000
  levels: "1,2,3,4,5,6,7"
}
