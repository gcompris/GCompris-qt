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
  name: "imagename/Imagename.qml"
  difficulty: 3
  icon: "imagename/imagename.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Name the image")
  //: Help title
  description: qsTr("Drag and Drop each item above its name.")
//  intro: "Drag and drop each item above its name."
  //: Help goal
  goal: qsTr("Enrich your vocabulary and practice reading.")
  //: Help prerequisite
  prerequisite: qsTr("Reading.")
  //: Help manual
  manual: qsTr("Drag each image from the side to the corresponding name in the main area. Click on the OK button to check your answer.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move the selection cursor through the panel items and board spots") + ("</li><li>") +
          qsTr("Space: select an item in the list, and place it on a spot. If there is nothing selected in the list, remove item from selected spot") + ("</li><li>") +
          qsTr("Tab: toggle navigation between the panel and the board without any other action") + ("</li><li>") +
          qsTr("Delete or Backspace: remove item from selected spot") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  section: "reading words"
  createdInVersion: 4000
}
