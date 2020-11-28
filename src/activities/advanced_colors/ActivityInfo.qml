/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "advanced_colors/AdvancedColors.qml"
  difficulty: 6
  icon: "advanced_colors/advanced_colors.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Advanced colors")
  //: Help title
  description: qsTr("Select the butterfly of the correct color.")
  //intro: "click on the required color"
  //: Help goal
  goal: qsTr("Learn to recognize unusual colors.")
  //: Help prerequisite
  prerequisite: qsTr("Can read.")
  //: Help manual
  manual: qsTr("You will see dancing butterflies of different colors and a question. You have to find the correct butterfly and touch it.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: select an item") + ("</li></ul>")
  credit: ""
  section: "reading colors vocabulary"
  createdInVersion: 0
}
