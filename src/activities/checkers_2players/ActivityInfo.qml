/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Johnny Jazeix <jazeix@gmail.com>
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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
    name: "checkers_2players/Checkers2Players.qml"
    difficulty: 4
    icon: "checkers_2players/checkers_2players.svg"
    author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
    demo: true
    //: Activity title
    title: qsTr("Play checkers with your friend")
    //: Help title
    description: qsTr("The version in GCompris is the international draughts.")
    //intro: "play checkers with your friend"
    //: Help goal
    goal: qsTr("Capture all the pieces of your opponent before your opponent captures all of yours.")
    //: Help prerequisite
    prerequisite: ""
    //: Help manual
    manual: qsTr("Checkers is played by two opponents, on opposite sides of the gameboard. One player has the dark pieces; the other has the light pieces. Players alternate turns. A player may not move an opponent's piece. A move consists of moving a piece diagonally to an adjacent unoccupied square. If the adjacent square contains an opponent's piece, and the square immediately beyond it is vacant, the piece may be captured (and removed from the game) by jumping over it.
Only the dark squares of the checkered board are used. A piece may move only diagonally into an unoccupied square. Capturing is mandatory. The player without pieces remaining, or who cannot move due to being blocked, loses the game.
When a man reaches the crownhead or kings row (the farthest row forward), it becomes a king, and is marked by placing an additional piece on top of the first man, and acquires additional powers including the ability to move backwards. If there is a piece in a diagonal that a king can capture, he can move any distance along the diagonal, and may capture an opposing man any distance away by jumping to any of the unoccupied squares immediately beyond it.
")
    credit: qsTr("The checkers library is draughts.js &lt;https://github.com/shubhendusaurabh/draughts.js&gt;. Manual is from wikipedia &lt;https://en.wikipedia.org/wiki/Draughts&gt;")
    section: "strategy"
    createdInVersion: 8000
}
