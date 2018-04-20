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
  description: "Click on a pair corresponding to the given relation"
  //intro: "Click on a pair that defines the given relation"
  //: Help goal
  goal: qsTr("Learn the relationships in a family, according to the lineal system used in most Western societies")
  //: Help prerequisite
  prerequisite: qsTr("Reading, moving and clicking with the mouse")
  //: Help manual
  manual: qsTr("A family tree is shown, with some instructions.\n" +
  "The circles are linked with lines to mark the relations. Married couples are marked with a ring on the link.\n" +
  "Click on a pair of family members which corresponds to the given relation.")
  credit: ""
  section: "discovery"
  createdInVersion: 9000
}
