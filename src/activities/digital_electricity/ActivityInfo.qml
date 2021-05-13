/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "digital_electricity/DigitalElectricity.qml"
  difficulty: 6
  icon: "digital_electricity/digital_electricity.svg"
  author: "Pulkit Gupta &lt;pulkitnsit@gmail.com&gt;"
  //: Activity title
  title: qsTr("Digital electricity")
  //: Help title
  description: qsTr("Create and simulate a digital electric schema.")
  //intro: "Learn how digital electronics work and create your own circuit."
  //: Help goal
  goal: qsTr("Create a digital electric schema with a real time simulation of it.")
  //: Help prerequisite
  prerequisite: qsTr("Requires some basic understanding of the concept of digital electronics.")
  //: Help manual
  manual: qsTr("Drag electrical components from the side bar and drop them in the working area.") + ("<ul><li>") +
          qsTr("To connect two terminals with a wire, click on a first terminal, then on a second terminal.") + ("</li><li>") +
          qsTr("The simulation is updated in real time by any user action.") + ("</li><li>") +
          qsTr("In the working area, you can move the components by dragging them.") + ("</li><li>") +
          qsTr("In the side bar, you can click on the tool icon to access the tool menu.") + ("</li><li>") +
          qsTr("To delete a component or a wire, select the delete tool (cross icon) from the tool menu, and click on the component or on the wire you want to delete.") + ("</li><li>") +
          qsTr("To deselect a terminal or the delete tool, click on any empty area.") + ("</li><li>") +
          qsTr("You can rotate the selected component using the rotate buttons (circle arrow icons) from the tool menu.") + ("</li><li>") +
          qsTr("You can read information about the selected component using the info button (i icon) from the tool menu.") + ("</li><li>") +
          qsTr("You can zoom in or out the working area using the + and - keys, using the zoom buttons from the tool menu, or using pinch gestures on a touchscreen.") + ("</li><li>") +
          qsTr("You can pan the working area by clicking on an empty area and dragging it.") + ("</li><li>") +
          qsTr("You can click on a switch component to open and close it.") + ("</li></ul>")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 9000
}
