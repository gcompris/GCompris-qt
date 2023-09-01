/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "leftright/Leftright.qml"
  difficulty: 2
  icon: "leftright/leftright.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Find your left and right hands")
  //: Help title
  description: qsTr("Determine if a hand is a right or a left hand.")
//  intro: "Guess if the picture presents a left or right hand and click on the correct answer."
  //: Help goal
  goal: qsTr("Distinguish right and left hands from different points of view. Spatial representation.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("You can see a hand: is it a left hand or a right hand? Click on the left button, or the right button depending on the displayed hand.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Left arrow: left hand answer") + ("</li><li>") +
          qsTr("Right arrow: right hand answer") + ("</li></ul>")
  credit: ""
  section: "puzzle"
  createdInVersion: 0
}
