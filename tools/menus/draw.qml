/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
  name: "draw/Draw.qml"
  difficulty: 2
  icon: "draw/draw.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("A simple vector-drawing tool")
  description: qsTr("A creative board where you can draw freely")
  goal: qsTr("In this game, children can draw freely. The goal is to discover how to create attractive drawings based on basic shapes: rectangles, ellipses and lines.")
  prerequisite: qsTr("Needs to be capable of moving and clicking the mouse easily")
  manual: qsTr("Select a drawing tool on the left, and a color down the bottom, then click and drag in the white area to create a new shape. To save time, you can click with the middle mouse button to delete an object.")
  credit: ""
  section: "/math/geometry"
}
