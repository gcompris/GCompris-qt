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
    property string instruction: qsTr("Continents")
    property var levels: [
    {
        "pixmapfile": "continents/back.png",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "continents/oceania.png",
        "soundFile": "voices-$CA/$LOCALE/geography/oceania.$CA",
        "toolTipText": qsTr("Oceania"),
        "x": "0.892",
        "y": "0.822"
    },
    {
        "pixmapfile": "continents/europa.png",
        "soundFile": "voices-$CA/$LOCALE/geography/europe.$CA",
        "toolTipText": qsTr("Europe"),
        "x": "0.507",
        "y": "0.257"
    },
    {
        "pixmapfile": "continents/asia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/asia.$CA",
        "toolTipText": qsTr("Asia"),
        "x": "0.747",
        "y": "0.386"
    },
    {
        "pixmapfile": "continents/antarctica.png",
        "soundFile": "voices-$CA/$LOCALE/geography/antarctica.$CA",
        "toolTipText": qsTr("Antarctica"),
        "x": "0.42",
        "y": "0.979"
    },
    {
        "pixmapfile": "continents/america.png",
        "soundFile": "voices-$CA/$LOCALE/geography/america.$CA",
        "toolTipText": qsTr("America"),
        "x": "0.22",
        "y": "0.479"
    },
    {
        "pixmapfile": "continents/africa.png",
        "soundFile": "voices-$CA/$LOCALE/geography/africa.$CA",
        "toolTipText": qsTr("Africa"),
        "x": "0.512",
        "y": "0.636"
    }
    ]
}
