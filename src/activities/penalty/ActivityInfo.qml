/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Stephane Mankowski <stephane@mankowski.fr>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "penalty/Penalty.qml"
  difficulty: 1
  icon: "penalty/penalty.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  //: Activity title
  title: qsTr("Penalty kick")
  //: Help title
  description: qsTr("Double click or double tap on any side of the goal in order to score.")
  // intro: "Double click or double tap on the goal, in order to score."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Double click or double tap on a side of the goal to kick the ball. " +
               "You can double click the left, right or middle mouse button. " +
               "If you do not double click fast enough, Tux catches the ball. " +
               "You must click on it to bring it back to its initial position.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
