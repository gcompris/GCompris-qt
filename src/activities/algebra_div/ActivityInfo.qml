/* GCompris - ActivityInfo.qml
 * 
 * Copyright (C) 2015 Sayan Biswas <techsayan01@gmail.com>
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
      name: "algebra_div/AlgebraDiv.qml"
      difficulty: 4
      icon: "algebra_div/algebra_div.svg"
      author: "Sayan Biswas <techsayan01@gmail.com>"
      demo: false
      title: qsTr("Division of numbers")
      description: qsTr("Practice the division operation")
    //  intro: "Subtract the two numbers and type in your answer before the balloon landing"
      goal: qsTr("Learn to find the difference between two numbers within a limited period of time")
      prerequisite: qsTr("Division of small numbers")
      manual: qsTr("Two numbers are displayed on the screen. Quickly find the division between them and use your computer's keyboard or the on-screen keypad to type it (ignore the decimal part). You have to be fast and submit the answer before the penguins in their balloon land!")
      credit: ""
      section: "math division"
    }