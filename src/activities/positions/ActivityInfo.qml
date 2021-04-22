/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "positions/Positions.qml"
  difficulty: 3
  icon: "positions/positions.svg"
  author: "Mariam Fahmy &lt;mariamfahmy66@gmail.com&gt;"
  //: Activity title
  title: qsTr("Positions")
  //: Help title
  description: qsTr("Find the boy's position in relation to the box.")
  //intro: "Find the correct position"
  //: Help goal
  goal: qsTr("Describe the relative position of an object.")
  //: Help prerequisite
  prerequisite:qsTr("Can read.")
  //: Help manual
  manual: qsTr("You will see different images representing a boy and a box, you have to find out the position of the boy in relation to the box and select the correct answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: validate selected answer") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 20000
  levels: "1,2"
}
