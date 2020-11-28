/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "readingh/Readingh.qml"
  difficulty: 2
  icon: "readingh/readingh.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Horizontal reading practice")
  //: Help title
  description: qsTr("Read a list of words and say if a given word is in it.")
//  intro: "Read a list of words and say if a given word is in it."
  //: Help goal
  goal: qsTr("Reading training in a limited time.")
  //: Help prerequisite
  prerequisite: qsTr("Reading.")
  //: Help manual
  manual: qsTr("A word is shown on the board. A list of words, displayed horizontally, will appear and disappear. Did the given word appear in the list?")
  credit: ""
  section: "reading words"
  createdInVersion: 5000
}
