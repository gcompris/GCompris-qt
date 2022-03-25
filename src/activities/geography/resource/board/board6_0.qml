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
    property string instruction: qsTr("Eastern Europe")
    property var levels: [
    {
        "pixmapfile": "europe/europe.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "europe/cyprus.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/cyprus.$CA",
        "toolTipText": qsTr("Cyprus"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.8147",
        "y": "0.9745"
    },
    {
        "pixmapfile": "europe/greece.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/greece.$CA",
        "toolTipText": qsTr("Greece"),
        "x": "0.6854",
        "y": "0.8831"
    },
    {
        "pixmapfile": "europe/ukraine.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/ukraine.$CA",
        "toolTipText": qsTr("Ukraine"),
        "x": "0.7861",
        "y": "0.6181"
    },
    {
        "pixmapfile": "europe/turkey.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/turkey.$CA",
        "toolTipText": qsTr("Turkey"),
        "x": "0.8437",
        "y": "0.8666"
    },
    {
        "pixmapfile": "europe/slovenia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/slovenia.$CA",
        "type": "SHAPE_BACKGROUND",
        "toolTipText": qsTr("Slovenia"),
        "x": "0.5595",
        "y": "0.6768"
    },
    {
        "pixmapfile": "europe/slovakia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/slovakia.$CA",
        "toolTipText": qsTr("Slovak Republic"),
        "x": "0.6261",
        "y": "0.6099"
    },
    {
        "pixmapfile": "europe/montenegro.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/montenegro.$CA",
        "toolTipText": qsTr("Montenegro"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.6218",
        "y": "0.7677"
    },
    {
        "pixmapfile": "europe/serbia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/serbia.$CA",
        "toolTipText": qsTr("Serbia"),
        "x": "0.643",
        "y": "0.7332"
    },
    {
        "pixmapfile": "europe/russia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/russia.$CA",
        "toolTipText": qsTr("Russia"),
        "x": "0.8336",
        "y": "0.4277"
    },
    {
        "pixmapfile": "europe/romania.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/romania.$CA",
        "toolTipText": qsTr("Romania"),
        "x": "0.6999",
        "y": "0.6816"
    },
    {
        "pixmapfile": "europe/poland.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/poland.$CA",
        "toolTipText": qsTr("Poland"),
        "x": "0.6179",
        "y": "0.5241"
    },
    {
        "pixmapfile": "europe/moldova.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/moldova.$CA",
        "toolTipText": qsTr("Moldova"),
        "x": "0.7475",
        "y": "0.6552"
    },
    {
        "pixmapfile": "europe/north_macedonia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/macedonia.$CA",
        "toolTipText": qsTr("North Macedonia"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.6545",
        "y": "0.7968"
    },
    {
        "pixmapfile": "europe/lithuania.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/lithuania.$CA",
        "toolTipText": qsTr("Lithuania"),
        "x": "0.684",
        "y": "0.4389"
    },
    {
        "pixmapfile": "europe/latvia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/latvia.$CA",
        "toolTipText": qsTr("Latvia"),
        "x": "0.6948",
        "y": "0.3937"
    },
    {
        "pixmapfile": "europe/hungary.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/hungary.$CA",
        "toolTipText": qsTr("Hungary"),
        "x": "0.6231",
        "y": "0.6502"
    },
    {
        "pixmapfile": "europe/estonia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/estonia.$CA",
        "toolTipText": qsTr("Estonia"),
        "x": "0.7003",
        "y": "0.3483"
    },
    {
        "pixmapfile": "europe/czechia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/czechia.$CA",
        "toolTipText": qsTr("Czechia"),
        "x": "0.5667",
        "y": "0.5801"
    },
    {
        "pixmapfile": "europe/croatia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/croatia.$CA",
        "toolTipText": qsTr("Croatia"),
        "x": "0.5807",
        "y": "0.7208"
    },
    {
        "pixmapfile": "europe/bulgaria.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/bulgaria.$CA",
        "toolTipText": qsTr("Bulgaria"),
        "x": "0.7068",
        "y": "0.7668"
    },
    {
        "pixmapfile": "europe/bosnia_herzegovina.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/bosnia_herzegovina.$CA",
        "toolTipText": qsTr("Bosnia Herzegovina"),
        "x": "0.5975",
        "y": "0.7357"
    },
    {
        "pixmapfile": "europe/belarus.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/belarus.$CA",
        "toolTipText": qsTr("Belarus"),
        "x": "0.7415",
        "y": "0.4772"
    },
    {
        "pixmapfile": "europe/albania.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/albania.$CA",
        "toolTipText": qsTr("Albania"),
        "x": "0.6325",
        "y": "0.8088"
    }
    ]
}
