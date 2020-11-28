/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "click_on_letter/ClickOnLetter.qml"
  difficulty: 2
  icon: "click_on_letter/click_on_letter.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  //: Activity title
  title: qsTr("Click on a lowercase letter")
  //: Help title
  description: qsTr("Listen to a letter and click on it.")
//  intro: "Click on the required letter. You can listen to it again by clicking on the mouth."
  //: Help goal
  goal: qsTr("Letter-name recognition.")
  //: Help prerequisite
  prerequisite: qsTr("Visual letter-recognition.")
  //: Help manual
  manual: qsTr("A letter is spoken. Click on the matching letter in the main area. You can listen to the letter again by clicking on the mouth icon.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space: select an item") + ("</li><li>") +
          qsTr("Tab: repeat the question") + ("</li></ul>")
  credit: ""
  section: "reading letters"
  createdInVersion: 0
}
