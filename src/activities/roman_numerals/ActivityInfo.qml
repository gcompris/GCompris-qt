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
  manual: qsTr("A Roman numeral is the name for a number when it is written in the way the Romans used to write numbers. Roman numerals are not used very often today in the west. They are used to write the names of kings and queens, or popes. For example: Queen Elizabeth II. They may be used to write the year a book or movie was made.\n
  The building of the roman numbers is made up by an agglutination of numbers (the thousands, joined with the hundreds, joined with the tens, joined with the units → just like the arab decimal system). This agglutination of numbers is interpreted as the sum of these particular numbers (again → just like the arab decimal system: you add up thousands+hundreds+tens+units, and you write the respective figures combined).\n
  Examples:\n
  2394: we got a sum of 2000 (MM), 300 (CCC), 90 (XC) and 4 units (IV), so we write this combined: MMCCCXCIV\n
  MMMCMXLIX: we got first thousands (MMM=3000), then we got hundreds (CM=1000–100=900), then we got tens (XL=50–10=40), and at last we got units (IX=10–1=9), so we write this in the decimal system: 3949.")
  credit: ""
  section: "sciences history"
  createdInVersion: 7000
}
