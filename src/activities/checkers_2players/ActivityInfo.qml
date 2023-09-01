/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2017 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "checkers_2players/Checkers2Players.qml"
    difficulty: 4
    icon: "checkers_2players/checkers_2players.svg"
    author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
    //: Activity title
    title: qsTr("Play checkers (with a friend)")
    //: Help title
    description: qsTr("The version in GCompris is the international draughts.")
    //intro: "play checkers with your friend"
    //: Help goal
    goal: qsTr("Capture all the pieces of your opponent before your opponent captures all of yours.")
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
