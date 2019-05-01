/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "target/Target.qml"
  difficulty: 2
  icon: "target/target.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Practice addition with a target game")
  //: Help title
  description: qsTr("Hit the target and count your points")
  // intro: "Click on the target to launch darts, then count your final score!"
  //: Help goal
  goal: qsTr("Throw darts at a target and count your score.")
  //: Help prerequisite
  prerequisite: qsTr("Can move the mouse, can read numbers and count up to 15 for the first level")
  //: Help manual
  manual: qsTr("Check the speed and direction of the target, and then click on it to launch a dart. When all your darts are thrown, you are asked to count your score. Enter the score with the keyboard.")
  credit: ""
  section: "math addition arithmetic"
  createdInVersion: 0
}
