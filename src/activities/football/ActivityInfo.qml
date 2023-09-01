/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "football/Football.qml"
  difficulty: 1
  icon: "football/football.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("The football game")
  //: Help title
  description: qsTr("Kick the ball into the goal.")
//  intro: "Drag a line from the ball to set the speed and direction of your kick."
  //: Help goal
  goal: qsTr("Kick the ball behind the goal keeper on the right.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Drag a line from the ball to set its speed and direction, and release it to kick the ball.")
  credit: ""
  section: "fun"
  createdInVersion: 0
}
