/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Rahul Yadav <rahulyadav170923@gmail.com>
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
  name: "practice/Practice.qml"
  difficulty: 1
  icon: "practice/practice.svg"
  author: "Rahul Yadav &lt;rahulyadav170923@gmail.com&gt;"
  demo: true
  title: "Practice activity"
  description: qsTr("add the numbers and operators yourself and check if your answer is correct")
  //intro: "put here in comment the text for the intro voice"
  goal: qsTr("to build confidence in children while solving arithematic operations")
  prerequisite: qsTr("arithematic operations")
  manual: ""
  credit: ""
  section: "math"
  createdInVersion:6000
}
