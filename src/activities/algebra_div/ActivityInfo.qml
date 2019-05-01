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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
      name: "algebra_div/AlgebraDiv.qml"
      difficulty: 6
      icon: "algebra_div/algebra_div.svg"
      author: "Sayan Biswas &lt;techsayan01@gmail.com&gt;"
      demo: false
      //: Activity title
      title: qsTr("Division of numbers")
      //: Help title
      description: qsTr("Practice the division operation")
    //  intro: "Find the result of the division and type in your answer before the balloon lands in the water"
      //: Help goal
      goal: qsTr("Find the result of the division within a limited period of time")
      //: Help prerequisite
      prerequisite: qsTr("Division of small numbers")
      //: Help manual
      manual: qsTr("A division is displayed on the screen. Quickly find the result and use your computer's keyboard or the on-screen keypad to type it. You have to be fast and submit the answer before the penguins in their balloon land!")
      credit: ""
      section: "math division arithmetic"
      createdInVersion: 4000
}
