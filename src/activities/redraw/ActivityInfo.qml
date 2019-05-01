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
  name: "redraw/Redraw.qml"
  difficulty: 3
  icon: "redraw/redraw.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Redraw the given image")
  //: Help title
  description: qsTr("Draw perfectly the given image on the empty grid.")
  //intro: "Use the drawing tools to build an identical pattern on the right."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("First, select the proper color from the toolbar. Then click on the grid and drag to paint, then release the click to stop painting.")
  credit: ""
  section: "puzzle"
  createdInVersion: 0
}
