/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Arkit Vora <arkitvora123@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "louis-braille/LouisBraille.qml"
  difficulty: 4
  icon: "louis-braille/louis-braille.svg"
  author: "Arkit Vora &lt;arkitvora123@gmail.com&gt;"
  //: Activity title
  title: qsTr("The history of Louis Braille")
  //: Help title
  description: qsTr("Read about some key events in the life of the braille system inventor, and remember their chronological order.")
  //intro: "Discover the history of Louis Braille."
  //: Help goal
  goal: qsTr("Remember the order of an event sequence. Learn about the life of Louis Braille.")
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
