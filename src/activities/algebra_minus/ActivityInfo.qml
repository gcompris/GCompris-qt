/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
  name: "algebra_minus/AlgebraMinus.qml"
  difficulty: 4
  icon: "algebra_minus/algebra_minus.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Subtraction of numbers")
  //: Help title
  description: qsTr("Practice the subtraction operation")
//  intro: "Subtract the two numbers and type in your answer before the balloon lands in the water"
  //: Help goal
  goal: qsTr("Learn to find the difference between two numbers within a limited period of time")
  //: Help prerequisite
  prerequisite: qsTr("Subtraction of small numbers")
  //: Help manual
  manual: qsTr("A subtraction is displayed on the screen. Quickly find the result and use your computer's keyboard or the on-screen keypad to type it. You have to be fast and submit the answer before the penguins in their balloon land!")
  credit: ""
  section: "math subtraction arithmetic"
  createdInVersion: 0
}
