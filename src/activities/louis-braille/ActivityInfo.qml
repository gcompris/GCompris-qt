/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Arkit Vora <arkitvora123@gmail.com>
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
  name: "louis-braille/LouisBraille.qml"
  difficulty: 4
  icon: "louis-braille/louis-braille.svg"
  author: "Arkit Vora &lt;arkitvora123@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("The History of Louis Braille")
  //: Help title
  description: qsTr("Review the major dates of the inventor of the Braille System")
  //intro: "Discover the history of Louis Braille."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Read the history of Louis Braille, his biography, and the invention of the Braille system. Click on the previous and next buttons to move between the story pages. At the end, arrange the sequence in chronological order.")
  credit: qsTr("Louis Braille Video: &lt;http:\/\/www.youtube.com/watch?v=9bdfC2j_4x4&gt;")
  section: "discovery braille"
  createdInVersion: 4000
}
