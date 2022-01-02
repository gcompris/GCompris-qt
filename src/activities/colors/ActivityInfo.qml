/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "colors/Colors.qml"
  difficulty: 1
  icon: "colors/colors.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Colors")
  //: Help title
  description: qsTr("Click on the right color.")
//  intro: "Click on the right color"
  //: Help goal
  goal: qsTr("This activity teaches you to recognize different colors.")
  //: Help prerequisite
  prerequisite: qsTr("Identifying colors.")
  //: Help manual
  manual: qsTr("Listen to the color and click on the matching duck.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: select an answer") + ("</li><li>") +
          qsTr("Tab: repeat the question") + ("</li></ul>")
  credit: ""
  section: "reading color vocabulary"
  createdInVersion: 0
}
