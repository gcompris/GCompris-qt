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
    property string instruction: qsTr("Eastern Europe")
    property var levels: [
    {
        "pixmapfile": "europe/europe.png",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "europe/cyprus.png",
        "soundFile": "voices-$CA/$LOCALE/geography/cyprus.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.859",
        "y": "0.965"
    },
    {
        "pixmapfile": "europe/greece.png",
        "soundFile": "voices-$CA/$LOCALE/geography/greece.$CA",
        "toolTipText": qsTr("Greece"),
        "x": "0.692",
        "y": "0.878"
    },
    {
        "pixmapfile": "europe/ukraine.png",
        "soundFile": "voices-$CA/$LOCALE/geography/ukraine.$CA",
        "toolTipText": qsTr("Ukraine"),
        "x": "0.781",
        "y": "0.603"
    },
    {
        "pixmapfile": "europe/turkey.png",
        "soundFile": "voices-$CA/$LOCALE/geography/turkey.$CA",
        "toolTipText": qsTr("Turkey"),
        "x": "0.851",
        "y": "0.867"
    },
    {
        "pixmapfile": "europe/slovenia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/slovenia.$CA",
        "type": "SHAPE_BACKGROUND",
        "toolTipText": qsTr("Slovenia"),
        "x": "0.516",
        "y": "0.662"
    },
    {
        "pixmapfile": "europe/slovakia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/slovakia.$CA",
        "toolTipText": qsTr("Slovak Republic"),
        "x": "0.593",
        "y": "0.596"
    },
    {
        "pixmapfile": "europe/montenegro.png",
        "soundFile": "voices-$CA/$LOCALE/geography/montenegro.$CA",
        "toolTipText": qsTr("Montenegro"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.601",
        "y": "0.755"
    },
    {
        "pixmapfile": "europe/serbia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/serbia.$CA",
        "toolTipText": qsTr("Serbia"),
        "x": "0.623",
        "y": "0.723"
    },
    {
        "pixmapfile": "europe/russia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/russia.$CA",
        "toolTipText": qsTr("Russia"),
        "x": "0.788",
        "y": "0.373"
    },
    {
        "pixmapfile": "europe/romania.png",
        "soundFile": "voices-$CA/$LOCALE/geography/romania.$CA",
        "toolTipText": qsTr("Romania"),
        "x": "0.688",
        "y": "0.669"
    },
    {
        "pixmapfile": "europe/poland.png",
        "soundFile": "voices-$CA/$LOCALE/geography/poland.$CA",
        "toolTipText": qsTr("Poland"),
        "x": "0.574",
        "y": "0.507"
    },
    {
        "pixmapfile": "europe/moldova.png",
        "soundFile": "voices-$CA/$LOCALE/geography/moldova.$CA",
        "toolTipText": qsTr("Moldova"),
        "x": "0.74",
        "y": "0.641"
    },
    {
        "pixmapfile": "europe/macedonia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/macedonia.$CA",
        "toolTipText": qsTr("Macedonia"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.642",
        "y": "0.787"
    },
    {
        "pixmapfile": "europe/lithuania.png",
        "soundFile": "voices-$CA/$LOCALE/geography/lithuania.$CA",
        "toolTipText": qsTr("Lithuania"),
        "x": "0.642",
        "y": "0.425"
    },
    {
        "pixmapfile": "europe/latvia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/latvia.$CA",
        "toolTipText": qsTr("Latvia"),
        "x": "0.651",
        "y": "0.381"
    },
    {
        "pixmapfile": "europe/hungary.png",
        "soundFile": "voices-$CA/$LOCALE/geography/hungary.$CA",
        "toolTipText": qsTr("Hungary"),
        "x": "0.591",
        "y": "0.635"
    },
    {
        "pixmapfile": "europe/estonia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/estonia.$CA",
        "toolTipText": qsTr("Estonia"),
        "x": "0.647",
        "y": "0.334"
    },
    {
        "pixmapfile": "europe/czechia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/czechia.$CA",
        "toolTipText": qsTr("Czechia"),
        "x": "0.525",
        "y": "0.561"
    },
    {
        "pixmapfile": "europe/croatia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/croatia.$CA",
        "toolTipText": qsTr("Croatia"),
        "x": "0.546",
        "y": "0.705"
    },
    {
        "pixmapfile": "europe/bulgaria.png",
        "soundFile": "voices-$CA/$LOCALE/geography/bulgaria.$CA",
        "toolTipText": qsTr("Bulgaria"),
        "x": "0.701",
        "y": "0.757"
    },
    {
        "pixmapfile": "europe/bosnia_herzegovina.png",
        "soundFile": "voices-$CA/$LOCALE/geography/bosnia_herzegovina.$CA",
        "toolTipText": qsTr("Bosnia Herzegovina"),
        "x": "0.568",
        "y": "0.728"
    },
    {
        "pixmapfile": "europe/belarus.png",
        "soundFile": "voices-$CA/$LOCALE/geography/belarus.$CA",
        "toolTipText": qsTr("Belarus"),
        "x": "0.714",
        "y": "0.463"
    },
    {
        "pixmapfile": "europe/albania.png",
        "soundFile": "voices-$CA/$LOCALE/geography/albania.$CA",
        "toolTipText": qsTr("Albania"),
        "x": "0.616",
        "y": "0.805"
    }
    ]
}
