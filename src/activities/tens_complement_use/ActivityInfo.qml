/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "tens_complement_use/Tens_complement_use.qml"
  difficulty: 4
  icon: "tens_complement_use/tens_complement_use.svg"
  author: "Samarth Raj &lt;mailforsamarth@gmail.com&gt;, Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Use ten's complement")
  //: Help title
  description: qsTr("Use a ten's complement to simplify the operation.")
  //intro: "Decompose the operations to include a pair of numbers equal to ten. Select a number in the list, then select an empty spot of an operation to move the selected number there."
  //: Help goal
  goal: qsTr("Learn a practical use of ten's complement.")
  //: Help prerequisite
  prerequisite: qsTr("Numbers from 1 to 50 and additions.")
  //: Help manual
  manual: qsTr("Decompose the additions to create pairs of numbers equal to ten within each parentheses. Select a number in the list, then select an empty spot of an operation to move the selected number there.") + "<br>" +
    qsTr("When all the lines are completed, press the OK button to validate the answers. If some answers are incorrect, a cross icon will appear on the corresponding lines. To correct the errors, click on the wrong numbers to remove them and repeat the previous steps.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 30000
  levels: "1,2,3"
}
