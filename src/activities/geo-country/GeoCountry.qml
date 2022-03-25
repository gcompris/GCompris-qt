/* GCompris - GeoCountry.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Jean-Philippe Ayanides <jp.ayanides@free.fr> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../babymatch"

Babymatch {
    id: activity

    onStart: focus = true
    onStop: {}
    useMultipleDataset: true
    boardsUrl: "qrc:/gcompris/src/activities/geo-country/resource/"
    answerGlow: false
}
