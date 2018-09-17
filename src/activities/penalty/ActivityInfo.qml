/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Stephane Mankowski <stephane@mankowski.fr>
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
  name: "penalty/Penalty.qml"
  difficulty: 1
  icon: "penalty/penalty.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  demo: true
  //: Activity title
  title: qsTr("Penalty kick")
  //: Help title
  description: qsTr("Double click or double tap on any side of the goal in order to score.")
  // intro: "Double click or double tap on the goal, in order to score."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Double click or double tap on a side of the goal to kick the ball. " +
               "You can double click the left right or middle mouse button. " +
               "If you do not click fast enough, Tux catches the ball. " +
               "You must click on it to bring it back to its former position.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
