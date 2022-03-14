/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bharath M S <brat.197@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "align4_2players/Align42players.qml"
  difficulty: 2
  icon: "align4_2players/align4_2players.svg"
  author: "Bharath M S &lt;brat.197@gmail.com&gt;"
  //: Activity title
  title: qsTr("Align four (with a friend)")
  //: Help title
  description: qsTr("Arrange four tokens in a row.")
//  intro: "Click on the column where you wish your token to fall and try to align 4 tokens to win."
  //: Help goal
  goal: qsTr("Create a line of 4 tokens either horizontally (lying down), vertically (standing up) or diagonally.")
  //: Help manual
  manual: qsTr("Play with a friend. Take turns to click the line in which you want to drop a token. The first player to create a line of 4 tokens wins.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Left arrow: move the token to the left") + ("</li><li>") +
          qsTr("Right arrow: move the token to the right") + ("</li><li>") +
          qsTr("Space or Down arrow: drop the token") + ("</li></ul>")
  credit: ""
  section: "strategy"
  createdInVersion: 0
}
