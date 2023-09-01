/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "balancebox/Balancebox.qml"
  difficulty: 2
  icon: "balancebox/balancebox.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  //: Activity title
  title: qsTr("Balance box")
  //: Help title
  description: qsTr("Navigate the ball to the door by tilting the box.")
//  intro: "Tilt the box to navigate the ball to the door."
  //: Help goal
  goal: qsTr("Practice fine motor skills and basic counting.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Navigate the ball to the door. Be careful not to make it fall into the holes. Numbered-contact buttons in the box need to be touched in the correct order to unlock the door. You can move the ball by tilting your mobile device. On desktop platforms use the arrow keys to simulate tilting.") + ("<br><br>") +

    qsTr("In the activity settings menu you can choose between the default 'Built-in' level set and one that you can define yourself ('User'). To create a level set, select the 'user' level set and start the level editor by clicking on the corresponding button.") + ("<br><br>") +

    qsTr("In the <b>level editor</b> you can create your own levels. Choose one of the editing tools on the side to modify the map cells of the currently active level in the editor:")+ ("<ul><li>") +
    qsTr("Cross: clear a map cell completely") + ("</li><li>") +
    qsTr("Horizontal Wall: add/remove a horizontal wall on the lower edge of a cell") + ("</li><li>") +
    qsTr("Vertical Wall: add/remove a vertical wall on the right edge of a cell") + ("</li><li>") +
    qsTr("Hole: add/remove a hole on a cell") + ("</li><li>") +
    qsTr("Ball: set the starting position of the ball") + ("</li><li>") +
    qsTr("Door: Set the door position") + ("</li><li>") +
    qsTr("Contact: add/remove a contact button. With the spin-box you can adjust the value of the contact button. It is not possible to set a value more than once on a map.") + ("</li></ul>") +

    qsTr("All tools (except the clear-tool) toggle their respective target on the clicked cell: An item can be placed by clicking on an empty cell, and by clicking again on the same cell with the same tool, you can remove it again.") + ("<br><br>") +
    qsTr("You can test a modified level by clicking on the 'Test' button on the side of the editor view. You can return from testing mode by clicking on the home-button on the bar or by pressing escape on your keyboard or the back-button on your mobile device.") + ("<br><br>") +
    qsTr("In the editor you can change the level currently edited by using the arrow buttons on the bar. Back in the editor you can continue editing the current level and test it again if needed.") +
    qsTr("When your level is finished you can save it to a file by clicking on the 'Save' button on the side.") + ("<br><br>") +
    qsTr("To return to the activity settings click on the home-button on the bar or press Escape on your keyboard or the back button on your mobile device.") + ("<br><br>") +
    qsTr("Finally, to load your level set, click on the 'Load saved levels' button.")
  credit: ""
  section: "mobile fun"
  enabled: ApplicationInfo.isBox2DInstalled && (!ApplicationInfo.isMobile || ApplicationInfo.sensorIsSupported("QTiltSensor"))
  createdInVersion: 5000
}
