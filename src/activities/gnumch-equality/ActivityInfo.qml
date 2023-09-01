/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Manuel Tondeur <manueltondeur@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "gnumch-equality/GnumchEquality.qml"
  difficulty: 3
  icon: "gnumch-equality/gnumch-equality.svg"
  author: "Manuel Tondeur &lt;manueltondeur@gmail.com&gt;"
  //: Activity title
  title: qsTr("Gnumch equality")
  //: Help title
  description: qsTr("Guide the Number Muncher to the expressions that equal the number at the bottom of the screen.")
//  intro: "Guide the number eater with the arrow keys to the required numbers and press the space bar to swallow them."
  //: Help goal
  goal: qsTr("Practice addition, multiplication, division and subtraction.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Guide the Number Muncher to the expressions that equal the number at the bottom of the screen.") +
          "<br><br>" +
          qsTr("If you have a keyboard you can use the arrow keys to move and press space to swallow the numbers. With a mouse you can click on the block next to your position to move and click again to swallow the numbers. With a touch screen you can do like with a mouse or swipe anywhere in the direction you want to move and tap to swallow the numbers.") +
          "<br><br>" +
          qsTr("Take care to avoid the Troggles.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space: swallow the numbers") + ("</li></ul>")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4"
}
