/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
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
  name: "computer/Computer.qml"
  difficulty: 1
  icon: "computer/computer.svg"
  author: "Sagar Chand Agarwal < atomsagar@gmail.com >"
  demo: true
  title: qsTr("Computer activity")
  description: qsTr("Your goal is to click on the box kept beside the table and see the components of computer one by one and read about it.Then,Drag the image to the specific points on the table and place it.Zoom at the table to enjoy virtual settings.")
  //intro: "Dad bought personal computer.Unbox the box kept beside the door and drag components one by one."
  goal: qsTr("Learning the parts of computer and basic setting of its external components")
  prerequisite: "none"
  manual: qsTr("Drag and drop the components on the table and zoom the monitor and enjoy.")
  credit: qsTr("")
  section: "fun"
}
