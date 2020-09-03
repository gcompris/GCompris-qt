/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Manuel Tondeur <manueltondeur@gmail.com>
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

// Must be updated once GnumchEquality is reviewed
ActivityInfo {
  name: "gnumch-inequality/GnumchInequality.qml"
  difficulty: 3
  icon: "gnumch-inequality/gnumch-inequality.svg"
  author: "Manuel Tondeur &lt;manueltondeur@gmail.com&gt;"
  //: Activity title
  title: qsTr("Gnumch Inequality")
  //: Help title
  description: qsTr("Guide the Number Muncher to all the expressions that do not equal the number at the bottom of the screen.")
//  intro: "Guide the number eater with the arrow keys to the numbers that are different from the ones displayed and press the space bar to swallow them."
  //: Help goal
  goal: qsTr("Practice addition, subtraction, multiplication and division.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("If you have a keyboard you can use the arrow keys to move and press space to swallow the numbers. With a mouse you can click on the block next to your position to move and click again to swallow the numbers. With a touch screen you can do like with a mouse or swipe anywhere in the direction you want to move and tap to swallow the numbers.") +
          "<br><br>" +
          qsTr("Take care to avoid the Troggles.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space: swallow the numbers") + ("</li></ul>")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4"
}
