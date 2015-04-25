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
  name: "wordprocessor/Wordprocessor.qml"
  difficulty: 2
  icon: "wordprocessor/wordprocessor.svg"
  author: "Bruno coudoin"
  demo: false
  title: qsTr("Your word processor")
  description: qsTr("A simple word processor to enter and save any text")
  goal: qsTr("Learn how to enter text in a wordprocessor. This wordprocessor is special in that it enforces the use of styles. This way, the children will understand their benefit when moving to more feature full wordprocessor like LibreOffice.")
  prerequisite: qsTr("The children can type their own text or copy one given by the teacher.")
  manual: qsTr("In this wordprocessor you can type the text you want, save and get it back later. You can add some style to your text by using the buttons on the left. The first 4 buttons let you select the style of the line on which your insert cursor is. The 2 others buttons with multiple choices let you select from a predefined document and color theme.")
  credit: ""
  section: "/fun"
}
