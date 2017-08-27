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
  name: "hexagon/Hexagon.qml"
  difficulty: 2
  icon: "hexagon/hexagon.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Hexagon")
  //: Help title
  description: qsTr("Find the strawberry by clicking on the blue fields")
//  intro: "Click on the hexagons to find the hidden object, the red zone indicates that you're close to it!"
  //: Help goal
  goal: qsTr("Logic-training activity")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Try to find the strawberry under the blue fields. The fields become redder as you get closer.")
  credit: ""
  section: "fun"
}
