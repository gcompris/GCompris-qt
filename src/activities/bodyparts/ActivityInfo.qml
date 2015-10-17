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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "bodyparts/BodyParts.qml"
  difficulty: 1
  icon: "bodyparts/logo.svg"
  demo: true
  author: "Shivansh Bajaj &lt;bajajshivanhs1@gmail.com&gt;"
  title: qsTr("know your body parts")
  description: qsTr("Click on the right body part")
//  intro: "Click on the right bodypart"
  goal: qsTr("This activity teaches you to know few facts about our body. When you see the question, touch the the correct body part question representing.")
  prerequisite: qsTr("know how to identify body parts")
  manual: qsTr("See the question and touch the matching answer.")
  credit: ""
  section: "experiment"
}
