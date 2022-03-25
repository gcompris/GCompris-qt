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
    property string instruction: qsTr("South Asia")
    property var levels: [
    {
        "pixmapfile": "asiasouth/south_asia.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "asiasouth/india.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/india.$CA",
        "toolTipText": qsTr("India"),
        "x": "0.6032",
        "y": "0.4832"
    },
    {
        "pixmapfile": "asiasouth/sri_lanka.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/sri_lanka.$CA",
        "toolTipText": qsTr("Sri Lanka"),
        "x": "0.5512",
        "y": "0.8412"
    },
    {
        "pixmapfile": "asiasouth/pakistan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/pakistan.$CA",
        "toolTipText": qsTr("Pakistan"),
        "x": "0.2369",
        "y": "0.232"
    },
    {
        "pixmapfile": "asiasouth/afghanistan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/afghanistan.$CA",
        "toolTipText": qsTr("Afghanistan"),
        "x": "0.2038",
        "y": "0.137"
    },
    {
        "pixmapfile": "asiasouth/nepal.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/nepal.$CA",
        "toolTipText": qsTr("Nepal"),
        "x": "0.6391",
        "y": "0.2876"
    },
    {
        "pixmapfile": "asiasouth/bangladesh.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/bangladesh.$CA",
        "toolTipText": qsTr("Bangladesh"),
        "x": "0.8041",
        "y": "0.4143"
    },
    {
        "pixmapfile": "asiasouth/bhutan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/bhutan.$CA",
        "toolTipText": qsTr("Bhutan"),
        "x": "0.8064",
        "y": "0.3113"
    },
    {
        "pixmapfile": "asiasouth/maldives.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/maldives.$CA",
        "toolTipText": qsTr("Maldives"),
        "x": "0.356",
        "y": "0.9539"
    }
    ]
}
