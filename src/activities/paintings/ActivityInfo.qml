/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (bruno.coudoin@gcompris.net) (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com>  (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
 
import GCompris 1.0

ActivityInfo {
  name: "paintings/Paintings.qml"
  difficulty: 1
  icon: "paintings/paintings.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Assemble the puzzle")
  //: Help title
  description: qsTr("Drag and Drop the pieces to rebuild the original paintings.")
  // intro: "Catch and drop each piece on the points."
  //: Help goal
  goal: qsTr("Spatial representation.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation: movement, drag and drop.")
  //: Help manual
  manual: qsTr("Drag the pieces to the right place to rebuild the painting.")
  section: "discovery arts puzzle"
  createdInVersion: 5000
}
