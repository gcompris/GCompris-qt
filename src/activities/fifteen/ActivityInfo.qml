/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "fifteen/Fifteen.qml"
  difficulty: 5
  icon: "fifteen/fifteen.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("The fifteen game")
  //: Help title
  description: qsTr("Move each item to recreate the image.")
  //intro: "Click or drag an element next to a free space, the element will move and release its space. You must put all the pieces in the correct order. The numbers on the pieces can help you."
  //: Help goal
  goal: qsTr("Arrange the pieces in the right order.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click or drag on any piece next to the empty space, and it will move to the empty space.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move a piece to the empty space.") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 0
}
