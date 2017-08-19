/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
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
  name: "traffic/Traffic.qml"
  difficulty: 2
  icon: "traffic/traffic.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  demo: true
  //: Activity title
  title: qsTr("A sliding-block puzzle game")
  //: Help title
  description: qsTr("Remove the red car from the parking lot through the gate on the right")
//  intro: "Slide the cars to make a space so that the red car can go out of the box."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Each car can only move either horizontally or vertically. You must make some room in order to let the red car move through the gate on the right.")
  credit: ""
  section: "puzzle"
}
