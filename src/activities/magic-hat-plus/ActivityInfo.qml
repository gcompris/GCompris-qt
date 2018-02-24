/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Thib ROMAIN <thibrom@gmail.com>
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
  name: "magic-hat-plus/MagicHatPlus.qml"
  difficulty: 2
  icon: "magic-hat-plus/magic-hat-plus.svg"
  author: "Thib ROMAIN &lt;thibrom@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("The magician hat")
  //: Help title
  description: qsTr("Count how many items are under the magic hat")
//  intro: "Count the number of stars hidden under the hat and then click on the stars to indicate their number."
  //: Help goal
  goal: qsTr("Learn addition")
  //: Help prerequisite
  prerequisite: qsTr("Addition")
  //: Help manual
  manual: qsTr("Click on the hat to open it. Under the hat, how many stars can you see moving around? Count carefully. Click on the bottom area to input your answer and on the OK button to validate your answer.")
  credit: ""
  section: "math numeration"
}
