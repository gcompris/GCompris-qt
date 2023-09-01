/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Manuel Tondeur <manueltondeur@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "gnumch-multiples/GnumchMultiples.qml"
  difficulty: 3
  icon: "gnumch-multiples/gnumch-multiples.svg"
  author: "Manuel Tondeur &lt;manueltondeur@gmail.com&gt;"
  //: Activity title
  title: qsTr("Gnumch multiples")
  //: Help title
  description: qsTr("Guide the Number Muncher to all the multiples of the number at the bottom of the screen.")
//  intro: "Guide the number eater with the arrow keys to the multiples of the displayed number and press space to swallow them."
  //: Help goal
  goal: qsTr("Learn about multiples and factors.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("The multiples of a number are all the numbers that are equal to the original number times another number. For example, 24, 36, 48 and 60 are all multiples of 12. 25 is not a multiple of 12 because there isn't any number that can be multiplied by 12 to get 25. If one number is a factor of a second number, then the second number is a multiple of the first number. You can think of multiples as families, and factors are the people who belong to those families. The factor 5, has parents 10, grandparents 15, great-grandparents 20, great-great-grandparents 25, and every extra step of 5 is another great- in front! But the number 5 does not belong to the 8 or 23 families. You can't fit any number of 5s into 8 or 23 with nothing left over. So 8 isn't a multiple of 5, nor is 23. Only 5, 10, 15, 20, 25 ... are multiples (or families or steps) of 5.") +
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
