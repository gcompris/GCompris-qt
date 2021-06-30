/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "target/Target.qml"
  difficulty: 2
  icon: "target/target.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Practice addition with a target game")
  //: Help title
  description: qsTr("Hit the target and count your points.")
  // intro: "Click on the target to launch darts, then count your final score!"
  //: Help goal
  goal: qsTr("Throw darts at a target and count your score.")
  //: Help prerequisite
  prerequisite: qsTr("Can move the mouse, can read numbers and count up to 15 for the first level.")
  //: Help manual
  manual: qsTr("Check the speed and direction of the target, and then click on it to launch a dart. When all your darts are thrown, you are asked to count your score. Enter the score with the keyboard.")
  credit: ""
  section: "math addition arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4,5"
}
