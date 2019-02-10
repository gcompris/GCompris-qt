/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "balancebox/Balancebox.qml"
  difficulty: 2
  icon: "balancebox/balancebox.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  demo: true
  //: Activity title
  title: qsTr("Balance Box")
  //: Help title
  description: qsTr("Navigate the ball to the door by tilting the box.")
//  intro: "Tilt the box to navigate the ball to the door."
  //: Help goal
  goal: qsTr("Practice fine motor skills and basic counting.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Navigate the ball to the door. Be careful not to make it fall into the holes. Numbered-contact buttons in the box need to be touched in the correct order to unlock the door. You can move the ball by tilting your mobile device. On desktop platforms use the arrow keys to simulate tilting.

In the <b>configuration dialog</b> you can choose between the default 'Built-in' level set and one that you can define yourself ('User'). A user-defined level set can be created by choosing the 'user' level set and start the level editor by clicking on the corresponding button.

In the <b>level editor</b> you can create your own levels. Choose one of the editing tools on the left side to modify the map cells of the currently active level in the editor:
    Cross: Clear a map cell completely
    Horizontal Wall: Set/remove a horizontal wall on the lower edge of a cell
    Vertical Wall: Set/remove a vertical wall on the right edge of a cell
    Hole: Set/remove a hole on a cell
    Ball: Set the starting position of the ball
    Door: Set the door position
    Contact: Set/remove a contact button. With the spin-box you can adjust the value of the contact button. It is not possible to set a value more than once on a map.
All tools (except the clear-tool) toggle their respective target on the clicked cell: An item can be placed by clicking on an empty cell, and by clicking again on the same cell with the same tool, you can remove it again.
You can test a modified level by clicking on the 'Test' button on the right side of the editor view. You can return from testing mode by clicking on the home-button on the bar or by pressing escape on your keyboard or the back-button on your mobile device.
In the editor you can change the level currently edited by using the arrow buttons on the bar. Back in the editor you can continue editing the current level and test it again if needed.
When your level is finished you can save it to the user level file by clicking on the 'Save' button on the right side.
To return to the configuration dialog click on the home-button on the bar or press Escape on your keyboard or the back button on your mobile device.")
  credit: ""
  section: "mobile fun"
  enabled: ApplicationInfo.isBox2DInstalled && (!ApplicationInfo.isMobile || ApplicationInfo.sensorIsSupported("QTiltSensor"))
  createdInVersion: 5000
}
