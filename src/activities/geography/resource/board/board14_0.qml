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
    property string instruction: qsTr("Oceania")
    property var levels: [
    {
        "pixmapfile": "oceania/oceania.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "oceania/pitcairn_islands.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/pitcairn_islands.$CA",
        "toolTipText": qsTr("Pitcairn Islands"),
        "x": "0.959",
        "y": "0.6008"
    },
    {
        "pixmapfile": "oceania/french_polynesia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/french_polynesia.$CA",
        "toolTipText": qsTr("French Polynesia"),
        "x": "0.8278",
        "y": "0.529"
    },
    {
        "pixmapfile": "oceania/papua_new_guinea.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/papua_new_guinea.$CA",
        "toolTipText": qsTr("Papua New Guinea"),
        "x": "0.3067",
        "y": "0.4013"
    },
    {
        "pixmapfile": "oceania/palau.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/palau.$CA",
        "toolTipText": qsTr("Palau"),
        "x": "0.186",
        "y": "0.2731"
    },
    {
        "pixmapfile": "oceania/mariana_islands.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/mariana_islands.$CA",
        "toolTipText": qsTr("Mariana Islands"),
        "x": "0.2826",
        "y": "0.1488"
    },
    {
        "pixmapfile": "oceania/micronesia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/micronesia.$CA",
        "toolTipText": qsTr("Micronesia"),
        "x": "0.3207",
        "y": "0.2725"
    },
    {
        "pixmapfile": "oceania/nauru.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/nauru.$CA",
        "toolTipText": qsTr("Nauru"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.4508",
        "y": "0.3376"
    },
    {
        "pixmapfile": "oceania/vanuatu.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/vanuatu.$CA",
        "toolTipText": qsTr("Vanuatu"),
        "x": "0.4616",
        "y": "0.5123"
    },
    {
        "pixmapfile": "oceania/tuvalu.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/tuvalu.$CA",
        "toolTipText": qsTr("Tuvalu"),
        "x": "0.5365",
        "y": "0.42"
    },
    {
        "pixmapfile": "oceania/tonga.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/tonga.$CA",
        "toolTipText": qsTr("Tonga"),
        "x": "0.5798",
        "y": "0.5471"
    },
    {
        "pixmapfile": "oceania/new_caledonia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/new_caledonia.$CA",
        "toolTipText": qsTr("New Caledonia"),
        "x": "0.4469",
        "y": "0.5549"
    },
    {
        "pixmapfile": "oceania/marshall_islands.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/marshall_islands.$CA",
        "toolTipText": qsTr("Marshall Islands"),
        "x": "0.4474",
        "y": "0.2282"
    },
    {
        "pixmapfile": "oceania/kiribati.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/kiribati.$CA",
        "toolTipText": qsTr("Kiribati"),
        "x": "0.6275",
        "y": "0.3684"
    },
    {
        "pixmapfile": "oceania/fiji.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/fiji.$CA",
        "toolTipText": qsTr("Fiji"),
        "x": "0.5386",
        "y": "0.5179"
    },
    {
        "pixmapfile": "oceania/solomon_islands.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/solomon_islands.$CA",
        "toolTipText": qsTr("Solomon Islands"),
        "x": "0.4189",
        "y": "0.4286"
    },
    {
        "pixmapfile": "oceania/new_zealand.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/new_zealand.$CA",
        "toolTipText": qsTr("New Zealand"),
        "x": "0.5416",
        "y": "0.7056"
    },
    {
        "pixmapfile": "oceania/cook_islands.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/cook_islands.$CA",
        "toolTipText": qsTr("Cook Islands"),
        "x": "0.6955",
        "y": "0.4998"
    },
    {
        "pixmapfile": "oceania/samoan_islands.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/samoan_islands.$CA",
        "toolTipText": qsTr("Samoan Islands"),
        "x": "0.6266",
        "y": "0.4696"
    },
    {
        "pixmapfile": "oceania/australia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/australia.$CA",
        "toolTipText": qsTr("Australia"),
        "x": "0.248",
        "y": "0.6444"
    },
    {
        "pixmapfile": "oceania/us_minor.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/us_minor.$CA",
        "toolTipText": qsTr("United States Minor Outlying Islands"),
        "x": "0.578",
        "y": "0.177"
    },
    {
        "pixmapfile": "oceania/hawaii.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/hawaii.$CA",
        "toolTipText": qsTr("Hawaii"),
        "x": "0.6568",
        "y": "0.0715"
    },
    {
        "pixmapfile": "oceania/wallis_and_futuna.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/wallis_and_futuna.$CA",
        "toolTipText": qsTr("Wallis and Futuna"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.5745",
        "y": "0.4802"
    }
    ]
}
