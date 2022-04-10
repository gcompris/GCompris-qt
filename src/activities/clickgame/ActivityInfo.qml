/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "clickgame/Clickgame.qml"
  difficulty: 1
  icon: "clickgame/clickgame.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Click on me")
  //: Help title
  description: qsTr("Catch all the swimming fish before they leave the fish tank.")
//  intro: "Catch the fish before they leave the aquarium."
  //: Help goal
  goal: qsTr("Motor coordination: moving the hand precisely.")
  //: Help prerequisite
  prerequisite: qsTr("Can move mouse and click on the correct place.")
  //: Help manual
  manual: qsTr("Catch all the moving fish by clicking or touching them with your finger.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
