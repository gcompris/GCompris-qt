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
    property string instruction: qsTr("East Asia")
    property var levels: [
    {
        "pixmapfile": "asiaeast/east_asia.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "asiaeast/japan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/japan.$CA",
        "toolTipText": qsTr("Japan"),
        "x": "0.8317",
        "y": "0.5323"
    },
    {
        "pixmapfile": "asiaeast/china.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/china.$CA",
        "toolTipText": qsTr("China"),
        "x": "0.4211",
        "y": "0.5046"
    },
    {
        "pixmapfile": "asiaeast/mongolia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/mongolia.$CA",
        "toolTipText": qsTr("Mongolia"),
        "x": "0.4163",
        "y": "0.2109"
    },
    {
        "pixmapfile": "asiaeast/north_korea.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/north_korea.$CA",
        "toolTipText": qsTr("North Korea"),
        "x": "0.7345",
        "y": "0.3854"
    },
    {
        "pixmapfile": "asiaeast/south_korea.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/south_korea.$CA",
        "toolTipText": qsTr("South Korea"),
        "x": "0.7473",
        "y": "0.5047"
    },
    {
        "pixmapfile": "asiaeast/taiwan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/taiwan.$CA",
        "toolTipText": qsTr("Taiwan"),
        "x": "0.635",
        "y": "0.8353"
    }
    ]
}
