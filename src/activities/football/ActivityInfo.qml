/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

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
  goal: qsTr("Understand direction and speed.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Press the ball, and drag behind it to draw the aiming line. The longer the line, the more powerful the kick. When you release the line, the ball will follow its direction. You score a goal when the ball reaches the other edge of the field.")
  credit: ""
  section: "fun"
  createdInVersion: 0
}
