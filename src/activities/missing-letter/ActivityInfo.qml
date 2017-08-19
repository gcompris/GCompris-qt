/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Amit Tomar <a.tomar@outlook.com>
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

ActivityInfo
{
  name: "missing-letter/MissingLetter.qml"
  difficulty: 2
  icon: "missing-letter/missing-letter.svg"
  author: "Amit Tomar &lt;a.tomar@outlook.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Missing Letter")
  //: Help title
  description: ""
//  intro: "Find the missing letter and complete the word by clicking on one of the letters proposed on the side."
  //: Help goal
  goal: qsTr("Training reading skills")
  //: Help prerequisite
  prerequisite: qsTr("Word reading")
  //: Help manual
  manual: qsTr("An object is displayed in the main area, and an incomplete word is printed under the picture. Select the missing letter to complete the word.")
  credit: ""
  section: "reading"
}
