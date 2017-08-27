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
  name: "erase/Erase.qml"
  difficulty: 1
  icon: "erase/erase.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Move the mouse or touch the screen")
  //: Help title
  description: qsTr("Move the mouse or touch the screen to erase the area and discover the background")
//  intro: " Clear the window with your sponge and discover the hidden picture."
  //: Help goal
  goal: qsTr("Motor-coordination")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation")
  //: Help manual
  manual: qsTr("Move the mouse or touch the screen until all the blocks disappear.")
  credit: ""
  section: "computer mouse"
}
