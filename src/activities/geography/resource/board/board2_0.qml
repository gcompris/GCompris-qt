/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
    property string instruction: qsTr("North America")
    property var levels: [
    {
        "pixmapfile": "northamerica/north_america.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "northamerica/usa.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/usa.$CA",
        "toolTipText": qsTr("United States of America"),
        "x": "0.3422",
        "y": "0.5581"
    },
    {
        "pixmapfile": "northamerica/mexico.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/mexico.$CA",
        "toolTipText": qsTr("Mexico"),
        "x": "0.4825",
        "y": "0.8641"
    },
    {
        "pixmapfile": "northamerica/greenland.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/greenland.$CA",
        "toolTipText": qsTr("Greenland"),
        "x": "0.8257",
        "y": "0.1815"
    },
    {
        "pixmapfile": "northamerica/canada.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/canada.$CA",
        "toolTipText": qsTr("Canada"),
        "x": "0.515",
        "y": "0.3138"
    }
    ]
}
