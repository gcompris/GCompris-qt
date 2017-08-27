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
  name: "clickgame/Clickgame.qml"
  difficulty: 1
  icon: "clickgame/clickgame.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Click On Me")
  //: Help title
  description: qsTr("Catch all the swimming fish before they leave the fish tank")
//  intro: "Catch the fish before they leave the aquarium."
  //: Help goal
  goal: qsTr("Motor coordination: moving the hand precisely.")
  //: Help prerequisite
  prerequisite: qsTr("Can move mouse and click on the correct place")
  //: Help manual
  manual: qsTr("Catch all the moving fish by simple clicking or touching them with your finger.")
  credit: qsTr("Fish are taken from the Unix utility xfishtank. All image credits belong to Guillaume Rousse.")
  section: "computer mouse"
}
