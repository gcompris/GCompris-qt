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
  author: "Amit Tomar <a.tomar@outlook.com>"
  demo: true
  title: qsTr("Missing Letter")
  description: ""
//  intro: "Find the missing letter and complete the word by clicking on one of the letters proposed on the side."
  goal: qsTr("Training reading skills")
  prerequisite: qsTr("Word reading")
  manual: qsTr("An object is displayed in the main area, and an incomplete word is printed under the picture. Select the missing letter to complete the word.")
  credit: ""
  section: "reading"
}
