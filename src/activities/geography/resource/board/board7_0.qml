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
import QtQuick 2.9

QtObject {
    property string instruction: qsTr("Northern Africa")
    property var levels: [
    {
        "pixmapfile": "northafrica/north_africa.svg",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "northafrica/western_sahara.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/western_sahara.$CA",
        "toolTipText": qsTr("Western Sahara"),
        "x": "0.1381",
        "y": "0.3136"
    },
    {
        "pixmapfile": "northafrica/uganda.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/uganda.$CA",
        "toolTipText": qsTr("Uganda"),
        "x": "0.7414",
        "y": "0.8495"
    },
    {
        "pixmapfile": "northafrica/tunisia.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/tunisia.$CA",
        "toolTipText": qsTr("Tunisia"),
        "x": "0.4374",
        "y": "0.0896"
    },
    {
        "pixmapfile": "northafrica/togo.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/togo.$CA",
        "toolTipText": qsTr("Togo"),
        "x": "0.3216",
        "y": "0.6799"
    },
    {
        "pixmapfile": "northafrica/sudan.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/sudan.$CA",
        "toolTipText": qsTr("Sudan"),
        "x": "0.7139",
        "y": "0.5194"
    },
    {
        "pixmapfile": "northafrica/south_sudan.svg",
        "soundFile": "voices-$CA/$LOCALE/geographys/south_sudan.$CA",
        "toolTipText": qsTr("South Sudan"),
        "x": "0.7071",
        "y": "0.6974"
    },
    {
        "pixmapfile": "northafrica/somalia.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/somalia.$CA",
        "toolTipText": qsTr("Somalia"),
        "x": "0.9272",
        "y": "0.7609"
    },
    {
        "pixmapfile": "northafrica/sierra_leone.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/sierra_leone.$CA",
        "toolTipText": qsTr("Sierra Leone"),
        "x": "0.1528",
        "y": "0.6832"
    },
    {
        "pixmapfile": "northafrica/senegal.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/senegal.$CA",
        "toolTipText": qsTr("Senegal"),
        "x": "0.1171",
        "y": "0.5416"
    },
    {
        "pixmapfile": "northafrica/rwanda.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/rwanda.$CA",
        "toolTipText": qsTr("Rwanda"),
        "x": "0.7093",
        "y": "0.9269"
    },
    {
        "pixmapfile": "northafrica/niger.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/niger.$CA",
        "toolTipText": qsTr("Niger"),
        "x": "0.418",
        "y": "0.4685"
    },
    {
        "pixmapfile": "northafrica/nigeria.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/nigeria.$CA",
        "toolTipText": qsTr("Nigeria"),
        "x": "0.4259",
        "y": "0.6687"
    },
    {
        "pixmapfile": "northafrica/morocco.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/moroco.$CA",
        "toolTipText": qsTr("Morocco"),
        "x": "0.2151",
        "y": "0.1367"
    },
    {
        "pixmapfile": "northafrica/mauritania.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/mauritania.$CA",
        "toolTipText": qsTr("Mauritania"),
        "x": "0.1641",
        "y": "0.3887"
    },
    {
        "pixmapfile": "northafrica/mali.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/mali.$CA",
        "toolTipText": qsTr("Mali"),
        "x": "0.2565",
        "y": "0.4694"
    },
    {
        "pixmapfile": "northafrica/libya.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/libya.$CA",
        "toolTipText": qsTr("Libya"),
        "x": "0.5405",
        "y": "0.2641"
    },
    {
        "pixmapfile": "northafrica/liberia.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/liberia.$CA",
        "toolTipText": qsTr("Liberia"),
        "x": "0.184",
        "y": "0.7304"
    },
    {
        "pixmapfile": "northafrica/kenya.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/kenya.$CA",
        "toolTipText": qsTr("Kenya"),
        "x": "0.8165",
        "y": "0.8732"
    },
    {
        "pixmapfile": "northafrica/ivory_coast.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/ivory_coast.$CA",
        "toolTipText": qsTr("Ivory Coast"),
        "x": "0.2361",
        "y": "0.7044"
    },
    {
        "pixmapfile": "northafrica/guinea.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/guinea.$CA",
        "toolTipText": qsTr("Guinea"),
        "x": "0.1584",
        "y": "0.6483"
    },
    {
        "pixmapfile": "northafrica/guinea_bissau.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/guinea_bissau.$CA",
        "toolTipText": qsTr("Guinea Bissau"),
        "x": "0.1073",
        "y": "0.6046"
    },
    {
        "pixmapfile": "northafrica/ghana.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/ghana.$CA",
        "toolTipText": qsTr("Ghana"),
        "x": "0.2965",
        "y": "0.6948"
    },
    {
        "pixmapfile": "northafrica/gambia.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/gambia.$CA",
        "toolTipText": qsTr("Gambia"),
        "x": "0.1055",
        "y": "0.5664"
    },
    {
        "pixmapfile": "northafrica/gabon.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/gabon.$CA",
        "toolTipText": qsTr("Gabon"),
        "x": "0.4651",
        "y": "0.9007"
    },
    {
        "pixmapfile": "northafrica/eritrea.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/eritrea.$CA",
        "toolTipText": qsTr("Eritrea"),
        "x": "0.8416",
        "y": "0.5254"
    },
    {
        "pixmapfile": "northafrica/ethiopia.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/ethiopia.$CA",
        "toolTipText": qsTr("Ethiopia"),
        "x": "0.8512",
        "y": "0.6667"
    },
    {
        "pixmapfile": "northafrica/equatorial_guinea.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/equatorial_guinea.$CA",
        "toolTipText": qsTr("Equatorial Guinea"),
        "x": "0.4423",
        "y": "0.8263"
    },
    {
        "pixmapfile": "northafrica/egypt.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/egypt.$CA",
        "toolTipText": qsTr("Egypt"),
        "x": "0.7216",
        "y": "0.2529"
    },
    {
        "pixmapfile": "northafrica/djibouti.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/djibouti.$CA",
        "toolTipText": qsTr("Djibouti"),
        "x": "0.8792",
        "y": "0.6045"
    },
    {
        "pixmapfile": "northafrica/chad.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/chad.$CA",
        "toolTipText": qsTr("Chad"),
        "x": "0.5603",
        "y": "0.5198"
    },
    {
        "pixmapfile": "northafrica/central_african_republic.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/central_african_republic.$CA",
        "toolTipText": qsTr("Central African Republic"),
        "x": "0.5897",
        "y": "0.7253"
    },
    {
        "pixmapfile": "northafrica/cameroon.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/cameroon.$CA",
        "toolTipText": qsTr("Cameroon"),
        "x": "0.4754",
        "y": "0.7086"
    },
    {
        "pixmapfile": "northafrica/burkina_faso.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/burkina_faso.$CA",
        "toolTipText": qsTr("Burkina Faso"),
        "x": "0.2893",
        "y": "0.5939"
    },
    {
        "pixmapfile": "northafrica/benin.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/benin.$CA",
        "toolTipText": qsTr("Benin"),
        "x": "0.341",
        "y": "0.6634"
    },
    {
        "pixmapfile": "northafrica/algeria.svg",
        "soundFile": "voices-$CA/$LOCALE/geography/algeria.$CA",
        "toolTipText": qsTr("Algeria"),
        "x": "0.3322",
        "y": "0.2242"
    }
    ]
}
