/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "erase_clic/EraseClic.qml"
  difficulty: 1
  icon: "erase_clic/erase_clic.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Click or tap")
  //: Help title
  description: qsTr("Click or tap to erase the area and discover the background.")
//  intro: "Click or tap on the transparent bricks and discover the hidden picture."
  //: Help goal
  goal: qsTr("Motor-coordination.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("Click or tap on the blocks to make them disappear.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
