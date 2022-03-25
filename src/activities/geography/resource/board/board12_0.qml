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
    property string instruction: qsTr("Southeast Asia")
    property var levels: [
    {
        "pixmapfile": "asiasoutheast/southeast_asia.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "asiasoutheast/singapore.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/singapore.$CA",
        "toolTipText": qsTr("Singapore"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.2497",
        "y": "0.6795"
    },
    {
        "pixmapfile": "asiasoutheast/indonesia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/indonesia.$CA",
        "toolTipText": qsTr("Indonesia"),
        "x": "0.5307",
        "y": "0.7724"
    },
    {
        "pixmapfile": "asiasoutheast/myanmar.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/myanmar.$CA",
        "toolTipText": qsTr("Myanmar"),
        "x": "0.1082",
        "y": "0.2438"
    },
    {
        "pixmapfile": "asiasoutheast/thailand.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/thailand.$CA",
        "toolTipText": qsTr("Thailand"),
        "x": "0.2037",
        "y": "0.3945"
    },
    {
        "pixmapfile": "asiasoutheast/laos.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/laos.$CA",
        "toolTipText": qsTr("Laos"),
        "x": "0.2505",
        "y": "0.2681"
    },
    {
        "pixmapfile": "asiasoutheast/vietnam.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/vietnam.$CA",
        "toolTipText": qsTr("Vietnam"),
        "x": "0.2881",
        "y": "0.3228"
    },
    {
        "pixmapfile": "asiasoutheast/cambodia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/cambodia.$CA",
        "toolTipText": qsTr("Cambodia"),
        "x": "0.2718",
        "y": "0.4058"
    },
    {
        "pixmapfile": "asiasoutheast/malaysia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/malaysia.$CA",
        "toolTipText": qsTr("Malaysia"),
        "x": "0.3604",
        "y": "0.6116"
    },
    {
        "pixmapfile": "asiasoutheast/brunei.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/brunei.$CA",
        "toolTipText": qsTr("Brunei"),
        "x": "0.4637",
        "y": "0.6012"
    },
    {
        "pixmapfile": "asiasoutheast/east_timor.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/east_timor.$CA",
        "toolTipText": qsTr("East Timor"),
        "x": "0.68",
        "y": "0.9263"
    },
    {
        "pixmapfile": "asiasoutheast/philippines.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/philippines.$CA",
        "toolTipText": qsTr("Philippines"),
        "x": "0.6034",
        "y": "0.3961"
    }
    ]
}
