/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
  name: "play_rhythm/PlayRhythm.qml"
  difficulty: 3
  icon: "play_rhythm/play_rhythm.svg"
  author: "Beth Hadley &lt;bethmhadley@gmail.com&gt;"
  demo: true
  title: qsTr("Play Rhythm")
  description: qsTr("Learn to listen to, read, and play musical rhythms.")
  goal: qsTr("Learn to beat rhythms precisely and accurately based on what you see and hear.")
  prerequisite: qsTr("Simple understanding of musical rhythm and beat.")
  manual: qsTr("This is a relatively challenging game to master, so good luck.

Listen to the rhythm played, and follow along with the music. If you would like to hear it again, click the play button. When you're ready to perform the identical rhythm, click the drum to the rhythm, then click the OK button. If you clicked correctly and in the right tempo, another rhythm is displayed. If not, you must try again.

Even levels display a vertical playing line when you click the drum, which helps you see when to click to follow the rhythm. Click on the drum when the line is in the middle of the notes.

Odd levels are harder, because there is no vertical playing line. The rhythm will not be played for you. You must read the rhythm, and click it back in tempo. Click the metronome to hear the quarter note tempo.

The following keyboard bindings work in this game:
- backspace: erase attempt
- delete: erase attempt
- enter/return: OK button
- space bar: play
")
  credit: ""
  section: "/discovery/sound_group"
}
