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
  name: "play_rhythm/PlayRhythm.qml"
  difficulty: 1
  icon: "play_rhythm/play_rhythm.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Play rhythm")
  description: ""
  //intro: "Click the drum to recreate the rhythm"
  //: Help goal
  goal: qsTr("Learn to follow a rhythm accurately.")
  //: Help prerequisite
  prerequisite: qsTr("Simple understanding of musical rhythm.")
  //: Help manual
  manual: qsTr("Listen to the rhythm played. When you're ready, click on the drum following the same rhythm. If you clicked at correct times, another rhythm is played. If not, you must try again.") + ("<br>") +
          qsTr("Odd levels display a vertical line on the staff following the rhythm: click on the drum when the line is in the middle of the notes.") + ("<br>") +
          qsTr("Even levels are harder, because there is no vertical line. You must read the notes length and play the rhythm accordingly. You can also click on the metronome to hear the quarter notes as reference.") + ("<br>") +
          qsTr("Click on the reload button if you want to replay the rhythm.") + ("<br><br>") +
            qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
            qsTr("Space bar: click on the drum") + ("</li><li>") +
            qsTr("Enter or Return: replay the rhythm") + ("</li><li>") +
            qsTr("Up and Down: increase or decrease the tempo") + ("</li><li>") +
            qsTr("Tab: Start or stop the metronome if it is visible") + ("</li></ul>")
  credit: ""
  section: "discovery music"
  createdInVersion: 9500
}
