/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "followline/Followline.qml"
  difficulty: 1
  icon: "followline/followline.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Control the hose-pipe")
  //: Help title
  description: qsTr("The fireman needs to stop the fire, but the hose is blocked.")
//  intro: " Move the mouse or your finger along the pipe to stop the fire."
  //: Help goal
  goal: qsTr("Fine motor coordination")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Move the mouse or your finger over the lock which is represented as a red part in the hose-pipe. This will move it, bringing it, part by part, up to the fire. Be careful, if you move off the hose, the lock will go backward.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
