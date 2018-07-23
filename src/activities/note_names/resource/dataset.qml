/* GCompris - dataset.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 **/
import QtQuick 2.6

QtObject {
    property var levels: [
        [
            "E3Quarter G3Quarter B3Quarter E3Quarter G3Quarter B3Quarter E3Quarter G3Quarter B3Quarter",
            "F3Quarter A3Quarter D4Quarter F3Quarter A3Quarter D4Quarter F3Quarter A3Quarter D4Quarter",
            "C4Quarter E4Quarter B3Quarter C4Quarter E4Quarter B3Quarter C4Quarter E4Quarter B3Quarter"
        ],
        [
            "C4Quarter F4Quarter C5Quarter C4Quarter F4Quarter C5Quarter C4Quarter F4Quarter C5Quarter",
            "D4Quarter G4Quarter B4Quarter D4Quarter G4Quarter B4Quarter D4Quarter G4Quarter B4Quarter",
            "C4Quarter E4Quarter A4Quarter C4Quarter E4Quarter A4Quarter C4Quarter E4Quarter A4Quarter"
        ],
        [
            "C5Quarter F5Quarter C6Quarter C5Quarter F5Quarter C6Quarter C5Quarter F5Quarter C6Quarter",
            "D5Quarter G5Quarter B5Quarter D5Quarter G5Quarter B5Quarter D5Quarter G5Quarter B5Quarter",
            "C5Quarter E5Quarter A5Quarter C5Quarter E5Quarter A5Quarter C5Quarter E5Quarter A5Quarter"
        ],
        [
            "F5Quarter E6Quarter B5Quarter F5Quarter E6Quarter B5Quarter F5Quarter E6Quarter B5Quarter",
            "C6Quarter D6Quarter F6Quarter C6Quarter D6Quarter F6Quarter C6Quarter D6Quarter F6Quarter",
            "E6Quarter A5Quarter C6Quarter E6Quarter A5Quarter C6Quarter E6Quarter A5Quarter C6Quarter"
        ],
        [
            "F#3Quarter G3Quarter C#4Quarter F#3Quarter G3Quarter C#4Quarter F#3Quarter G3Quarter C#4Quarter",
            "F3Quarter G#3Quarter A#3Quarter F3Quarter G#3Quarter A#3Quarter F3Quarter G#3Quarter A#3Quarter",
            "D#4Quarter F#3Quarter B3Quarter D#4Quarter F#3Quarter B3Quarter D#4Quarter F#3Quarter B3Quarter"
        ],
        [
            "D#4Quarter F4Quarter G#4Quarter D#4Quarter F4Quarter G#4Quarter D#4Quarter F4Quarter G#4Quarter",
            "F#4Quarter G4Quarter C#4Quarter F#4Quarter G4Quarter C#4Quarter F#4Quarter G4Quarter C#4Quarter",
            "C5Quarter A#4Quarter D#4Quarter C5Quarter A#4Quarter D#4Quarter C5Quarter A#4Quarter D#4Quarter"
        ],
        [
            "C5Quarter D#5Quarter A#5Quarter C5Quarter D#5Quarter A#5Quarter C5Quarter D#5Quarter A#5Quarter",
            "F#5Quarter G5Quarter C#5Quarter F#5Quarter G5Quarter C#5Quarter F#5Quarter G5Quarter C#5Quarter",
            "C6Quarter G#5Quarter D#5Quarter C6Quarter G#5Quarter D#5Quarter C6Quarter G#5Quarter D#5Quarter"
        ],
        [
            "F5Quarter F#5Quarter G#5Quarter F5Quarter F#5Quarter G#5Quarter F5Quarter F#5Quarter G#5Quarter",
            "A#5Quarter D#6Quarter F6Quarter A#5Quarter D#6Quarter F6Quarter A#5Quarter D#6Quarter F6Quarter",
            "E6Quarter C#6Quarter C6Quarter E6Quarter C#6Quarter C6Quarter E6Quarter C#6Quarter C6Quarter"
        ],
        [
            "Gb3Quarter G3Quarter Db4Quarter Gb3Quarter G3Quarter Db4Quarter Gb3Quarter G3Quarter Db4Quarter",
            "F3Quarter Ab3Quarter Bb3Quarter F3Quarter Ab3Quarter Bb3Quarter F3Quarter Ab3Quarter Bb3Quarter",
            "Eb4Quarter Gb3Quarter B3Quarter Eb4Quarter Gb3Quarter B3Quarter Eb4Quarter Gb3Quarter B3Quarter"
        ],
        [
            "Eb4Quarter F4Quarter Ab4Quarter Eb4Quarter F4Quarter Ab4Quarter Eb4Quarter F4Quarter Ab4Quarter",
            "Gb4Quarter G4Quarter Db4Quarter Gb4Quarter G4Quarter Db4Quarter Gb4Quarter G4Quarter Db4Quarter",
            "C5Quarter Eb4Quarter Bb4Quarter C5Quarter Eb4Quarter Bb4Quarter C5Quarter Eb4Quarter Bb4Quarter"
        ],
        [
            "C5Quarter Eb5Quarter Bb5Quarter C5Quarter Eb5Quarter Bb5Quarter C5Quarter Eb5Quarter Bb5Quarter",
            "Gb5Quarter G5Quarter Db5Quarter Gb5Quarter G5Quarter Db5Quarter Gb5Quarter G5Quarter Db5Quarter",
            "C6Quarter Eb5Quarter Ab5Quarter C6Quarter Eb5Quarter Ab5Quarter C6Quarter Eb5Quarter Ab5Quarter"
        ],
        [
            "F5Quarter Gb5Quarter Ab5Quarter F5Quarter Gb5Quarter Ab5Quarter F5Quarter Gb5Quarter Ab5Quarter",
            "Bb5Quarter Eb6Quarter F6Quarter Bb5Quarter Eb6Quarter F6Quarter Bb5Quarter Eb6Quarter F6Quarter",
            "E6Quarter Db6Quarter C6Quarter E6Quarter Db6Quarter C6Quarter E6Quarter Db6Quarter C6Quarter"
        ],
        [
            "C3Quarter F3Quarter C4Quarter C3Quarter F3Quarter C4Quarter C3Quarter F3Quarter C4Quarter",
            "D3Quarter G3Quarter B3Quarter D3Quarter G3Quarter B3Quarter D3Quarter G3Quarter B3Quarter",
            "C3Quarter E3Quarter A3Quarter C3Quarter E3Quarter A3Quarter C3Quarter E3Quarter A3Quarter"
        ],
        [
            "G3Quarter F4Quarter C4Quarter G3Quarter F4Quarter C4Quarter G3Quarter F4Quarter C4Quarter",
            "D4Quarter G4Quarter A3Quarter D4Quarter G4Quarter A3Quarter D4Quarter G4Quarter A3Quarter",
            "G3Quarter E4Quarter B3Quarter G3Quarter E4Quarter B3Quarter G3Quarter E4Quarter B3Quarter"
        ],
        [
            "D#3Quarter F3Quarter G#3Quarter D#3Quarter F3Quarter G#3Quarter D#3Quarter F3Quarter G#3Quarter",
            "F#3Quarter G3Quarter C#3Quarter F#3Quarter G3Quarter C#3Quarter F#3Quarter G3Quarter C#3Quarter",
            "C4Quarter A#3Quarter D#3Quarter C4Quarter A#3Quarter D#3Quarter C4Quarter A#3Quarter D#3Quarter"
        ],
        [
            "G#3Quarter F4Quarter C#4Quarter G#3Quarter F4Quarter C#4Quarter G#3Quarter F4Quarter C#4Quarter",
            "D4Quarter A#3Quarter F#4Quarter D4Quarter A#3Quarter F#4Quarter D4Quarter A#3Quarter F#4Quarter",
            "D#4Quarter E4Quarter B3Quarter D#4Quarter E4Quarter B3Quarter D#4Quarter E4Quarter B3Quarter"
        ],
        [
            "Eb3Quarter F3Quarter Ab3Quarter Eb3Quarter F3Quarter Ab3Quarter Eb3Quarter F3Quarter Ab3Quarter",
            "Gb3Quarter G3Quarter Db3Quarter Gb3Quarter G3Quarter Db3Quarter Gb3Quarter G3Quarter Db3Quarter",
            "C4Quarter Eb3Quarter Bb3Quarter C4Quarter Eb3Quarter Bb3Quarter C4Quarter Eb3Quarter Bb3Quarter"
        ],
        [
            "Ab3Quarter F4Quarter Db4Quarter Ab3Quarter F4Quarter Db4Quarter Ab3Quarter F4Quarter Db4Quarter",
            "D4Quarter Bb3Quarter Gb4Quarter D4Quarter Bb3Quarter Gb4Quarter D4Quarter Bb3Quarter Gb4Quarter",
            "Eb4Quarter E4Quarter B3Quarter Eb4Quarter E4Quarter B3Quarter Eb4Quarter E4Quarter B3Quarter"
        ]
    ]
}
