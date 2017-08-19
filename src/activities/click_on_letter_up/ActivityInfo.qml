/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
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
  name: "click_on_letter_up/ClickOnLetterUp.qml"
  difficulty: 2
  icon: "click_on_letter_up/click_on_letter_up.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  demo: true
  //: Activity title
  title: qsTr("Click on an uppercase letter")
  //: Help title
  description: qsTr("Listen to a letter and click on the right one")
//  intro: "Click on the required letter. You can listen to it again by clicking on the mouth."
  //: Help goal
  goal: qsTr("Letter-name recognition")
  //: Help prerequisite
  prerequisite: qsTr("Visual letter-recognition.")
  //: Help manual
  manual: qsTr("A letter is spoken. Click on the matching letter in the main area. You can listen to the letter again, by clicking on the mouth icon in the bottom box.")
  credit: ""
  section: "reading"
}
