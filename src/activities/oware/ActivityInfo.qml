/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "oware/Oware.qml"
  difficulty: 2
  icon: "oware/oware.svg"
  author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;"
  //: Activity title
  title: qsTr("Play oware (against Tux)")
  //: Help title
  description: qsTr("Play the Oware strategy game against Tux.")
  //intro: "Capture at least 25 seeds to win the game"
  //: Help goal
  goal: qsTr("The game starts with four seeds in each house. The objective of the game is to capture more seeds than one's opponent. Since the game has only 48 seeds, capturing 25 is sufficient to win the game. Since there is an even number of seeds, it is possible for the game to end in a draw, where each player has captured 24.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Players take turns moving the seeds. On a turn, a player chooses one of the six houses under their control. The player removes all seeds from that house, and distributes them, dropping one in each house counter-clockwise from this house, in a process called sowing. Seeds are not distributed into the end scoring houses, nor into the house drawn from. The starting house is always left empty; if it contained 12 (or more) seeds, it is skipped, and the twelfth seed is placed in the next house.") + ("<br/><br/>") +
  qsTr("Capturing occurs only when a player brings the count of an opponent's house to exactly two or three with the final seed he sowed in that turn. This always captures the seeds in the corresponding house, and possibly more: if the previous-to-last seed also brought an opponent's house to two or three, these are captured as well, and so on until a house is reached which does not contain two or three seeds or does not belong to the opponent. The captured seeds are placed in the player's scoring house. However, if a move would capture all of an opponent's seeds, the capture is forfeited since this would prevent the opponent from continuing the game, and the seeds are instead left on the board.") + ("<br/><br/>") +
  qsTr("If an opponent's houses are all empty, the current player must make a move that gives the opponent seeds. If no such move is possible, the current player captures all seeds in their own territory, ending the game.")
  credit: ""
  section: "strategy"
  createdInVersion: 20000
}
