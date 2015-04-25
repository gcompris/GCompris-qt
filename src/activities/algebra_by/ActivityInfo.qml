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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "algebra_by/AlgebraBy.qml"
  difficulty: 3
  icon: "algebra_by/algebra_by.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Multiplication of numbers")
  description: qsTr("Practice the multiplication operation")
//  intro: "Multiply the two numbers together and type in your answer before the balloon landing"
  goal: qsTr("Learn to multiply numbers within a limited period of time")
  prerequisite: qsTr("Multiplication tables from 1 to 10")
  manual: qsTr("Two numbers are displayed on the screen. Quickly multiply them and use your computer's keyboard or the on-screen keypad to type the product of the numbers. You have to be fast and submit the answer before the penguins in their balloon land!")
  credit: ""
  section: "math multiplication"
}
