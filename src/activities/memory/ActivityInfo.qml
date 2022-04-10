/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 JB BUTET <ashashiwa@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "memory/Memory.qml"
  difficulty: 1
  icon: "memory/memory.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  //: Activity title
  title: qsTr("Memory game with images")
  //: Help title
  description: qsTr("Flip the cards to find the matching pairs.")
//  intro: "Click on a card and find its double."
  //: Help goal
  goal: qsTr("Train your memory and remove all the cards.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("Each card has a picture on the hidden side, and each card has a twin with exactly the same picture. Click on a card to see its hidden picture, and try to match the twins. You can only flip two cards at once, so you need to remember where a picture is, while you look for its twin. When you flip the twins, they both disappear.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ("<ul><li>") +
          ('"Card Flip" by f4ngy, (https://freesound.org/people/f4ngy/sounds/240776/), CC BY 3.0') + ("</li></ul>")
  section: "fun memory"
  createdInVersion: 0
}
