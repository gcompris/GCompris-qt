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
  name: "memory-sound/MemorySound.qml"
  difficulty: 2
  icon: "memory-sound/memory-sound.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  //: Activity title
  title: qsTr("Audio memory game")
  //: Help title
  description: qsTr("Flip the cards to match the sound pairs.")
//  intro: "Click on an audio card and find its double."
  //: Help goal
  goal: qsTr("Train your audio memory.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Each card plays a sound when you flip it, and each card has a twin with exactly the same sound. Click on a card to hear its hidden sound, and try to match the twins. You can only flip two cards at once, so you need to remember where a sound is, while you search for its twin. When you flip the twins, they both disappear.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "discovery memory music"
  createdInVersion: 0
}
