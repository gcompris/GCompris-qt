/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Bruno Coudoin < bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "roman_numerals/RomanNumerals.qml"
  difficulty: 4
  icon: "roman_numerals/roman_numerals.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Roman numerals")
  description: ""
  //intro: "Learn and practice roman to arabic numerals conversion"
  //: Help goal
  goal: qsTr("Learn how to read roman numerals and do the conversion to and from arabic numerals.")
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
