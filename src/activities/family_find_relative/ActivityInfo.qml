/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
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
  name: "family_find_relative/Family_find_relative.qml"
  difficulty: 2
  icon: "family_find_relative/family_find_relative.svg"
  author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Point the relatives")
  //: Help title
  description: ""
  //intro: "Click on a pair that defines the given relation"
  //: Help goal
  goal: qsTr("To get an idea of family relations")
  //: Help prerequisite
  prerequisite: qsTr("Reading, moving and clicking with the mouse")
  //: Help manual
  manual: qsTr("You are provided with a relation and a family hierarchy. Click on a pair of family members which correctly identifies the given relation.")
  credit: ""
  section: "discovery"
  createdInVersion: 9000
}
