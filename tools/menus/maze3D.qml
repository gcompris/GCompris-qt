/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Your Name <yy@zz.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "maze3D/Maze3D.qml"
  difficulty: 2
  icon: "maze3D/maze3D.svg"
  author: "Christof Petig &lt;christof@petig-baender.de&gt;"
  demo: true
  title: qsTr("3D Maze")
  description: qsTr("Find your way out of the 3D maze")
  goal: qsTr("Help Tux get out of this maze.")
  prerequisite: qsTr("Can use the keyboard arrow to move an object.")
  manual: qsTr("Use the keyboard arrows to move Tux up to the door. Use the spacebar to switch between 2D and 3D modes. 2D mode just gives you an indication of your position, like a map. You cannot move Tux in 2D mode.")
  credit: ""
  section: "/discovery/mazeMenu"
}
