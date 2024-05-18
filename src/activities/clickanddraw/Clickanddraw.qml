/* GCompris - Clickanddraw.qml
 *
 * SPDX-FileCopyrightText: 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Olivier Ponchaut <opvg@mailoo.org> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import "../number_sequence"
import "clickanddraw_dataset.js" as Dataset

NumberSequence {
    mode: "clickanddraw"
    pointImageOpacity: 0
    dataset: Dataset.get()
    url: "qrc:/gcompris/src/activities/number_sequence/resource/"
}
