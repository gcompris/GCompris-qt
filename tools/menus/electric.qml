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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "electric/Electric.qml"
  difficulty: 5
  icon: "electric/electric.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("Electricity")
  description: qsTr("Create and simulate an electric schema")
  goal: qsTr("Freely create an electric schema with a real time simulation of it.")
  prerequisite: qsTr("Requires some basic understanding of the concept of electricity.")
  manual: qsTr("Drag electrical components from the selector and drop them in the working area. Create wires by clicking on a connection spot, dragging the mouse to the next connection spot, and letting go. You can also move components by dragging them. You can delete wires by clicking on them. To delete a component, select the deletion tool on top of the component selector. You can click on the switch to open and close it. You can change the rheostat value by dragging its wiper. In order to simulate what happens when a bulb is blown, you can blown it by right-clicking on it. The simulation is updated in real time by any user action.")
  credit: qsTr("GCompris uses the Gnucap electric simulator as a backend. You can get more information on gnucap at &lt;https://www.gnu.org/software/gnucap/&gt;.")
  section: "/experience"
}
