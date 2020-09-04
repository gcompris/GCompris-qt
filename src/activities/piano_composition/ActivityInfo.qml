/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
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
  name: "piano_composition/Piano_composition.qml"
  difficulty: 2
  icon: "piano_composition/piano_composition.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Piano Composition")
  //: Help title
  description: qsTr("Learn how the piano keyboard works, and how notes are written on a musical staff.")
  //intro: "Learn to compose piano music using the octaves and the tools presented above the staff."
  //: Help goal
  goal: qsTr("Develop an understanding of music composition, and increase interest in making music with a piano keyboard. This activity covers many fundamental aspects of music, but there is much more to explore about music composition. If you enjoy this activity but want a more advanced tool, try downloading Minuet (https://minuet.kde.org/), an open source software for music education or MuseScore (https://musescore.org), an open source music notation tool.")
  //: Help prerequisite
  prerequisite: qsTr("Familiarity with note naming conventions.")
  //: Help manual
  manual: qsTr("This activity has several levels, each level adding a new functionality to the previous one.") + ("<ul><li>") +
  qsTr("Level 1: Basic piano keyboard (white keys only) where users can experiment with clicking the colored rectangle keys to write music.") + ("</li><li>") +
  qsTr("Level 2: The musical staff switches to bass clef, so notes are lower than in previous level.") + ("</li><li>") +
  qsTr("Level 3: Option to choose between treble and bass clef, addition of black keys (sharp keys).") + ("</li><li>") +
  qsTr("Level 4: Flat notation used for black keys.") + ("</li><li>") +
  qsTr("Level 5: Option to select a note duration (whole, half, quarter, eighth notes).") + ("</li><li>") +
  qsTr("Level 6: Addition of rests (whole, half, quarter, eighth rests)") + ("</li><li>") +
  qsTr("Level 7: Save your compositions and load pre-defined or saved melodies.") + ("</li></ul>") +
    qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
    qsTr("Digits 1 to 7: white keys") + ("</li><li>") +
    qsTr("F2 to F7: black keys") + ("</li><li>") +
    qsTr("Space: play") + ("</li><li>") +
    qsTr("Left and Right arrows: switch keyboard octave") + ("</li><li>") +
    qsTr("Backspace: undo") + ("</li><li>") +
    qsTr("Delete: erase selected note or everything") + ("</li></ul>")
  credit: qsTr("The synthesizer original code is from https://github.com/vsr83/miniSynth")
  section: "discovery music"
  createdInVersion: 9500
}
