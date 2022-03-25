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
    property string instruction: qsTr("South America")
    property var levels: [
    {
        "pixmapfile": "southamerica/south_america.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "southamerica/venezuela.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/venezuela.$CA",
        "toolTipText": qsTr("Venezuela"),
        "x": "0.4436",
        "y": "0.1261"
    },
    {
        "pixmapfile": "southamerica/uruguay.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/uruguay.$CA",
        "toolTipText": qsTr("Uruguay"),
        "x": "0.6247",
        "y": "0.6696"
    },
    {
        "pixmapfile": "southamerica/suriname.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/suriname.$CA",
        "toolTipText": qsTr("Suriname"),
        "x": "0.6207",
        "y": "0.1612"
    },
    {
        "pixmapfile": "southamerica/peru.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/peru.$CA",
        "toolTipText": qsTr("Peru"),
        "x": "0.3027",
        "y": "0.3442"
    },
    {
        "pixmapfile": "southamerica/paraguay.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/paraguay.$CA",
        "toolTipText": qsTr("Paraguay"),
        "x": "0.5801",
        "y": "0.5427"
    },
    {
        "pixmapfile": "southamerica/panama.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/panama.$CA",
        "toolTipText": qsTr("Panama"),
        "x": "0.2173",
        "y": "0.0985"
    },
    {
        "pixmapfile": "southamerica/guyana.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/guyana.$CA",
        "toolTipText": qsTr("Guyana"),
        "x": "0.5719",
        "y": "0.1478"
    },
    {
        "pixmapfile": "southamerica/french_guiana.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/french_guiana.$CA",
        "toolTipText": qsTr("French Guiana"),
        "x": "0.6691",
        "y": "0.1607"
    },
    {
        "pixmapfile": "southamerica/ecuador.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/ecuador.$CA",
        "toolTipText": qsTr("Ecuador"),
        "x": "0.1614",
        "y": "0.2405"
    },
    {
        "pixmapfile": "southamerica/colombia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/colombia.$CA",
        "toolTipText": qsTr("Colombia"),
        "x": "0.3372",
        "y": "0.1587"
    },
    {
        "pixmapfile": "southamerica/chile.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/chile.$CA",
        "toolTipText": qsTr("Chile"),
        "x": "0.3412",
        "y": "0.728"
    },
    {
        "pixmapfile": "southamerica/brazil.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/brazil.$CA",
        "toolTipText": qsTr("Brazil"),
        "x": "0.6478",
        "y": "0.4146"
    },
    {
        "pixmapfile": "southamerica/bolivia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/bolivia.$CA",
        "toolTipText": qsTr("Bolivia"),
        "x": "0.4943",
        "y": "0.4433"
    },
    {
        "pixmapfile": "southamerica/argentina.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/argentina.$CA",
        "toolTipText": qsTr("Argentina"),
        "x": "0.4935",
        "y": "0.752"
    }
    ]
}
