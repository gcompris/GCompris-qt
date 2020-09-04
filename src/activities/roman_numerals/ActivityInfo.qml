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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "roman_numerals/RomanNumerals.qml"
  difficulty: 4
  icon: "roman_numerals/roman_numerals.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Roman numerals")
  //: Help title
  description: ""
  //intro: "Learn and practice roman to arabic numerals conversion"
  //: Help goal
  goal: "Learn how to read roman numerals and do the conversion to and from arabic numerals."
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Roman numerals are a numeral system that originated in ancient Rome and remained the usual way of writing numbers throughout Europe well into the Late Middle Ages. Numbers in this system are represented by combinations of letters from the Latin alphabet.") + "<br>" +
  qsTr("Learn the rules to read Roman numerals and practice converting numbers to and from arabic numerals. Click on the OK button to validate your answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: type arabic numerals") + ("</li><li>") +
          qsTr("Letters: type roman numerals (with I, V, X, L, C, D and M)") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "sciences history"
  createdInVersion: 7000
}
