/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
  name: "paratrooper/Paratrooper.qml"
  difficulty: 1
  icon: "paratrooper/tuxpara.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("Parachutist")
  description: qsTr("Help Tux the parachutist land safely")
  goal: qsTr("In this game, Tux the parachutist needs help to land safely on the fishing boat. He needs to allow for the wind direction and speed.")
  prerequisite: qsTr("This board is game-oriented. No specific skills are needed to play.")
  manual: qsTr("Hit any key or click on the plane to make Tux jump. Hit another key or click on Tux to open the parachute.")
  credit: ""
  section: "/experience"
}
