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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "anim/Anim.qml"
  difficulty: 3
  icon: "anim/anim.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("Create a drawing or an animation")
  description: qsTr("Free drawing and animation tool.")
  goal: qsTr("In this game, children can draw freely. The goal is to discover how to create attractive drawings based on basic shapes: rectangles, ellipses and lines. To give children a wider range of choices, a set of images can also be used.")
  prerequisite: qsTr("Needs to be capable of moving and clicking the mouse easily")
  manual: qsTr("Select a drawing tool on the left, and a color down the bottom. Then click and drag in the white area to create a new shape. Once you've completed a drawing, you can select a new frame to work on by selecting one of the small rectangles on the bottom. Each frame contains the same content as its previous one. You can then edit it by moving objects a little bit or adding/deleting objects. When you create several frames and then click on the 'film' button, you will see all your images in a continuous slide-show (an infinite loop pattern). You can change the last image in your film by right clicking on a time frame. You can also change the viewing speed in this mode. In viewing mode, click on the 'drawing' button to return to drawing mode. You can also save and reload your animations with the 'floppy disk' and 'folder' buttons.")
  credit: ""
  section: "/fun"
}
