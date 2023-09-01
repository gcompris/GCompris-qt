/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "chess/Chess.qml"
  difficulty: 6
  icon: "chess/chess.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Play chess (against Tux)")
  description: ""
  //intro: "play chess against Tux"
  goal: ""
  prerequisite: ""
  //: Help manual
  //: Much of this string is shared across the three activities "chess", "chess_partyend", and "chess_2players".
  manual: qsTr("In this activity you discover the chess game by playing against the computer. It displays the possible target positions for any selected piece which helps the children understand how pieces moves. At first level the computer is fully random to give more chances to the children. As level increases, the computer plays better. You can use the arrow buttons to manually select the difficulty level.
\nYou can achieve a mate sooner if you follow these simple rules:
    Trying to drive your opponent's king in the corner.
<b>Explanation</b>: this way your opponent's king would have only 3 directions to move instead of 8 from a better position.
    'Making a trap'. Use your pawns as baits.
<b>Explanation</b>: this way you can lure your opponent out of his 'comfort zone'.
    Be patient enough.
<b>Explanation</b>: don't rush too quick, be patient. Let yourself think a little bit and try to predict your opponent's future moves, so that you can catch him or secure your pieces from his attacks.") + ("<br><br>") + qsTr("Single click on undo button will undo one move. Single click on redo button will redo one move. To undo all the moves, press and hold the undo button for 3 seconds.")
  credit: qsTr("The chess engine is p4wn &lt;https://github.com/douglasbagnall/p4wn&gt;.")
  section: "strategy"
  createdInVersion: 5000
}
