/* gcompris - AlphabetSequence.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 Bruno Coudoin: initial Gtk+ version

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
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
