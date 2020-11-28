/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-wordnumber/MemoryWordnumber.qml"
  difficulty: 3
  icon: "memory-wordnumber/memory-wordnumber.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Wordnumber memory game")
  //: Help title
  description: qsTr("Flip the cards to match a numeral with its number name.")
//  intro: "Match the numeric with the word."
  //: Help goal
  goal: qsTr("Reading numbers, memory.")
  //: Help prerequisite
  prerequisite: qsTr("Reading.")
  //: Help manual
  manual: qsTr("Each card is hiding either a numeral (a number written in figures), or a number name (a number written in words). You have to match the numerals with the corresponding number names.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
}
