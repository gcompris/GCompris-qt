/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "photo_hunter/PhotoHunter.qml"
  difficulty: 2
  icon: "photo_hunter/photo_hunter.svg"
  author: "Stefan Toncu &lt;stefan.toncu29@gmail.com&gt;"
  //: Activity title
  title: qsTr("Photo hunter")
  //: Help title
  description: qsTr("Find the differences between the two pictures.")
  //intro: "look at the two pictures carefully and click where you see a difference"
  //: Help goal
  goal: qsTr("Visual perception.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Observe the two pictures carefully. There are some slight differences. When you find a difference you must click on it.")
  credit: ""
  section: "fun"
  createdInVersion: 6000
}
