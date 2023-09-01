/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "chess_partyend/ChessPartyEnd.qml"
  difficulty: 6
  icon: "chess_partyend/chess_partyend.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("End of chess game")
  //: Help title
  description: qsTr("Play the end of the chess game against Tux.")
  //intro: "Click on a white chess piece and green boxes will appear to indicate all the movements that piece can make. Try and get the black king into checkmate."
  goal: ""
  prerequisite: ""
  //: Help manual
  //: Much of this string is shared across the three activities "chess", "chess_partyend", and "chess_2players".
  manual: qsTr("In this activity you discover the chess game by playing only the end of a game. It displays the possible target positions for any selected piece which helps the children understand how pieces moves.
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
