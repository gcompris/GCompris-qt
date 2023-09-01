/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "memory-sound-tux/MemorySoundTux.qml"
  difficulty: 2
  icon: "memory-sound-tux/memory-sound-tux.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Audio memory game against Tux")
  //: Help title
  description: qsTr("Flip the cards to match the sound pairs, playing against Tux.")
//  intro: "Click on an audio card and find its double."
  //: Help goal
  goal: qsTr("Train your audio memory.")
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
