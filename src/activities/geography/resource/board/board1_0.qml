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
    property string instruction: qsTr("Continents")
    property var levels: [
    {
        "pixmapfile": "continents/back.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "continents/oceania.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/oceania.$CA",
        "toolTipText": qsTr("Oceania"),
        "x": "0.8694",
        "y": "0.6471"
    },
    {
        "pixmapfile": "continents/europa.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/europe.$CA",
        "toolTipText": qsTr("Europe"),
        "x": "0.4851",
        "y": "0.1488"
    },
    {
        "pixmapfile": "continents/asia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/asia.$CA",
        "toolTipText": qsTr("Asia"),
        "x": "0.6814",
        "y": "0.2886"
    },
    {
        "pixmapfile": "continents/antarctica.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/antarctica.$CA",
        "toolTipText": qsTr("Antarctica"),
        "x": "0.4647",
        "y": "0.887"
    },
    {
        "pixmapfile": "continents/america.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/america.$CA",
        "toolTipText": qsTr("America"),
        "x": "0.219",
        "y": "0.4216"
    },
    {
        "pixmapfile": "continents/africa.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/africa.$CA",
        "toolTipText": qsTr("Africa"),
        "x": "0.4782",
        "y": "0.4832"
    }
    ]
}
