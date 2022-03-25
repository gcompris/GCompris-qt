/* GCompris
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (map update svg)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
    property string instruction: qsTr("Central Asia")
    property var levels: [
    {
        "pixmapfile": "asiacentral/central_asia.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "asiacentral/kazakhstan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/kazakhstan.$CA",
        "toolTipText": qsTr("Kazakhstan"),
        "x": "0.5018",
        "y": "0.3945"
    },
    {
        "pixmapfile": "asiacentral/kyrgyzstan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/kyrgyzstan.$CA",
        "toolTipText": qsTr("Kyrgyzstan"),
        "x": "0.6885",
        "y": "0.6963"
    },
    {
        "pixmapfile": "asiacentral/tajikistan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/tajikistan.$CA",
        "toolTipText": qsTr("Tajikistan"),
        "x": "0.6044",
        "y": "0.8015"
    },
    {
        "pixmapfile": "asiacentral/turkmenistan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/turkmenistan.$CA",
        "toolTipText": qsTr("Turkmenistan"),
        "x": "0.3239",
        "y": "0.7962"
    },
    {
        "pixmapfile": "asiacentral/uzbekistan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/uzbekistan.$CA",
        "toolTipText": qsTr("Uzbekistan"),
        "x": "0.4438",
        "y": "0.6901"
    }
    ]
}
