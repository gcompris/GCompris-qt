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
    property string instruction: qsTr("Western Europe")
    property var levels: [
    {
        "pixmapfile": "europe/europe.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "europe/united_kingdom.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/united_kingdom.$CA",
        "toolTipText": qsTr("United Kingdom"),
        "x": "0.3055",
        "y": "0.4317"
    },
    {
        "pixmapfile": "europe/switzerland.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/switz.$CA",
        "toolTipText": qsTr("Switzerland"),
        "x": "0.4653",
        "y": "0.6595"
    },
    {
        "pixmapfile": "europe/sweden.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/sweden.$CA",
        "toolTipText": qsTr("Sweden"),
        "x": "0.5974",
        "y": "0.253"
    },
    {
        "pixmapfile": "europe/spain.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/spain.$CA",
        "toolTipText": qsTr("Spain"),
        "x": "0.3159",
        "y": "0.842"
    },
    {
        "pixmapfile": "europe/portugal.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/portugal.$CA",
        "toolTipText": qsTr("Portugal"),
        "x": "0.2404",
        "y": "0.8505"
    },
    {
        "pixmapfile": "europe/norway.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/norway.$CA",
        "toolTipText": qsTr("Norway"),
        "x": "0.6006",
        "y": "0.1899"
    },
    {
        "pixmapfile": "europe/netherlands.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/netherland.$CA",
        "toolTipText": qsTr("The Netherlands"),
        "x": "0.4241",
        "y": "0.5172"
    },
    {
        "pixmapfile": "europe/luxembourg.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/luxembourg.$CA",
        "toolTipText": qsTr("Luxembourg"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.4358",
        "y": "0.5802"
    },
    {
        "pixmapfile": "europe/italy.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/italy.$CA",
        "toolTipText": qsTr("Italy"),
        "x": "0.5261",
        "y": "0.7894"
    },
    {
        "pixmapfile": "europe/ireland.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/ireland.$CA",
        "toolTipText": qsTr("Ireland"),
        "x": "0.2354",
        "y": "0.4847"
    },
    {
        "pixmapfile": "europe/iceland.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/iceland.$CA",
        "toolTipText": qsTr("Iceland"),
        "x": "0.0841",
        "y": "0.1797"
    },
    {
        "pixmapfile": "europe/germany.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/germany.$CA",
        "toolTipText": qsTr("Germany"),
        "x": "0.4964",
        "y": "0.5442"
    },
    {
        "pixmapfile": "europe/france.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/france.$CA",
        "toolTipText": qsTr("France"),
        "x": "0.3838",
        "y": "0.6743"
    },
    {
        "pixmapfile": "europe/finland.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/finland.$CA",
        "toolTipText": qsTr("Finland"),
        "x": "0.7154",
        "y": "0.1804"
    },
    {
        "pixmapfile": "europe/denmark.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/denmark.$CA",
        "toolTipText": qsTr("Denmark"),
        "x": "0.5131",
        "y": "0.4117"
    },
    {
        "pixmapfile": "europe/belgium.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/belgium.$CA",
        "toolTipText": qsTr("Belgium"),
        "x": "0.4125",
        "y": "0.5618"
    },
    {
        "pixmapfile": "europe/austria.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/austria.$CA",
        "toolTipText": qsTr("Austria"),
        "x": "0.537",
        "y": "0.6358"
    }
    ]
}
