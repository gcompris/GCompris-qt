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
  name: "play_rhythm/PlayRhythm.qml"
  difficulty: 1
  icon: "play_rhythm/play_rhythm.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Play rhythm")
  //: Help title
  description: ""
  //intro: "Click the drum to recreate the rhythm"
  //: Help goal
  goal: qsTr("Learn to beat rhythms precisely and accurately based on what you see and hear.")
  //: Help prerequisite
  prerequisite: qsTr("Simple understanding of musical rhythm and beat.")
  //: Help manual
  manual: qsTr("Listen to the rhythm played, and follow along with the music. When you're ready to perform the identical rhythm, click the drum to the rhythm. If you clicked tempo at correct times, another rhythm is displayed. If not, you must try again.<br>Odd levels display a vertical playing line when you click the drum, which helps you see when to click, to follow the rhythm. Click on the drum when the line is in the middle of the notes.<br>Even levels are harder, because there is no vertical playing line. You must read the rhythm, and click it back in tempo. Click the metronome to hear the quarter note tempos.<br>Click on the reload button to replay the rhythm.")
  credit: ""
  section: "discovery music"
  createdInVersion: 9500
}
