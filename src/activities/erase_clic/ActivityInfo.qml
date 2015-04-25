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
  name: "erase_clic/EraseClic.qml"
  difficulty: 1
  icon: "erase_clic/erase_clic.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Click or tap")
  description: qsTr("Click or tap to erase the area and discover the background")
//  intro: " Click or tap on the transparent bricks and discover the hidden picture."
  goal: qsTr("Motor-coordination")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Click or tap on the blocks all of them disappear.")
  credit: ""
  section: "computer mouse"
}
