/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Amit Tomar <a.tomar@outlook.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "hanoi_real/HanoiReal.qml"
  difficulty: 5
  icon: "hanoi_real/hanoi_real.svg"
  author: "Amit Tomar &lt;a.tomar@outlook.com&gt;"
  //: Activity title
  title: qsTr("The Tower of Hanoi")
  //: Help title
  description: qsTr("Move the tower from the left-hand side onto the right-side peg.")
  //intro: "Rebuild the model tower on the right support. Take care, no disc may be placed atop a smaller disc."
  //: Help goal
  goal: qsTr("Develop strategic thinking.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Drag and drop one top disc at a time, from one tower to another, to reproduce the tower on the left-hand side onto the right-hand side peg. The discs can move back and forth freely on the pegs, following two rules: only one disc can be moved at a time, and a disc can never be placed on a smaller disc.")
  credit: qsTr("The puzzle was invented by the French mathematician Edouard Lucas in 1883. There is a legend about a Hindu temple whose priests were constantly engaged in moving a set of 64 discs according to the rules of the Tower of Hanoi puzzle. According to the legend, the world would end when the priests finished their work. The puzzle is therefore also known as the Tower of Brahma puzzle. It is not clear whether Lucas invented this legend or was inspired by it. (source Wikipedia: https://en.wikipedia.org/wiki/Tower_of_hanoi)")
  section: "discovery logic"
  createdInVersion: 4000
}
