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
    property string instruction: qsTr("Central America")
    property var levels: [
    {
        "pixmapfile": "centralamerica/central_america.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "centralamerica/puerto_rico.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/puerto_rico.$CA",
        "toolTipText": qsTr("Puerto Rico"),
        "x": "0.8305",
        "y": "0.4622"
    },
    {
        "pixmapfile": "centralamerica/panama.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/panama.$CA",
        "toolTipText": qsTr("Panama"),
        "x": "0.5227",
        "y": "0.929"
    },
    {
        "pixmapfile": "centralamerica/nicaragua.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/nicaragua.$CA",
        "toolTipText": qsTr("Nicaragua"),
        "x": "0.4018",
        "y": "0.717"
    },
    {
        "pixmapfile": "centralamerica/mexico.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/mexico.$CA",
        "toolTipText": qsTr("Mexico"),
        "x": "0.1863",
        "y": "0.3187"
    },
    {
        "pixmapfile": "centralamerica/jamaica.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/jamaica.$CA",
        "toolTipText": qsTr("Jamaica"),
        "x": "0.5874",
        "y": "0.4677"
    },
    {
        "pixmapfile": "centralamerica/honduras.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/honduras.$CA",
        "toolTipText": qsTr("Honduras"),
        "x": "0.3825",
        "y": "0.6279"
    },
    {
        "pixmapfile": "centralamerica/haiti.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/haiti.$CA",
        "toolTipText": qsTr("Haiti"),
        "x": "0.6835",
        "y": "0.4227"
    },
    {
        "pixmapfile": "centralamerica/guatemala.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/guatemala.$CA",
        "toolTipText": qsTr("Guatemala"),
        "x": "0.2919",
        "y": "0.579"
    },
    {
        "pixmapfile": "centralamerica/el_salvador.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/salvador.$CA",
        "toolTipText": qsTr("El Salvador"),
        "x": "0.322",
        "y": "0.673"
    },
    {
        "pixmapfile": "centralamerica/dominican_republic.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/dominican_republic.$CA",
        "toolTipText": qsTr("Dominican Republic"),
        "x": "0.7494",
        "y": "0.4366"
    },
    {
        "pixmapfile": "centralamerica/cuba.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/cuba.$CA",
        "toolTipText": qsTr("Cuba"),
        "x": "0.5363",
        "y": "0.306"
    },
    {
        "pixmapfile": "centralamerica/costa_rica.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/costa_rica.$CA",
        "toolTipText": qsTr("Costa Rica"),
        "x": "0.4286",
        "y": "0.871"
    },
    {
        "pixmapfile": "centralamerica/belize.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/belize.$CA",
        "toolTipText": qsTr("Belize"),
        "x": "0.3311",
        "y": "0.5121"
    },
    {
        "pixmapfile": "centralamerica/bahamas.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/bahamas.$CA",
        "toolTipText": qsTr("Bahamas"),
        "x": "0.6195",
        "y": "0.1912"
    }
    ]
}
