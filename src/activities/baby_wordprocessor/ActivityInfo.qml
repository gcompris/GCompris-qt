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
  demo: false
  //: Activity title
  title: qsTr("A baby wordprocessor")
  //: Help title
  description: qsTr("A simplistic word processor to let the children play around with a keyboard and see letters.")
  //intro: "A simplistic word processor to play around with the keyboard"
  //: Help goal
  goal: qsTr("Discover the keyboard and the letters.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Just type on the real or virtual keyboard like in a wordprocessor.
    Clicking on the 'Title' button will make the text bigger. Similarly, the 'subtitle' button will make the text slightly less bigger. Clicking on 'paragraph' will remove the formatting.
    Press 'Shift' and use the arrow keys to select the text. Use Ctrl+C to copy, Ctrl+V to paste and Crtl+X to cut text. Ctrl+Z can be used to undo changes.
    Try to fiddle around and find more shortcuts. For example, what is the shortcut to select all the text?")
  credit: ""
  section: "computer keyboard reading letters"
  createdInVersion: 6000
}
