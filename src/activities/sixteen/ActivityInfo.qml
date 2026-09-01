/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "sixteen/Sixteen.qml"
  difficulty: 6
  icon: "sixteen/sixteen.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("The sixteen game")
  //: Help title
  description: qsTr("Slide the rows and columns to recreate the image.")
  //intro: "Click on an arrow to slide the corresponding row or column in thit direction. You must put all the pieces in the correct order. The numbers on the pieces can help you."
  //: Help goal
  goal: qsTr("Develop anticipation and spatial visualization skills.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on an arrow to slide the corresponding row or column in this direction.") + ("<br><br>") +
  qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
  qsTr("Arrows: navigate to select arrow buttons.") + ("</li><li>") +
  qsTr("Space or Enter: click on selected button.") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 270000
}
