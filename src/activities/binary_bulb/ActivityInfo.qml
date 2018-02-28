/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Rajat Asthana <rajatasthana4@gmail.com>
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
  name: "binary_bulb/Binary_bulb.qml"
  difficulty: 2
  icon: "binary_bulb/binary_bulb.svg"
  author: "Rajat Asthana &lt;rajatasthana4@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Binary_bulb activity")
  //: Help title
  description: qsTr("This activity helps you to learn the concept of conversion of decimal number system to binary number system.")
  //intro: "put here in comment the text for the intro voice"
  //: Help goal
  goal: qsTr("To get familiar with binary number system")
  //: Help prerequisite
  prerequisite: "Decimal number system"
  //: Help manual
  manual: ""
  credit: ""
  section: "experiment"
  createdInVersion: 9000
}
