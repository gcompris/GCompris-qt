/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "hanoi/Hanoi.qml"
  difficulty: 2
  icon: "hanoi/hanoi.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Simplified Tower of Hanoi")
  //: Help title
  description: qsTr("Reproduce the given tower.")
  //intro: "Rebuild the same tower in the empty area as the one you see on the right hand side."
  //: Help goal
  goal: qsTr("Reproduce the tower on the right in the empty area.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("Drag and Drop one top piece at a time, from one tower to another, to reproduce the tower on the right in the empty area.")
  credit: qsTr("Concept taken from EPI games.")
  section: "discovery logic"
  createdInVersion: 4000
}
