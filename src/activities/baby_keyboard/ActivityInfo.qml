/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
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
  name: "baby_keyboard/Baby_keyboard.qml"
  difficulty: 1
  icon: "baby_keyboard/baby_keyboard.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Baby keyboard")
  //: Help title
  description: qsTr("A simple activity to discover the keyboard.")
  //intro: "Type any key on the keyboard and observe the result."
  //: Help goal
  goal: qsTr("Discover the keyboard")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Type any key on the keyboard.
    Letters, numbers and other character keys will display the corresponding character on the screen.
    If there is a corresponding voice it will be played, else it will play a bleep sound.
    Other keys will just play a click sound.")
  credit: ""
  section: "computer keyboard letters numeration"
  createdInVersion: 9800
}
