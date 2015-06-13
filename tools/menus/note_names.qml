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
  name: "note_names/NoteNames.qml"
  difficulty: 4
  icon: "note_names/note_names.svg"
  author: "Beth Hadley &lt;bethmhadley@gmail.com&gt;"
  demo: true
  title: qsTr("Name that Note!")
  description: qsTr("Learn the names of the notes, in bass and treble clef, with the help of sounds and colors")
  goal: qsTr("To develop a good understanding of note position and naming convention. To prepare for the piano player and composition activity")
  prerequisite: qsTr("None")
  manual: qsTr("The first level and the eleventh level introduce two different staffs with a C major scale. The following levels then quiz the player on note names. To help learn the names, the note pitches are played when the mouse is rolled over the note, and the pitch names can be color coded.
        ")
  credit: ""
  section: "/discovery/sound_group"
}
