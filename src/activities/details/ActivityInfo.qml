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
  name: "details/Details.qml"
  difficulty: 1
  icon: "details/details.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Find the details")
  //: Help title
  description: qsTr("Drag and Drop the shapes on their respective targets.")
//  intro: "Slide the images on their respective targets"
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Complete the puzzle by dragging each piece on the side to the matching space in the puzzle.")
  credit: qsTr("The images are from Wikimedia Commons.")
  section: "discovery arts"
  createdInVersion: 4000
  levels: "1,2,3"
}
