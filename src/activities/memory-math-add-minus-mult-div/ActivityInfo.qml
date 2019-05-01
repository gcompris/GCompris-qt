/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 JB BUTET <ashashiwa@gmail.com>
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
  name: "memory-math-add-minus-mult-div/MemoryMathAddMinusMultDiv.qml"
  difficulty: 6
  icon: "memory-math-add-minus-mult-div/memory-math-add-minus-mult-div.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("All operations memory game")
  //: Help title
  description: qsTr("Turn the cards over to find a matching operation, until all the cards are gone.")
//  intro: "Turn over two cards to match the calculation with its answer."
  //: Help goal
  goal: qsTr("Practice addition, subtraction, multiplication, division, until all the cards are gone.")
  //: Help prerequisite
  prerequisite: qsTr("Addition, subtraction, multiplication, division")
  //: Help manual
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding an operation, or the answer to it.

In this game, these cards are hiding the two parts of an operation. You need to find the two parts of the operation, and bring them together again. Click on a card to see what number it's hiding, then try to find the other card that goes with it, to make a whole operation. You can only turn over two cards in one go, so you need to remember where the numbers are hiding, then you can match them when you find their other half. You're doing the job of the equals sign, and the numbers need you to put them together and make a proper equality. When you do that, both those cards disappear! When you've made them all disappear, found all the operations, you've won the game!")
  credit: ""
  section: "math memory arithmetic"
  createdInVersion: 0
}
