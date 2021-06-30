/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "smallnumbers2/Smallnumbers2.qml"
  difficulty: 2
  icon: "smallnumbers2/smallnumbers2.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Numbers with dominoes")
  //: Help title
  description: qsTr("Count the number on the domino before it reaches the ground.")
//  intro: "Count the numbers on the dominoes then type the result on your keyboard."
  //: Help goal
  goal: qsTr("Count a number in a limited time.")
  //: Help prerequisite
  prerequisite: qsTr("Counting skills.")
  //: Help manual
  manual: qsTr("Type the number you see on each falling domino.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: type your answer") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8"
}
