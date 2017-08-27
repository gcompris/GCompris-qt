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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-math-add/MemoryMathAdd.qml"
  difficulty: 3
  icon: "memory-math-add/memory-math-add.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Addition memory game")
  //: Help title
  description: qsTr("Turn the cards over to find two numbers which add up the same, until all the cards are gone.")
//  intro: "Turn over two cards to match the calculation with its answer."
  //: Help goal
  goal: qsTr("Practice adding up, until all the cards are gone.")
  //: Help prerequisite
  prerequisite: qsTr("Addition")
  //: Help manual
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding an adding-up sum, or the answer to the sum.
An adding-up sum looks like this: 2 + 2 = 4
The numbers on one side of the equals sign (=) have to be the same as the number on the other side. So 2 (1, 2) and 2 more (3, 4) makes 4. Count aloud when you work this out, and count on your fingers, because the more ways you do something, the better you remember it. You can also use blocks, or buttons, or anything you can count. If you have lots of brothers and sisters, you can count them! Or the kids in your class at school. Sing counting songs. Count lots of things, for practice, and you'll be very good at adding-up!

In this game, these cards are hiding the two parts of an adding-up sum (also called an addition sum). You need to find the two parts of the sum, and bring them together again. Click on a card to see what number it's hiding, then try to find the other card that goes with it, to make a whole sum. You can only turn over two cards in one go, so you need to remember where the numbers are hiding, then you can match them when you find their other half. You're doing the job of the equals sign, and the numbers need you to put them together and make a proper sum. When you do that, both those cards disappear! When you've made them all disappear, found all the sums, you've won the game!")
  credit: ""
  section: "math memory"
}
