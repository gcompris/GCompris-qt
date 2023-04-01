/* GCompris - drawnumbers.qml
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
import "drawnumbers_dataset.js" as Dataset

NumberSequence {
    mode: "drawnumbers"
    dataset: Dataset
    pointImageOpacity: 0
    url: "qrc:/gcompris/src/activities/drawnumbers/resource/"
}

