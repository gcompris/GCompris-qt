/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

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
  goal: qsTr("Vocabulary and reading.")
  //: Help prerequisite
  prerequisite: qsTr("Reading.")
  //: Help manual
  manual: qsTr("Drag each image from the side to the corresponding name in the main area. Click on the OK button to check your answer.")
  section: "reading words"
  createdInVersion: 4000
}
