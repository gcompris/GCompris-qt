/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
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
  name: "categorization/Categorization.qml"
  difficulty: 4
  icon: "categorization/categorization.svg"
  author: "Divyam Madaan &lt;divyam3897@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Categorization")
  //: Help title
  description: qsTr("Categorize the elements into correct and incorrect groups")
  //intro: "Categorize the elements into the correct group"
  //: Help goal
  goal: qsTr("Build conceptual thinking and enrich knowledge")
  //: Help prerequisite
  prerequisite: qsTr("Can drag elements using mouse")
  //: Help manual
  manual: qsTr("Review the instructions and then drag and drop the elements as specified")
  credit: ""
  section: "fun"
  createdInVersion: 8000
}
