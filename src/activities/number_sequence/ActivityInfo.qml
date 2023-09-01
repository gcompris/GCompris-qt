/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Emmanuel Charruau <echarruau@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "number_sequence/NumberSequence.qml"
  difficulty: 2
  icon: "number_sequence/number_sequence.svg"
  author: "Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  //: Activity title
  title: qsTr("Number sequence")
  //: Help title
  description: qsTr("Touch the numbers in the right order.")
  // intro: "Draw the picture by touching the numbers in ascending order."
  //: Help goal
  goal: qsTr("Can count.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Draw the picture by clicking on each number in the right order.")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
}
