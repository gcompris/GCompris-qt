/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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
  name: "note_names/NoteNames.qml"
  difficulty: 4
  icon: "note_names/note_names.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Name that Note")
  //: Help title
  description: qsTr("Learn the names of the notes, in bass and treble clef.")
  //intro: "Identify the note and press the correct piano key"
  //: Help goal
  goal: qsTr("To develop a good understanding of note position and naming convention. To prepare for the piano player and composition activity.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Identify the notes correctly and score a 100% to complete a level.")
  credit: ""
  section: "discovery music"
  createdInVersion: 9500
}
