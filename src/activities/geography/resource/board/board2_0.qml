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
    property string instruction: qsTr("North America")
    property var levels: [
    {
        "pixmapfile": "northamerica/north_america.png",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "northamerica/alaska.png",
        "soundFile": "voices-$CA/$LOCALE/geography/alaska.$CA",
        "toolTipText": qsTr("Alaska"),
        "x": "0.126",
        "y": "0.177"
    },
    {
        "pixmapfile": "northamerica/usa.png",
        "soundFile": "voices-$CA/$LOCALE/geography/usa.$CA",
        "toolTipText": qsTr("United States of America"),
        "x": "0.358",
        "y": "0.704"
    },
    {
        "pixmapfile": "northamerica/mexico.png",
        "soundFile": "voices-$CA/$LOCALE/geography/mexico.$CA",
        "toolTipText": qsTr("Mexico"),
        "x": "0.264",
        "y": "0.835"
    },
    {
        "pixmapfile": "northamerica/iceland.png",
        "soundFile": "voices-$CA/$LOCALE/geography/iceland.$CA",
        "toolTipText": qsTr("Iceland"),
        "x": "0.643",
        "y": "0.092"
    },
    {
        "pixmapfile": "northamerica/greenland.png",
        "soundFile": "voices-$CA/$LOCALE/geography/greenland.$CA",
        "toolTipText": qsTr("Greenland"),
        "x": "0.524",
        "y": "0.152"
    },
    {
        "pixmapfile": "northamerica/canada.png",
        "soundFile": "voices-$CA/$LOCALE/geography/canada.$CA",
        "toolTipText": qsTr("Canada"),
        "x": "0.394",
        "y": "0.35"
    }
    ]
}
