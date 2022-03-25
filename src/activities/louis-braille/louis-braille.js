/* GCompris - louis-braille.js
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   <Srishti Sethi> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items

var url = "qrc:/gcompris/src/activities/louis-braille/resource/"

function start(items_) {
    items = items_
    initLevel()
}

function stop() {
}

function initLevel() {
    // Write the sequence in the dataset
    for(var i = 0 ; i < items.dataset.length ; i++)
        items.dataset[i].sequence = i
    items.count = 0
}
