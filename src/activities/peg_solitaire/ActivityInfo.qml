/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "peg_solitaire/PegSolitaire.qml"
  difficulty: 4
  icon: "peg_solitaire/peg_solitaire.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Peg solitaire")
  //: Help title
  description: qsTr("Remove all the pieces in the correct order until only one remains.")
  //intro: "Remove all the pieces in the correct order until only one remains."
  //: Help goal
  goal: qsTr("Develop anticipation and spatial visualization skills.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("To move a piece, make it jump another one in an orthogonal direction, to a hole two positions away. The jumped piece is removed from the board. You can click on a movable piece and then on its destination, or drag and drop it to its destination. The game is over when no more piece can be moved, and is won if only one piece remains. If the option to use the default starting hole is not selected, you need to choose the first piece to remove by clicking on it. You can use the undo button to undo your last move, and the redo button to redo it.")
  credit: ""
  section: "logic"
  createdInVersion: 270000
}
