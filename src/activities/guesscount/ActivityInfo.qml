/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
  name: "guesscount/Guesscount.qml"
  difficulty: 1
  icon: "guesscount/guesscount.svg"
  author: "Rahul Yadav &lt;rahulyadav170923@gmail.com&gt;"
  demo: true
  title: qsTr("Guessing the algebraic expression for the answer")
  description:qsTr("guess the algebraic expression and click on the buttons to add them.")
  //intro: "guesscount activity"
  goal: qsTr("To teach algebra")
  prerequisite: qsTr("knowledge of arithematic oprations")
  manual: ""
  credit: ""
  section: "math"
  createdInVersion:1
}
