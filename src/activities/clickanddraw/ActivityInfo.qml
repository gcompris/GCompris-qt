/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Emmanuel Charruau <echarruau@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

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
  //: Help goal
  goal: qsTr("Practice using a mouse or touchscreen to touch specific points.")
  //: Help prerequisite
  prerequisite: qsTr("Can move the mouse and click accurately on points.")
  //: Help manual
  manual: qsTr("Draw the picture by clicking on each point in sequence. Each time a point is selected the next blue one appears. You can click and drag from one point to the next ones, or click on each point one after the other.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
