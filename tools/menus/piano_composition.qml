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
  name: "piano_composition/PianoComposition.qml"
  difficulty: 4
  icon: "piano_composition/piano_composition.svg"
  author: "Beth Hadley &lt;bethmhadley@gmail.com&gt;"
  demo: true
  title: qsTr("Piano Composition")
  description: qsTr("An activity to learn how the piano keyboard works, how notes are written on a musical staff and explore music composition by loading and saving your work.")
  goal: qsTr("Develop an understanding of music composition, and increase interest in making music with a piano keyboard. This activity covers many fundamental aspects of music, but there is much more to explore about music composition. If you enjoy this activity but want a more advanced tool, try downloading MuseScore (http://musescore.org/en/download), an open source music notation tool.")
  prerequisite: qsTr("Familiarity with note naming conventions, note-names activity useful to learn this notation.")
  manual: qsTr("This activity has several levels, each level adds a new functionality to the previous level.
Level 1: basic piano keyboard (white keys only) and students can experiment with clicking the colored rectangle keys to write music
Level 2: the musical staff switches to bass clef, so pitches are lower than in previous level
Level 3: option to choose between treble and bass clef, additional function includes option to select note duration (quarter, half, and whole notes)
Level 4: addition of black keys (sharp keys)
Level 5: flat notation used for black keys
Level 6: load children's melodies from around the world
Level 7: all features available, with the additional feature to load and save your composition

The following keyboard bindings work in this activity:
- backspace: erase one note
- delete: erase all notes
- space bar: play composition
- number keys:
  1: C
  2: D
  3: E
  4: F
  5: G
  6: A
  7: B
  8: C (higher octave)
  etc.
  F1: C# / Db
  F2: D# / Eb
  F3: F# / Gb
  F4: G# / Ab
  F5: A# / Bb
")
  credit: qsTr("
Thank you to Bruno Coudoin for his mentorship.
Thank you to Olivier Samyn for his contribution to improving the note design and coloring.
Thank you to Federico Mena who inspired me with his wonderful enthusiasm for my music projects at GUADEC.
Thank you to all contributors of children's songs from around the world, especially the GNOME community. Learn more about these
melodies and who contributed them here: https://live.gnome.org/GComprisMelodies
")
  section: "/discovery/sound_group"
}
