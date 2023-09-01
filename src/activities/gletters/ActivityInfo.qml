/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "gletters/Gletters.qml"
  difficulty: 2
  icon: "gletters/gletters.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  //: Activity title
  title: qsTr("Simple letters")
  //: Help title
  description: qsTr("Type the falling letters before they reach the ground.")
//  intro: "Type the letters on your keyboard before they reach the ground."
  //: Help goal
  goal: qsTr("Letter association between the screen and the keyboard.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Type the falling letters before they reach the ground.")
  credit: ""
  section: "computer keyboard reading letters"
  createdInVersion: 0
}
