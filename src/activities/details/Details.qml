/* GCompris - Details.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (bruno.coudoin@gcompris.net) / Andre Connes (andre.connes@toulouse.iufm.fr) (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com>  (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../babymatch"

Babymatch {
    id: activity
    useMultipleDataset: true
    onStart: focus = true
    onStop: {}

    boardsUrl: "qrc:/gcompris/src/activities/details/resource/"
    answerGlow: false
    levelCount: 21
    displayDropCircle: false
}
