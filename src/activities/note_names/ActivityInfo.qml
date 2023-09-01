/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "note_names/NoteNames.qml"
  difficulty: 4
  icon: "note_names/note_names.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Name that note")
  //: Help title
  description: qsTr("Learn the names of the notes, in bass and treble clef.")
  //intro: "Identify the note and press the correct piano key"
  //: Help goal
  goal: qsTr("Develop a good understanding of note position and naming convention. Prepare for the 'Play Piano' and 'Piano Composition' activities.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Identify the notes correctly and score 100% to complete a level.")
  credit: ""
  section: "discovery music"
  createdInVersion: 9500
}
