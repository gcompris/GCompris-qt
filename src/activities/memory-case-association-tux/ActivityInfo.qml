/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2017 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-case-association-tux/MemoryCaseAssociationTux.qml"
  difficulty: 2
  icon: "memory-case-association-tux/memory-case-association-tux.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Case association memory game against Tux")
  //: Help title
  description: qsTr("Flip the cards to find the uppercase and lowercase of the same letter, playing against Tux.")
  //intro: "Match the upper case card with its lower case pair."
  //: Help goal
  goal: qsTr("Learning lowercase and uppercase letters, memory.")
  //: Help prerequisite
  prerequisite: qsTr("Knowing alphabets.")
  //: Help manual
  manual: qsTr("Each card is hiding a letter, lowercase or uppercase. You have to match the lowercase and uppercase of the same letter.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "reading letters"
  createdInVersion: 9000
}
