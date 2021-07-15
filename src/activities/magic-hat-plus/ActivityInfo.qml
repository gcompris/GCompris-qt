/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Thib ROMAIN <thibrom@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "magic-hat-plus/MagicHatPlus.qml"
  difficulty: 2
  icon: "magic-hat-plus/magic-hat-plus.svg"
  author: "Thib ROMAIN &lt;thibrom@gmail.com&gt;"
  //: Activity title
  title: qsTr("The magician hat")
  //: Help title
  description: qsTr("Count how many stars are under the magic hat.")
//  intro: "Count the number of stars hidden under the hat and then click on the stars to indicate their number."
  //: Help goal
  goal: qsTr("Learn additions.")
  //: Help prerequisite
  prerequisite: qsTr("Additions.")
  //: Help manual
  manual: qsTr("Click on the hat to open it. How many stars went under it? Count carefully. Click on the bottom area to input your answer and on the OK button to validate it.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8"
}
