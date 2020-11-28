/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Your Name <yy@zz.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
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
