/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-enumerate/MemoryEnumerate.qml"
  difficulty: 2
  icon: "memory-enumerate/memory-enumerate.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Enumeration memory game")
  //: Help title
  description: qsTr("Flip the cards to match a number with a picture.")
//  intro: "Match a number card with a card displaying the same number of butterflies."
  //: Help goal
  goal: qsTr("Numeration training, memory.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Each card is hiding either a picture with a number of items, or a number. You have to match the numbers with the corresponding pictures.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8"
}
