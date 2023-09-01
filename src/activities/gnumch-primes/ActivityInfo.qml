/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Manuel Tondeur <manueltondeur@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "gnumch-primes/GnumchPrimes.qml"
  difficulty: 6
  icon: "gnumch-primes/gnumch-primes.svg"
  author: "Manuel Tondeur &lt;manueltondeur@gmail.com&gt;"
  //: Activity title
  title: qsTr("Gnumch primes")
  //: Help title
  description: qsTr("Guide the Number Muncher to all the prime numbers.")
//  intro: "Guide the number eater with the arrow keys to the prime numbers and press space to swallow them."
  //: Help goal
  goal: qsTr("Learn about prime numbers.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Prime numbers are numbers that are only divisible by themselves and 1. For example, 3 is a prime number, but 4 isn't (because 4 is divisible by 2). You can think of prime numbers as very small families: they only ever have two people in them! Only themselves and 1. You can't fit any other numbers into them with nothing left over. 5 is one of these lonely numbers (only 5 × 1 = 5), but you can see that 6 has 2 and 3 in its family as well (6 × 1 = 6, 2 × 3 = 6). So 6 is not a prime number.") +
          "<br><br>" +
          qsTr("If you have a keyboard you can use the arrow keys to move and press space to swallow the numbers. With a mouse you can click on the block next to your position to move and click again to swallow the numbers. With a touch screen you can do like with a mouse or swipe anywhere in the direction you want to move and tap to swallow the numbers.") +
          "<br><br>" +
          qsTr("Take care to avoid the Troggles.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space: swallow the numbers") + ("</li></ul>")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 0
}
