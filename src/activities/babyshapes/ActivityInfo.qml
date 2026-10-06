/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
 
import core 1.0

ActivityInfo {
  name: "babyshapes/Babyshapes.qml"
  difficulty: 1
  icon: "babyshapes/babyshapes.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Complete the puzzle")
  //: Help title
  description: qsTr("Drag and drop the shapes on their respective targets.")
//  intro: "Drag and drop the objects matching the shapes."
  //: Help goal
  goal: qsTr("Learn to match geometric shapes.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Complete the puzzle by dragging each piece on the side to the matching spot.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move the selection cursor through the panel items and board spots") + ("</li><li>") +
          qsTr("Space: select an item in the list, and place it on a spot. If there is nothing selected in the list, remove item from selected spot") + ("</li><li>") +
          qsTr("Tab: toggle navigation between the panel and the board without any other action") + ("</li><li>") +
          qsTr("Delete or Backspace: remove item from selected spot") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: qsTr("The dog is provided by Andre Connes and released under the GPL")
  section: "computer"
  createdInVersion: 4000
}
