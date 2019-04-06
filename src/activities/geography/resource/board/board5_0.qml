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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
    property string instruction: qsTr("Western Europe")
    property var levels: [
    {
        "pixmapfile": "europe/europe.png",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "europe/united_kingdom.png",
        "soundFile": "voices-$CA/$LOCALE/geography/united_kingdom.$CA",
        "toolTipText": qsTr("United Kingdom"),
        "x": "0.215",
        "y": "0.439"
    },
    {
        "pixmapfile": "europe/switz.png",
        "soundFile": "voices-$CA/$LOCALE/geography/switz.$CA",
        "toolTipText": qsTr("Switzerland"),
        "x": "0.409",
        "y": "0.644"
    },
    {
        "pixmapfile": "europe/sweden.png",
        "soundFile": "voices-$CA/$LOCALE/geography/sweden.$CA",
        "toolTipText": qsTr("Sweden"),
        "x": "0.523",
        "y": "0.247"
    },
    {
        "pixmapfile": "europe/spain.png",
        "soundFile": "voices-$CA/$LOCALE/geography/spain.$CA",
        "toolTipText": qsTr("Spain"),
        "x": "0.23",
        "y": "0.835"
    },
    {
        "pixmapfile": "europe/portugal.png",
        "soundFile": "voices-$CA/$LOCALE/geography/portugal.$CA",
        "toolTipText": qsTr("Portugal"),
        "x": "0.134",
        "y": "0.844"
    },
    {
        "pixmapfile": "europe/norway.png",
        "soundFile": "voices-$CA/$LOCALE/geography/norway.$CA",
        "toolTipText": qsTr("Norway"),
        "x": "0.516",
        "y": "0.188"
    },
    {
        "pixmapfile": "europe/netherland.png",
        "soundFile": "voices-$CA/$LOCALE/geography/netherland.$CA",
        "toolTipText": qsTr("The Netherlands"),
        "x": "0.353",
        "y": "0.502"
    },
    {
        "pixmapfile": "europe/luxembourg.png",
        "soundFile": "voices-$CA/$LOCALE/geography/luxembourg.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.369",
        "y": "0.568"
    },
    {
        "pixmapfile": "europe/italy.png",
        "soundFile": "voices-$CA/$LOCALE/geography/italy.$CA",
        "toolTipText": qsTr("Italy"),
        "x": "0.485",
        "y": "0.78"
    },
    {
        "pixmapfile": "europe/ireland.png",
        "soundFile": "voices-$CA/$LOCALE/geography/ireland.$CA",
        "toolTipText": qsTr("Ireland"),
        "x": "0.14",
        "y": "0.47"
    },
    {
        "pixmapfile": "europe/iceland.png",
        "soundFile": "voices-$CA/$LOCALE/geography/iceland.$CA",
        "toolTipText": qsTr("Iceland"),
        "x": "0.078",
        "y": "0.133"
    },
    {
        "pixmapfile": "europe/germany.png",
        "soundFile": "voices-$CA/$LOCALE/geography/germany.$CA",
        "toolTipText": qsTr("Germany"),
        "x": "0.439",
        "y": "0.53"
    },
    {
        "pixmapfile": "europe/france.png",
        "soundFile": "voices-$CA/$LOCALE/geography/france.$CA",
        "toolTipText": qsTr("France"),
        "x": "0.312",
        "y": "0.662"
    },
    {
        "pixmapfile": "europe/finland.png",
        "soundFile": "voices-$CA/$LOCALE/geography/finland.$CA",
        "toolTipText": qsTr("Finland"),
        "x": "0.642",
        "y": "0.17"
    },
    {
        "pixmapfile": "europe/denmark.png",
        "soundFile": "voices-$CA/$LOCALE/geography/denmark.$CA",
        "toolTipText": qsTr("Denmark"),
        "x": "0.43",
        "y": "0.398"
    },
    {
        "pixmapfile": "europe/belgium.png",
        "soundFile": "voices-$CA/$LOCALE/geography/belgium.$CA",
        "toolTipText": qsTr("Belgium"),
        "x": "0.343",
        "y": "0.546"
    },
    {
        "pixmapfile": "europe/austria.png",
        "soundFile": "voices-$CA/$LOCALE/geography/austria.$CA",
        "toolTipText": qsTr("Austria"),
        "x": "0.49",
        "y": "0.621"
    }
    ]
}
