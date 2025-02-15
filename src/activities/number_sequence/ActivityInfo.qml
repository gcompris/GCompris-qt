/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Emmanuel Charruau <echarruau@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "number_sequence/NumberSequence.qml"
  difficulty: 2
  icon: "number_sequence/number_sequence.svg"
  author: "Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  //: Activity title
  title: qsTr("Number sequence")
  //: Help title
  description: qsTr("Select the numbers one after the other according to the numerical sequence.")
  // intro: "Draw the picture by touching the numbers in ascending order."
  //: Help goal
  goal: qsTr("Learn the numerical sequence.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Draw the picture by clicking on the points in the numerical sequence order. You can click and drag from one point to the next ones, or click on each point one after the other.")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
}
