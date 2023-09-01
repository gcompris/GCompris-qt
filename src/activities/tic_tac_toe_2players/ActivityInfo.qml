/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2014 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "tic_tac_toe_2players/Tic_tac_toe_2players.qml"
  difficulty: 2
  icon: "tic_tac_toe_2players/tic_tac_toe_2players.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Tic tac toe (with a friend)")
  //: Help title
  description: qsTr("Place three marks in a row.")
//  intro: "Click on the square which you wish to mark and try to mark 3 consecutive squares before Tux."
  //: Help goal
  goal: qsTr("Place three marks in any horizontal, vertical, or diagonal row to win the game.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Play with a friend. Take turns to click on the square which you want to mark. The first player to create a line of 3 marks wins.")
  credit: ""
  section: "strategy"
  createdInVersion: 4000
}
