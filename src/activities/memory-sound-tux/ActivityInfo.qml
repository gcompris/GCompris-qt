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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-sound-tux/MemorySoundTux.qml"
  difficulty: 2
  icon: "memory-sound-tux/memory-sound-tux.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Audio memory game against Tux")
  //: Help title
  description: qsTr("Play the audio memory game against Tux")
//  intro: "Click on an audio card and find its double."
  //: Help goal
  goal: qsTr("Train your audio memory and remove all the cards.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("A set of cards is shown. Each card has an associated sound, and each sound has a twin exactly the same. Click on a card to hear its hidden sound, and try to match the twins. You can only activate two cards at once, so you need to remember where a sound is, while you listen to its twin. When you turn over the twins, they both disappear.")
  credit: ""
  section: "discovery memory music"
}
