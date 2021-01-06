/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "reversecount/Reversecount.qml"
  difficulty: 2
  icon: "reversecount/reversecount.svg"
  author: "Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  //: Activity title
  title: qsTr("Count intervals")
  //: Help title
  description: qsTr("Tux is hungry. Help him find fish by counting to the correct ice spot.")
//  intro: "Click on the domino and validate your choice with the OK button to indicate the number of ice blocks Tux will have to follow to eat a fish."
  //: Help goal
  goal: qsTr("Tux is hungry. Help him find fish by counting to the correct ice spot.")
  //: Help prerequisite
  prerequisite: qsTr("Can read numbers on a domino.")
  //: Help manual
  manual: qsTr("Click on the domino to show how many ice spots there are between Tux and the fish. Click the domino with the right mouse button to count backwards. When done, click on the OK button or hit the Enter key.")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8,9,10,11,12"
}
