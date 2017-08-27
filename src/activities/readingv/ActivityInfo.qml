/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
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
  name: "readingv/Readingv.qml"
  difficulty: 2
  icon: "readingv/readingv.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Vertical-reading practice")
  //: Help title
  description: qsTr("Read a vertical list of words and work out if a given word is in it.")
//  intro: "Read a list of words and say if a given word is in it."
  //: Help goal
  goal: qsTr("Reading training in a limited time")
  //: Help prerequisite
  prerequisite: qsTr("Reading")
  //: Help manual
  manual: qsTr("A word is shown at the top right of the board. A list of words will appear and disappear on the left. Does the given word belong to the list?")
  credit: ""
  section: "reading"
  createdInVersion: 5000
}

