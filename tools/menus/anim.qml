/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Your Name <yy@zz.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
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
