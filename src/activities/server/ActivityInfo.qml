/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "server/Server.qml"
  difficulty: 2
  icon: "server/server.svg"
  author: "Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  //: Activity title
  title: qsTr("Server")
  //: Help title
  description: qsTr("Server.")
//  intro: "Click on the domino and validate your choice with the OK button to indicate the number of ice blocks Tux will have to follow to eat a fish."
  //: Help goal
  goal: qsTr("Server.")
  //: Help prerequisite
  prerequisite: qsTr("Can read numbers on a domino.")
  //: Help manual
  manual: qsTr("Click on the domino to show how many ice spots there are between Tux and the fish. Click the domino with the right mouse button to count backwards. When done, click on the OK button or hit the Enter key.")
  credit: ""
  section: "strategy"
  createdInVersion: 5000
}
