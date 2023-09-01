/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2019 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "baby_tangram/BabyTangram.qml"
  difficulty: 1
  icon: "baby_tangram/baby_tangram.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Baby puzzle")
  //: Help title
  description: qsTr("The objective is to assemble the baby puzzle.")
  // intro: "Move each puzzle piece, to obtain the completed puzzle. You can change their orientation by clicking on the arrows."
  goal: ""
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("Move a piece by dragging it. Use the rotation button if necessary. More complicated levels can be found in tangram activity.")
  credit: ""
  section: "puzzle"
  createdInVersion: 9700
}
