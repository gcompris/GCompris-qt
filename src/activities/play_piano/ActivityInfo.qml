/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "play_piano/PlayPiano.qml"
  difficulty: 1
  icon: "play_piano/play_piano.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Play piano")
  description: ""
  //intro: "Click on the keyboard keys that match the notes that you see and hear"
  //: Help goal
  goal: qsTr("Understand how the piano keyboard can play music as written on the musical staff.")
  //: Help prerequisite
  prerequisite: qsTr("Knowledge of musical notation and musical staff.")
  //: Help manual
  manual: qsTr("Some notes are played on the staff. Click on the keyboard keys matching the notes on the staff.") + ("<br>") +
          qsTr("On levels 1 to 5 you will practice treble clef notes and on levels 6 to 10 you will practice bass clef notes.") + ("<br><br>") +
            qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
            qsTr("Space: play") + ("</li><li>") +
            qsTr("Digits 1 to 7: white keys") + ("</li><li>") +
            qsTr("F2 to F7: black keys") + ("</li><li>") +
            qsTr("Backspace or Delete: undo") + ("</li></ul>")
  credit: qsTr("The synthesizer original code is from https://github.com/vsr83/miniSynth")
  section: "discovery music"
  createdInVersion: 9500
}
