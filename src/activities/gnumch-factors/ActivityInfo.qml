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

ActivityInfo {
  name: "gnumch-factors/GnumchFactors.qml"
  difficulty: 5
  icon: "gnumch-factors/gnumch-factors.svg"
  author: "Manuel Tondeur &lt;manueltondeur@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Gnumch Factors")
  //: Help title
  description: qsTr("Guide the Number Muncher to all the factors of the number at the bottom of the screen.")
//  intro: "Guide the number eater with the arrow keys to the factors of the displayed number and press space to swallow them."
  //: Help goal
  goal: qsTr("Learn about multiples and factors.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("The factors of a number are all the numbers that divide that number evenly. For example, the factors of 6 are 1, 2, 3 and 6. 4 is not a factor of 6 because 6 cannot be divided into 4 equal pieces. If one number is a multiple of a second number, then the second number is a factor of the first number. You can think of multiples as families, and factors are the people in those families. So 1, 2, 3 and 6 all fit into the 6 family, but 4 belongs to another family.") +
          "<br><br>" +
          qsTr("If you have a keyboard you can use the arrow keys to move and hit space to swallow a number. With a mouse you can click on the block next to your position to move and click again to swallow the number. With a touch screen you can do like with a mouse or swipe anywhere in the direction you want to move and tap to swallow the number.") +
          "<br><br>" +
          qsTr("Take care to avoid the Troggles.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 0
}
