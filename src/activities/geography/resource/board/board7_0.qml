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
    property string instruction: qsTr("Northern Africa")
    property var levels: [
    {
        "pixmapfile": "africa/north_africa.png",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "africa/western_sahara.png",
        "soundFile": "voices-$CA/$LOCALE/geography/western_sahara.$CA",
        "toolTipText": qsTr("Western Sahara"),
        "x": "0.114",
        "y": "0.307"
    },
    {
        "pixmapfile": "africa/uganda.png",
        "soundFile": "voices-$CA/$LOCALE/geography/uganda.$CA",
        "toolTipText": qsTr("Uganda"),
        "x": "0.737",
        "y": "0.878"
    },
    {
        "pixmapfile": "africa/tunisia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/tunisia.$CA",
        "toolTipText": qsTr("Tunisia"),
        "x": "0.425",
        "y": "0.139"
    },
    {
        "pixmapfile": "africa/togo.png",
        "soundFile": "voices-$CA/$LOCALE/geography/togo.$CA",
        "toolTipText": qsTr("Togo"),
        "x": "0.27",
        "y": "0.689"
    },
    {
        "pixmapfile": "africa/sudan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/sudan.$CA",
        "toolTipText": qsTr("Sudan"),
        "x": "0.694",
        "y": "0.599"
    },
    {
        "pixmapfile": "africa/somalia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/somalia.$CA",
        "toolTipText": qsTr("Somalia"),
        "x": "0.926",
        "y": "0.792"
    },
    {
        "pixmapfile": "africa/sierra_leone.png",
        "soundFile": "voices-$CA/$LOCALE/geography/sierra_leone.$CA",
        "toolTipText": qsTr("Sierra Leone"),
        "x": "0.093",
        "y": "0.672"
    },
    {
        "pixmapfile": "africa/senegal.png",
        "soundFile": "voices-$CA/$LOCALE/geography/senegal.$CA",
        "toolTipText": qsTr("Senegal"),
        "x": "0.055",
        "y": "0.536"
    },
    {
        "pixmapfile": "africa/rwanda.png",
        "soundFile": "voices-$CA/$LOCALE/geography/rwanda.$CA",
        "toolTipText": qsTr("Rwanda"),
        "x": "0.706",
        "y": "0.959"
    },
    {
        "pixmapfile": "africa/niger.png",
        "soundFile": "voices-$CA/$LOCALE/geography/niger.$CA",
        "toolTipText": qsTr("Niger"),
        "x": "0.384",
        "y": "0.491"
    },
    {
        "pixmapfile": "africa/nigeria.png",
        "soundFile": "voices-$CA/$LOCALE/geography/nigeria.$CA",
        "toolTipText": qsTr("Nigeria"),
        "x": "0.388",
        "y": "0.68"
    },
    {
        "pixmapfile": "africa/moroco.png",
        "soundFile": "voices-$CA/$LOCALE/geography/moroco.$CA",
        "toolTipText": qsTr("Morocco"),
        "x": "0.205",
        "y": "0.159"
    },
    {
        "pixmapfile": "africa/mauritania.png",
        "soundFile": "voices-$CA/$LOCALE/geography/mauritania.$CA",
        "toolTipText": qsTr("Mauritania"),
        "x": "0.133",
        "y": "0.395"
    },
    {
        "pixmapfile": "africa/mali.png",
        "soundFile": "voices-$CA/$LOCALE/geography/mali.$CA",
        "toolTipText": qsTr("Mali"),
        "x": "0.215",
        "y": "0.479"
    },
    {
        "pixmapfile": "africa/libya.png",
        "soundFile": "voices-$CA/$LOCALE/geography/libya.$CA",
        "toolTipText": qsTr("Libya"),
        "x": "0.517",
        "y": "0.313"
    },
    {
        "pixmapfile": "africa/liberia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/liberia.$CA",
        "toolTipText": qsTr("Liberia"),
        "x": "0.12",
        "y": "0.727"
    },
    {
        "pixmapfile": "africa/ivory_coast.png",
        "soundFile": "voices-$CA/$LOCALE/geography/ivory_coast.$CA",
        "toolTipText": qsTr("Ivory Coast"),
        "x": "0.177",
        "y": "0.706"
    },
    {
        "pixmapfile": "africa/guinea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/guinea.$CA",
        "toolTipText": qsTr("Guinea"),
        "x": "0.099",
        "y": "0.639"
    },
    {
        "pixmapfile": "africa/guinea_bissau.png",
        "soundFile": "voices-$CA/$LOCALE/geography/guinea_bissau.$CA",
        "toolTipText": qsTr("Guinea Bissau"),
        "x": "0.05",
        "y": "0.599"
    },
    {
        "pixmapfile": "africa/ghana.png",
        "soundFile": "voices-$CA/$LOCALE/geography/ghana.$CA",
        "toolTipText": qsTr("Ghana"),
        "x": "0.24",
        "y": "0.704"
    },
    {
        "pixmapfile": "africa/gambia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/gambia.$CA",
        "toolTipText": qsTr("Gambia"),
        "x": "0.048",
        "y": "0.564"
    },
    {
        "pixmapfile": "africa/gabon.png",
        "soundFile": "voices-$CA/$LOCALE/geography/gabon.$CA",
        "toolTipText": qsTr("Gabon"),
        "x": "0.455",
        "y": "0.933"
    },
    {
        "pixmapfile": "africa/eritrea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/eritrea.$CA",
        "toolTipText": qsTr("Eritrea"),
        "x": "0.833",
        "y": "0.571"
    },
    {
        "pixmapfile": "africa/ethiopia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/ethiopia.$CA",
        "toolTipText": qsTr("Ethiopia"),
        "x": "0.843",
        "y": "0.706"
    },
    {
        "pixmapfile": "africa/equatorial_guinea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/equatorial_guinea.$CA",
        "toolTipText": qsTr("Equatorial Guinea"),
        "x": "0.433",
        "y": "0.878"
    },
    {
        "pixmapfile": "africa/egypt.png",
        "soundFile": "voices-$CA/$LOCALE/geography/egypt.$CA",
        "toolTipText": qsTr("Egypt"),
        "x": "0.697",
        "y": "0.294"
    },
    {
        "pixmapfile": "africa/djibouti.png",
        "soundFile": "voices-$CA/$LOCALE/geography/djibouti.$CA",
        "toolTipText": qsTr("Djibouti"),
        "x": "0.874",
        "y": "0.637"
    },
    {
        "pixmapfile": "africa/chad.png",
        "soundFile": "voices-$CA/$LOCALE/geography/chad.$CA",
        "toolTipText": qsTr("Chad"),
        "x": "0.537",
        "y": "0.545"
    },
    {
        "pixmapfile": "africa/central_african_republic.png",
        "soundFile": "voices-$CA/$LOCALE/geography/central_african_republic.$CA",
        "toolTipText": qsTr("Central African Republic"),
        "x": "0.564",
        "y": "0.736"
    },
    {
        "pixmapfile": "africa/cameroon.png",
        "soundFile": "voices-$CA/$LOCALE/geography/cameroon.$CA",
        "toolTipText": qsTr("Cameroon"),
        "x": "0.448",
        "y": "0.751"
    },
    {
        "pixmapfile": "africa/burkina_faso.png",
        "soundFile": "voices-$CA/$LOCALE/geography/burkina_faso.$CA",
        "toolTipText": qsTr("Burkina Faso"),
        "x": "0.239",
        "y": "0.607"
    },
    {
        "pixmapfile": "africa/benin.png",
        "soundFile": "voices-$CA/$LOCALE/geography/benin.$CA",
        "toolTipText": qsTr("Benin"),
        "x": "0.294",
        "y": "0.674"
    },
    {
        "pixmapfile": "africa/algeria.png",
        "soundFile": "voices-$CA/$LOCALE/geography/algeria.$CA",
        "toolTipText": qsTr("Algeria"),
        "x": "0.31",
        "y": "0.264"
    }
    ]
}
