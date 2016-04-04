/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
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
  name: "PhotoHunter/PhotoHunter.qml"
  difficulty: 1
  icon: "PhotoHunter/PhotoHunter.svg"
  author: "Stefan Toncu &lt;stefan.toncu@cti.pub.ro&gt;"
  demo: true
  title: qsTr("Photo Hunter")
  description: qsTr("Find the differences between the two pictures!")
  //intro: "look at the two pictures carefully and click where you see a difference")
  goal: qsTr("Visual Discrimination")
  prerequisite: ""
  manual: qsTr("Observe the two pictures carefully. There are some slight differences. When you find a difference you must click on it.")
  credit: ""
  section: "puzzle"
  createdInVersion: 6000
}
