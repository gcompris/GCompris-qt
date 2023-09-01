/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Emmanuel Charruau <echarruau@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "clickanddraw/Clickanddraw.qml"
  difficulty: 1
  icon: "clickanddraw/clickanddraw.svg"
  author: "Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  //: Activity title
  title: qsTr("Click and draw")
  //: Help title
  description: qsTr("Draw the picture by clicking on the selected points.")
//  intro: "Click on the selected points and draw"
  goal: ""
  //: Help prerequisite
  prerequisite: qsTr("Can move the mouse and click accurately on points.")
  //: Help manual
  manual: qsTr("Draw the picture by clicking on each point in sequence. Each time a point is selected the next blue one appears.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
