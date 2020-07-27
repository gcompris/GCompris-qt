/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
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
  name: "learn_digits/Learn_digits.qml"
  difficulty: 1
  icon: "learn_digits/learn_digits.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Learn digits")
  //: Help title
  description: qsTr("Learn digits from 0 to 9")
  //intro: "Click on the circles to match the given digit."
  //: Help goal
  goal: qsTr("Learn digits by counting their corresponding value")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("A digit is displayed on the screen. Fill the corresponding number of circles and validate the answer.")+ ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<br>") +
          qsTr("-Arrows: navigate") + ("<br>") +
          qsTr("-Space: select or deselect a circle") + ("<br>") +
          qsTr("-Enter: validate the answer") + ("<br>") +
          qsTr("-Tab: say the digit again")
  credit: ""
  section: "math numeration"
  createdInVersion: 9800
  levels: "1,2,3"
}
