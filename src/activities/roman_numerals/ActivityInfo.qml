/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Bruno Coudoin < bruno.coudoin@gcompris.net>
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
  name: "roman_numerals/RomanNumerals.qml"
  difficulty: 4
  icon: "roman_numerals/roman_numerals.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: true
  //: Activity title
  title: qsTr("Roman numerals")
  //: Help title
  description: ""
  //intro: "Learn and practice roman to arabic numerals conversion"
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("A Roman numeral is the name for a number when it is written in the way the Romans used to write numbers. Roman numerals are not used very often today in the west. They are used to write the names of kings and queens, or popes. For example: Queen Elizabeth II. They may be used to write the year a book or movie was made.")
  credit: ""
  section: "math"
  createdInVersion: 7000
}
