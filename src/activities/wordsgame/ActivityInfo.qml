/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "wordsgame/Wordsgame.qml"
  difficulty: 2
  icon: "wordsgame/wordsgame.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  //: Activity title
  title: qsTr("Falling words")
  //: Help title
  description: qsTr("Type the falling words before they reach the ground.")
//  intro: "Type the words on your keyboard before they reach the ground."
  //: Help goal
  goal: qsTr("Keyboard training.")
  //: Help prerequisite
  prerequisite: qsTr("Keyboard manipulation.")
  //: Help manual
  manual: qsTr("Type the complete word as it falls, before it reaches the ground.")
  credit: ""
  section: "computer keyboard reading words"
  createdInVersion: 0
}
