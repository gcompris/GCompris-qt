/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "simplepaint/Simplepaint.qml"
  difficulty: 1
  icon: "simplepaint/simplepaint.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Draw in a grid")
  //: Help title
  description: qsTr("Create your own drawing.")
  // intro: "Select a color and paint the rectangles as you like to create a drawing."
  //: Help goal
  goal: qsTr("Express your creativity through drawing.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Select a color and paint the rectangles as you like to create a drawing.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: paint") + ("</li><li>") +
          qsTr("Tab: switch between the color selector and the painting area") + ("</li></ul>")
  credit: ""
  section: "discovery arts fun"
  createdInVersion: 4000
}
