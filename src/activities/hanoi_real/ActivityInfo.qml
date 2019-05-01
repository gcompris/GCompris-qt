/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Amit Tomar <a.tomar@outlook.com>
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
  name: "hanoi_real/HanoiReal.qml"
  difficulty: 5
  icon: "hanoi_real/hanoi_real.svg"
  author: "Amit Tomar &lt;a.tomar@outlook.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("The Tower of Hanoi")
  //: Help title
  description: qsTr("Reproduce the tower on the right side")
  //intro: "Rebuild the model tower on the right support. Take care, no disc may be placed atop a smaller disc."
  //: Help goal
  goal: qsTr("The object of the game is to move the entire stack to another peg, obeying the following rules:
    only one disc may be moved at a time
    no disc may be placed atop a smaller disc
")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Drag and drop the top pieces only from one peg to another, to reproduce the initial left side tower on the right peg.")
  credit: qsTr("The puzzle was invented by the French mathematician Edouard Lucas in 1883. There is a legend about a Hindu temple whose priests were constantly engaged in moving a set of 64 discs according to the rules of the Tower of Hanoi puzzle. According to the legend, the world would end when the priests finished their work. The puzzle is therefore also known as the Tower of Brahma puzzle. It is not clear whether Lucas invented this legend or was inspired by it. (source Wikipedia: http://en.wikipedia.org/wiki/Tower_of_hanoi)")
  section: "discovery logic"
  createdInVersion: 4000
}
