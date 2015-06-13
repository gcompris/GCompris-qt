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
  name: "submarine/Submarine.qml"
  difficulty: 5
  icon: "submarine/submarine.svg"
  author: "Pascal Georges &lt;pascal.georges1@free.fr&gt;"
  demo: true
  title: qsTr("Pilot a submarine")
  description: qsTr("Pilot a submarine using air tanks and dive rudders")
  goal: qsTr("Learn how a submarine works")
  prerequisite: qsTr("Physics basics")
  manual: qsTr("Click on different active elements : engine, rudders and air tanks, in order to navigate to the required depth. There is a close gate on the right. After the first level, your have to catch the jewel to open it. Pass through it to reach the next level.")
  credit: ""
  section: "/experience"
}
