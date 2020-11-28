/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "share/Share.qml"
  difficulty: 2
  icon: "share/share.svg"
  author: "Stefan Toncu &lt;stefan.toncu29@gmail.com&gt;"
  //: Activity title
  title: qsTr("Share pieces of candy")
  //: Help title
  description: qsTr("Try to split the pieces of candy between a given number of children.")
  //intro: "Share the candies equally among the specified number of children and notice that there may be a rest left"
  //: Help goal
  goal: qsTr("Learn division of numbers.")
  //: Help prerequisite
  prerequisite: qsTr("Know how to count.")
  //: Help manual
  manual: qsTr("Follow the instructions shown on the screen: first, drag the given number of boys/girls to the center, then drag pieces of candy to each child's rectangle.") + ("<br>") +
    qsTr("If there is a rest, it needs to be placed inside the candy jar.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 7000
  levels :"1,2,3"
}
