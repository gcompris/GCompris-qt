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
  name: "babyshapes/Babyshapes.qml"
  difficulty: 1
  icon: "babyshapes/babyshapes.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Complete the puzzle")
  //: Help title
  description: qsTr("Drag and Drop the shapes on their respective targets.")
//  intro: "Drag and drop the objects matching the shapes."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Complete the puzzle by dragging each piece on the side to the matching spot.")
  credit: qsTr("The dog is provided by Andre Connes and released under the GPL")
  section: "computer"
  createdInVersion: 4000
}
