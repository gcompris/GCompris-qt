/* gcompris - AlphabetSequence.qml

 Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>

 Bruno Coudoin: initial Gtk+ version

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.6
import "../planegame"

Planegame {
    id: activity

    // Put here the alphabet in your language, letters separated by: /
    // Supports multigraphs, e.g. /sh/ or /sch/ gets treated as one letter
    property string alphabet: qsTr("a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z");

    dataset: [
        {
            data: activity.alphabet.split("/"),
            showNext: true
        },
        {
            data: activity.alphabet.toUpperCase().split("/"),
            showNext: true
        },
        {
            data: activity.alphabet.split("/"),
            showNext: false
        },
        {
            data: activity.alphabet.toUpperCase().split("/"),
            showNext: false
        }
    ]
}
