/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
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
  name: "analog_electricity/AnalogElectricity.qml"
  difficulty: 6
  icon: "analog_electricity/analog_electricity.svg"
  author: "Aiswarya Kaitheri Kandoth &lt;aiswaryakk29@gmail.com&gt;"
  //: Activity title
  title: qsTr("Analog Electricity")
  //: Help title
  description: qsTr("Create and simulate an analog electric schema")
  //intro: "Learn how analog electricity works and create your own circuit."
  //: Help goal
  goal: qsTr("Create an analog electric schema with a real time simulation.")
  //: Help prerequisite
  prerequisite: qsTr("Requires some basic understanding of the concept of electricity.")
  //: Help manual
  manual: qsTr("Drag electrical components from the selector and drop them in the working area. In the working area, you can move the components by dragging them.") + " " + qsTr("To delete a component or wire, select the deletion tool on top of the component selector, and select the component or wire.") + " " + qsTr("You can click on the component and then on the rotate buttons to rotate it or on the info button to get information about it.") + " " + qsTr("You can click on the switch to open and close it. You can change the rheostat value by dragging its slider.") + " " + qsTr("To connect two terminals, click on the first terminal, then on the second terminal. To deselect a terminal, click on any empty area.") + " " + qsTr("In order to repair a broken bulb or LED, click on it after deconnecting it from the circuit. The simulation is updated in real time by any user action.")
  credit: qsTr("The electric simulation engine is from edX: ") +
            "&lt;https://github.com/edx/edx-platform/blob/master/common/lib/xmodule/xmodule/js/src/capa/schematic.js&gt;."
  section: "sciences experiment"
  createdInVersion: 9800
}
