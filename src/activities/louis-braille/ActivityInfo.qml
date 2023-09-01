/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Arkit Vora <arkitvora123@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "louis-braille/LouisBraille.qml"
  difficulty: 4
  icon: "louis-braille/louis-braille.svg"
  author: "Arkit Vora &lt;arkitvora123@gmail.com&gt;"
  //: Activity title
  title: qsTr("The history of Louis Braille")
  //: Help title
  description: qsTr("Review the major dates of the inventor of the braille system.")
  //intro: "Discover the history of Louis Braille."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Read the history of Louis Braille, his biography, and the invention of the braille system. Click on the previous and next buttons to move between the story pages. At the end, arrange the sequence in chronological order.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: select an item and change its position") + ("</li></ul>")
  credit: qsTr("Louis Braille Video: &lt;https:\/\/www.youtube.com/watch?v=9bdfC2j_4x4&gt;")
  section: "sciences history"
  createdInVersion: 4000
}
