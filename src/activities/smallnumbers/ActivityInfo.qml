/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "smallnumbers/Smallnumbers.qml"
  difficulty: 2
  icon: "smallnumbers/smallnumbers.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Numbers with dice")
  //: Help title
  description: qsTr("Count the number of dots on the dice before it reaches the ground.")
//  intro: "Count the number on the dice and type it on your keyboard before it reaches the ground."
  //: Help goal
  goal: qsTr("In a limited time, count the number of dots.")
  //: Help prerequisite
  prerequisite: qsTr("Counting skills.")
  //: Help manual
  manual: qsTr("Type the number of dots you see on each falling dice.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: type your answer") + ("</li></ul>")
  credit: ""
  section: "computer keyboard math numeration"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8"
}
