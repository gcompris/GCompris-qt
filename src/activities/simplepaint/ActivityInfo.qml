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
  name: "simplepaint/Simplepaint.qml"
  difficulty: 1
  icon: "simplepaint/simplepaint.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: true
  //: Activity title
  title: qsTr("A simple drawing activity")
  //: Help title
  description: qsTr("Create your own drawing")
  // intro: "Select a color and paint the rectangles as you like to create a drawing."
  //: Help goal
  goal: qsTr("Enhance creative skills")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Select a color and paint the rectangles as you like to create a drawing.")
  credit: ""
  section: "fun"
  createdInVersion: 4000
}
