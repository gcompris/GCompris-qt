/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "erase/Erase.qml"
  difficulty: 1
  icon: "erase/erase.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Move the mouse or touch the screen")
  //: Help title
  description: qsTr("Move the mouse or touch the screen to erase the area and discover the background.")
//  intro: " Clear the window with your sponge and discover the hidden picture."
  //: Help goal
  goal: qsTr("Motor-coordination.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("Move the mouse or touch the screen on the blocks to make them disappear.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
