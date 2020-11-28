/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "erase_2clic/Erase2clic.qml"
  difficulty: 2
  icon: "erase_2clic/erase_2clic.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Double tap or double click")
  //: Help title
  description: qsTr("Double tap or double click to erase the area and discover the background image.")
//  intro: "Double tap or double click on the bricks to discover the hidden picture"
  //: Help goal
  goal: qsTr("Motor-coordination.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("Double tap or double click on the blocks to make them disappear.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
