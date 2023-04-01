/* GCompris - drawletters.qml
 *
 * SPDX-FileCopyrightText: 2016 NITISH CHAUHAN <nitish.nc18@gmail.com>
 *
 * Authors:
 *
 *   Nitish Chauhan <nitish.nc18@gmail.com> (Qt Quick port)
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../number_sequence"
import "drawletters_dataset.js" as Dataset

NumberSequence {
    mode: "drawletters"
    dataset: Dataset
    pointImageOpacity: 0
    url: "qrc:/gcompris/src/activities/drawletters/resource/"
}


