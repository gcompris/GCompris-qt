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
  name: "chronos/Chronos.qml"
  difficulty: 1
  icon: "chronos/chronos.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Chronos")
  //: Help title
  description: qsTr("Drag and Drop the items to organize the story.")
//  intro: "Slide the pictures into the order that tells the story"
  //: Help goal
  goal: qsTr("Learn to recognize the chronology of a story.")
  //: Help prerequisite
  prerequisite: qsTr("Tell a short story.")
  //: Help manual
  manual: qsTr("Arrange the pictures to make a coherent story. Drag the pictures from the sidebar to the corresponding dots, then click the OK button to validate your answer.")
  credit: qsTr("Dates of Transportation are based on those found in &lt;https://www.wikipedia.org&gt;.")
  section: "sciences history"
  createdInVersion: 4000
  levels: "1,2"
}
