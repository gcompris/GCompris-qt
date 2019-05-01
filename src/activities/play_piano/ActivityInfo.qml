/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
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
  name: "play_piano/PlayPiano.qml"
  difficulty: 1
  icon: "play_piano/play_piano.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Play piano")
  //: Help title
  description: ""
  //intro: "Click on the keyboard keys that match the notes that you see and hear"
  //: Help goal
  goal: qsTr("Understand how the piano keyboard can play music as written on the musical staff.")
  //: Help prerequisite
  prerequisite: qsTr("Knowledge of musical notation and musical staff. Play the activity named 'Piano Composition' first.")
  //: Help manual
  manual: qsTr("The notes you see will be played to you. Click on the corresponding keys on the keyboard that match the notes you hear and see.<br>Levels 1-5 will offer treble clef to practice and levels 6-10 will offer bass clef.")
  credit: qsTr("The synthesizer original code is https://github.com/vsr83/miniSynth")
  section: "discovery music"
  createdInVersion: 9500
}
