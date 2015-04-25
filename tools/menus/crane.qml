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
  name: "crane/Crane.qml"
  difficulty: 2
  icon: "crane/crane.svg"
  author: "Marc BRUN"
  demo: true
  title: qsTr("Build the same model")
  description: qsTr("Drive the crane and copy the model")
  goal: qsTr("Motor-coordination")
  prerequisite: qsTr("Mouse manipulation")
  manual: qsTr("Move the items in the bottom left frame to copy their position in the top right model. Below the crane itself, you will find four arrows that let you move items. To select the item to move, just click on it. If you prefer, you can use the arrow keys and the space or tab key instead.")
  credit: ""
  section: "/puzzle"
}
