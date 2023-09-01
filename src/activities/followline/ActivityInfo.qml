/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "followline/Followline.qml"
  difficulty: 1
  icon: "followline/followline.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Control the hose-pipe")
  //: Help title
  description: qsTr("The fireman needs to stop the fire, but the hose is blocked.")
//  intro: " Move the mouse or your finger along the pipe to stop the fire."
  //: Help goal
  goal: qsTr("Fine motor coordination.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Move the mouse or your finger over the lock which is represented as a red part in the hose-pipe. This will move it, bringing it, part by part, up to the fire. Be careful, if you move off the hose, the lock will go backward.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
