/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2020 Timothée Giet<animtim@gmail.com>
 *
 * Authors:
 *   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (complete activity rewrite)
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
  name: "gravity/Gravity.qml"
  difficulty: 3
  icon: "gravity/gravity.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Gravity")
  //: Help title
  description: qsTr("Introduction to the concept of gravity")
  //intro: "Move the spaceship to avoid hitting the planets and reach the space station."
  //: Help goal
  goal: qsTr("Move the spaceship to avoid hitting the planets and reach the space station.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Move the spaceship with the left and right keys, or with the buttons on the screen for mobile devices. Try to stay near the center of the screen and anticipate by looking at the size and direction of the arrow showing the gravity force.")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 9800
}
