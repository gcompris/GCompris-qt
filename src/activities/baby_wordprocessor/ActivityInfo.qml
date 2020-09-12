/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
  name: "baby_wordprocessor/BabyWordprocessor.qml"
  difficulty: 1
  icon: "baby_wordprocessor/baby_wordprocessor.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("A baby word processor")
  //: Help title
  description: qsTr("A simplistic word processor to let the children play around with a keyboard and see letters.")
  //intro: "A simplistic word processor to play around with the keyboard"
  //: Help goal
  goal: qsTr("Discover the keyboard and the letters.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Just type on the real or virtual keyboard like in a word processor.
    Clicking on the 'Title' button will make the text bigger. Similarly, the 'subtitle' button will make the text slightly less bigger. Clicking on 'paragraph' will remove the formatting.")+ ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate inside the text") + ("</li><li>") +
          qsTr("Shift + Arrows: select a part of the text") + ("</li><li>") +
          qsTr("Ctrl + A: select all the text") + ("</li><li>") +
          qsTr("Ctrl + C: copy selected text") + ("</li><li>") +
          qsTr("Ctrl + X: cut selected text") + ("</li><li>") +
          qsTr("Ctrl + V: paste copied or cut text") + ("</li><li>") +
          qsTr("Ctrl + D: delete selected text") + ("</li><li>") +
          qsTr("Ctrl + Z: undo") + ("</li><li>") +
          qsTr("Ctrl + Shift + Z: redo") + ("</li></ul>")
  credit: ""
  section: "computer keyboard reading letters"
  createdInVersion: 6000
}
