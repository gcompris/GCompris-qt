/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "left_right_click/Left_right_click.qml"
  difficulty: 1
  icon: "left_right_click/left_right_click.svg"
  author: "Samarth Raj &lt;mailforsamarth@gmail.com&gt;"
  //: Activity title
  title: qsTr("Mouse click training")
  //: Help title
  description: qsTr("Move animals to their homes using a left click or right click on your mouse.")
  //intro: "Move animals to their homes using a left click or right click on your mouse."
  //: Help goal
  goal: qsTr("Using the mouse. Left and right click training.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("A left click on a fish will move it to the pond. A right click on a monkey will move it to the tree. A message will show if you make the wrong click.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 30000
  enabled: !ApplicationInfo.isMobile ? true : false
}
