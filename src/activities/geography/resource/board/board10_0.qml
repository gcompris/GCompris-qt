/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
    property string instruction: qsTr("Oceania")
    property var levels: [
    {
        "pixmapfile": "oceania/bg_oceania.png",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "oceania/pitcairn_islands.png",
        "soundFile": "voices-$CA/$LOCALE/geography/pitcairn_islands.$CA",
        "toolTipText": qsTr("Pitcairn Islands"),
        "x": "0.967",
        "y": "0.722"
    },
    {
        "pixmapfile": "oceania/french_polynesia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/french_polynesia.$CA",
        "toolTipText": qsTr("French Polynesia"),
        "x": "0.875",
        "y": "0.622"
    },
    {
        "pixmapfile": "oceania/papua_new_guinea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/papua_new_guinea.$CA",
        "toolTipText": qsTr("Papua New Guinea"),
        "x": "0.314",
        "y": "0.476"
    },
    {
        "pixmapfile": "oceania/east_timor.png",
        "soundFile": "voices-$CA/$LOCALE/geography/east_timor.$CA",
        "toolTipText": qsTr("East Timor"),
        "x": "0.131",
        "y": "0.516"
    },
    {
        "pixmapfile": "oceania/indonesia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/indonesia.$CA",
        "toolTipText": qsTr("Indonesia"),
        "x": "0.128",
        "y": "0.456"
    },
    {
        "pixmapfile": "oceania/palau.png",
        "soundFile": "voices-$CA/$LOCALE/geography/palau.$CA",
        "toolTipText": qsTr("Palau"),
        "x": "0.179",
        "y": "0.35"
    },
    {
        "pixmapfile": "oceania/northern_mariana_islands.png",
        "soundFile": "voices-$CA/$LOCALE/geography/northern_mariana_islands.$CA",
        "toolTipText": qsTr("Northern Mariana Islands"),
        "x": "0.288",
        "y": "0.222"
    },
    {
        "pixmapfile": "oceania/micronesia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/micronesia.$CA",
        "toolTipText": qsTr("Micronesia"),
        "x": "0.334",
        "y": "0.324"
    },
    {
        "pixmapfile": "oceania/vanuatu.png",
        "soundFile": "voices-$CA/$LOCALE/geography/vanuatu.$CA",
        "toolTipText": qsTr("Vanuatu"),
        "x": "0.487",
        "y": "0.582"
    },
    {
        "pixmapfile": "oceania/tuvalu.png",
        "soundFile": "voices-$CA/$LOCALE/geography/tuvalu.$CA",
        "toolTipText": qsTr("Tuvalu"),
        "x": "0.572",
        "y": "0.484"
    },
    {
        "pixmapfile": "oceania/tonga.png",
        "soundFile": "voices-$CA/$LOCALE/geography/tonga.$CA",
        "toolTipText": qsTr("Tonga"),
        "x": "0.626",
        "y": "0.608"
    },
    {
        "pixmapfile": "oceania/new_caledonia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/new_caledonia.$CA",
        "toolTipText": qsTr("New Caledonia"),
        "x": "0.451",
        "y": "0.628"
    },
    {
        "pixmapfile": "oceania/marshall_islands.png",
        "soundFile": "voices-$CA/$LOCALE/geography/marshall_islands.$CA",
        "toolTipText": qsTr("Marshall Islands"),
        "x": "0.49",
        "y": "0.344"
    },
    {
        "pixmapfile": "oceania/kiribati.png",
        "soundFile": "voices-$CA/$LOCALE/geography/kiribati.$CA",
        "toolTipText": qsTr("Kiribati"),
        "x": "0.676",
        "y": "0.448"
    },
    {
        "pixmapfile": "oceania/fiji.png",
        "soundFile": "voices-$CA/$LOCALE/geography/fiji.$CA",
        "toolTipText": qsTr("Fiji"),
        "x": "0.569",
        "y": "0.586"
    },
    {
        "pixmapfile": "oceania/solomon_islands.png",
        "soundFile": "voices-$CA/$LOCALE/geography/solomon_islands.$CA",
        "toolTipText": qsTr("Solomon Islands"),
        "x": "0.438",
        "y": "0.506"
    },
    {
        "pixmapfile": "oceania/new_zealand.png",
        "soundFile": "voices-$CA/$LOCALE/geography/new_zealand.$CA",
        "toolTipText": qsTr("New Zealand"),
        "x": "0.572",
        "y": "0.726"
    },
    {
        "pixmapfile": "oceania/cook_islands.png",
        "soundFile": "voices-$CA/$LOCALE/geography/cook_islands.$CA",
        "toolTipText": qsTr("Cook Islands"),
        "x": "0.745",
        "y": "0.582"
    },
    {
        "pixmapfile": "oceania/american_samoa.png",
        "soundFile": "voices-$CA/$LOCALE/geography/american_samoa.$CA",
        "toolTipText": qsTr("American Samoa"),
        "x": "0.662",
        "y": "0.544"
    },
    {
        "pixmapfile": "oceania/australia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/australia.$CA",
        "toolTipText": qsTr("Australia"),
        "x": "0.273",
        "y": "0.748"
    },
    {
        "pixmapfile": "oceania/us_minor.png",
        "soundFile": "voices-$CA/$LOCALE/geography/us_minor.$CA",
        "toolTipText": qsTr("United States Minor Outlying Islands"),
        "x": "0.617",
        "y": "0.258"
    },
    {
        "pixmapfile": "oceania/hawaii.png",
        "soundFile": "voices-$CA/$LOCALE/geography/hawaii.$CA",
        "toolTipText": qsTr("Hawaii"),
        "x": "0.722",
        "y": "0.164"
    }
    ]
}
