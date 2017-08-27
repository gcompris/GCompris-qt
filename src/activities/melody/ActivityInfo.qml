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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "melody/Melody.qml"
  difficulty: 2
  icon: "melody/melody.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Melody")
  //: Help title
  description: qsTr("Reproduce a sound sequence")
// intro: "Listen to the sound sequence played, and reproduce it by clicking on the xylophone's bars"
  //: Help goal
  goal: qsTr("Ear-training activity")
  //: Help prerequisite
  prerequisite: qsTr("Move and click the mouse")
  //: Help manual
  manual: qsTr("Listen to the sound sequence played, and repeat it by clicking on the xylophone's bars. You can listen again by clicking on the repeat button.")
  credit: ""
  section: "discovery memory music"
  createdInVersion: 5000
}
