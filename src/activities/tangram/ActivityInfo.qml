/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "tangram/Tangram.qml"
  difficulty: 3
  icon: "tangram/tangram.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("The tangram puzzle game")
  //: Help title
  description: qsTr("Move the objects to reproduce the given shape.")
  // intro: "Click on each object to obtain the same figure. You can change their orientation by clicking on the arrows."
  //: Help goal
  goal: qsTr("Develop skills in spatial visualization, memorizing positions, and reproducing models.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("Move a piece by dragging it. The symmetrical button appears on items that support it. Drag the rotation button or around selected piece to rotate it. Check the activity 'Baby Puzzle' for a simpler introduction to tangram.")
  credit: ""
  section: "puzzle"
  createdInVersion: 6000
}
