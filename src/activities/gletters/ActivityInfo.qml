/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "gletters/Gletters.qml"
  difficulty: 2
  icon: "gletters/gletters.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  demo: true
  //: Activity title
  title: qsTr("Simple Letters")
  //: Help title
  description: qsTr("Type the falling letters before they reach the ground")
//  intro: "Type the letters on your keyboard before they reach the ground."
  //: Help goal
  goal: qsTr("Letter association between the screen and the keyboard")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Type the falling letters before they reach the ground")
  credit: ""
  section: "computer keyboard reading letters"
  createdInVersion: 0
}
