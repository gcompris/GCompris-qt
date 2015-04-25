/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "awele/Awele.qml"
  difficulty: 2
  icon: "awele/awele.svg"
  author: "Frédéric Mazzarol"
  demo: true
  title: qsTr("Oware")
  description: qsTr("Play the Oware strategy game against Tux")
  goal: qsTr("The object of the game is to capture more seeds than one's opponent. Since the game has only 48 seeds, capturing 25 is sufficient to accomplish this. Since there are an even number of seeds, it is possible for the game to end in a draw, where each player has captured 24. The game is over when one player has captured 25 or more seeds, or both players have taken 24 seeds each (draw). If both players agree that the game has been reduced to an endless cycle, each player captures the seeds on their side of the board.")
  prerequisite: ""
  manual: qsTr("At the beginning of the game four seeds are placed in each house. Players take turns moving the seeds. In each turn, a player chooses one of the six houses under his or her control. The player removes all seeds from this house, and distributes them, dropping one in each house counter-clockwise from the original house, in a process called sowing. Seeds are not distributed into the end scoring houses, nor into the house drawn from. That is, the starting house is left empty; if it contained 12 seeds, it is skipped, and the twelfth seed is placed in the next house. After a turn, if the last seed was placed into an opponent's house and brought its total to two or three, all the seeds in that house are captured and placed in the player's scoring house (or set aside if the board has no scoring houses). If the previous-to-last seed also brought the total seeds in an opponent's house to two or three, these are captured as well, and so on. However, if a move would capture all an opponent's seeds, the capture is forfeited, and the seeds are instead left on the board, since this would prevent the opponent from continuing the game. The proscription against capturing all an opponent's seeds is related to a more general idea, that one ought to make a move that allows the opponent to continue playing. If an opponent's houses are all empty, the current player must make a move that gives the opponent seeds. If no such move is possible, the current player captures all seeds in his/her own territory, ending the game. (Source Wikipedia &lt;http://en.wikipedia.org/wiki/Oware&gt;)")
  credit: ""
  section: "/strategy"
}
