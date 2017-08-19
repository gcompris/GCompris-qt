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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "football/Football.qml"
  difficulty: 1
  icon: "football/football.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("The football game")
  //: Help title
  description: qsTr("Kick the ball into the goal")
//  intro: "Drag a line from the ball to set the speed and direction of your kick."
  //: Help goal
  goal: qsTr("Kick the ball behind the goal keeper on the right")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Drag a line from the ball, to set its speed and direction.")
  credit: ""
  section: "fun"
}
