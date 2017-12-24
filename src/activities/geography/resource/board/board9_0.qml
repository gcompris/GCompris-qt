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
    property string instruction: qsTr("Asia")
    property var levels: [
    {
        "pixmapfile": "asia/background.png",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "asia/russia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/russia.$CA",
        "toolTipText": qsTr("Russia"),
        "x": "0.497",
        "y": "0.215"
    },
    {
        "pixmapfile": "asia/mongolia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/mongolia.$CA",
        "toolTipText": qsTr("Mongolia"),
        "x": "0.562",
        "y": "0.341"
    },
    {
        "pixmapfile": "asia/japan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/japan.$CA",
        "toolTipText": qsTr("Japan"),
        "x": "0.855",
        "y": "0.437"
    },
    {
        "pixmapfile": "asia/north_korea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/north_korea.$CA",
        "toolTipText": qsTr("North Korea"),
        "x": "0.768",
        "y": "0.415"
    },
    {
        "pixmapfile": "asia/south_korea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/south_korea.$CA",
        "toolTipText": qsTr("South Korea"),
        "x": "0.79",
        "y": "0.459"
    },
    {
        "pixmapfile": "asia/kazakhstan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/kazakhstan.$CA",
        "toolTipText": qsTr("Kazakhstan"),
        "x": "0.293",
        "y": "0.328"
    },
    {
        "pixmapfile": "asia/uzbekistan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/uzbekistan.$CA",
        "toolTipText": qsTr("Uzbekistan"),
        "x": "0.289",
        "y": "0.403"
    },
    {
        "pixmapfile": "asia/taiwan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/taiwan.$CA",
        "toolTipText": qsTr("Taiwan"),
        "x": "0.772",
        "y": "0.603"
    },
    {
        "pixmapfile": "asia/vietnam.png",
        "soundFile": "voices-$CA/$LOCALE/geography/vietnam.$CA",
        "toolTipText": qsTr("Vietnam"),
        "x": "0.661",
        "y": "0.691"
    },
    {
        "pixmapfile": "asia/cambodia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/cambodia.$CA",
        "toolTipText": qsTr("Cambodia"),
        "x": "0.658",
        "y": "0.732"
    },
    {
        "pixmapfile": "asia/laos.png",
        "soundFile": "voices-$CA/$LOCALE/geography/laos.$CA",
        "toolTipText": qsTr("Laos"),
        "x": "0.644",
        "y": "0.664"
    },
    {
        "pixmapfile": "asia/thailand.png",
        "soundFile": "voices-$CA/$LOCALE/geography/thailand.$CA",
        "toolTipText": qsTr("Thailand"),
        "x": "0.627",
        "y": "0.723"
    },
    {
        "pixmapfile": "asia/sri_lanka.png",
        "soundFile": "voices-$CA/$LOCALE/geography/sri_lanka.$CA",
        "toolTipText": qsTr("Sri Lanka"),
        "x": "0.465",
        "y": "0.785"
    },
    {
        "pixmapfile": "asia/china.png",
        "soundFile": "voices-$CA/$LOCALE/geography/china.$CA",
        "toolTipText": qsTr("China"),
        "x": "0.577",
        "y": "0.466"
    },
    {
        "pixmapfile": "asia/india.png",
        "soundFile": "voices-$CA/$LOCALE/geography/india.$CA",
        "toolTipText": qsTr("India"),
        "x": "0.465",
        "y": "0.624"
    },
    {
        "pixmapfile": "asia/bangladesh.png",
        "soundFile": "voices-$CA/$LOCALE/geography/bangladesh.$CA",
        "toolTipText": qsTr("Bangladesh"),
        "x": "0.532",
        "y": "0.602"
    },
    {
        "pixmapfile": "asia/bhutan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/bhutan.$CA",
        "toolTipText": qsTr("Bhutan"),
        "x": "0.523",
        "y": "0.561"
    },
    {
        "pixmapfile": "asia/nepal.png",
        "soundFile": "voices-$CA/$LOCALE/geography/nepal.$CA",
        "toolTipText": qsTr("Nepal"),
        "x": "0.472",
        "y": "0.55"
    },
    {
        "pixmapfile": "asia/pakistan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/pakistan.$CA",
        "toolTipText": qsTr("Pakistan"),
        "x": "0.344",
        "y": "0.527"
    },
    {
        "pixmapfile": "asia/myanmar.png",
        "soundFile": "voices-$CA/$LOCALE/geography/myanmar.$CA",
        "toolTipText": qsTr("Myanmar"),
        "x": "0.579",
        "y": "0.65"
    },
    {
        "pixmapfile": "asia/philippines.png",
        "soundFile": "voices-$CA/$LOCALE/geography/philippines.$CA",
        "toolTipText": qsTr("Philippines"),
        "x": "0.8",
        "y": "0.736"
    },
    {
        "pixmapfile": "asia/indonesia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/indonesia.$CA",
        "toolTipText": qsTr("Indonesia"),
        "x": "0.727",
        "y": "0.9"
    },
    {
        "pixmapfile": "asia/malaysia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/malaysia.$CA",
        "toolTipText": qsTr("Malaysia"),
        "x": "0.699",
        "y": "0.831"
    },
    {
        "pixmapfile": "asia/afghanistan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/afghanistan.$CA",
        "toolTipText": qsTr("Afghanistan"),
        "x": "0.328",
        "y": "0.487"
    },
    {
        "pixmapfile": "asia/tajikistan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/tajikistan.$CA",
        "toolTipText": qsTr("Tajikistan"),
        "x": "0.35",
        "y": "0.429"
    },
    {
        "pixmapfile": "asia/kyrgyzstan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/kyrgyzstan.$CA",
        "toolTipText": qsTr("Kyrgyzstan"),
        "x": "0.371",
        "y": "0.404"
    },
    {
        "pixmapfile": "asia/turkmenistan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/turkmenistan.$CA",
        "toolTipText": qsTr("Turkmenistan"),
        "x": "0.26",
        "y": "0.428"
    },
    {
        "pixmapfile": "asia/iran.png",
        "soundFile": "voices-$CA/$LOCALE/geography/iran.$CA",
        "toolTipText": qsTr("Iran"),
        "x": "0.224",
        "y": "0.505"
    },
    {
        "pixmapfile": "asia/azerbaijan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/azerbaijan.$CA",
        "toolTipText": qsTr("Azerbaijan"),
        "x": "0.163",
        "y": "0.414"
    },
    {
        "pixmapfile": "asia/georgia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/georgia.$CA",
        //: Translators: Strip Asia| and translate only Georgia
        "toolTipText": qsTr("Asia|Georgia"),
        "x": "0.133",
        "y": "0.389"
    },
    {
        "pixmapfile": "asia/turkey.png",
        "soundFile": "voices-$CA/$LOCALE/geography/turkey.$CA",
        "toolTipText": qsTr("Turkey"),
        "x": "0.077",
        "y": "0.428"
    },
    {
        "pixmapfile": "asia/syria.png",
        "soundFile": "voices-$CA/$LOCALE/geography/syria.$CA",
        "toolTipText": qsTr("Syria"),
        "x": "0.108",
        "y": "0.478"
    },
    {
        "pixmapfile": "asia/iraq.png",
        "soundFile": "voices-$CA/$LOCALE/geography/iraq.$CA",
        "toolTipText": qsTr("Iraq"),
        "x": "0.15",
        "y": "0.492"
    },
    {
        "pixmapfile": "asia/jordan.png",
        "soundFile": "voices-$CA/$LOCALE/geography/jordan.$CA",
        "toolTipText": qsTr("Jordan"),
        "x": "0.1",
        "y": "0.517"
    },
    {
        "pixmapfile": "asia/saudi_arabia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/saudi_arabia.$CA",
        "toolTipText": qsTr("Saudi Arabia"),
        "x": "0.167",
        "y": "0.592"
    },
    {
        "pixmapfile": "asia/yemen.png",
        "soundFile": "voices-$CA/$LOCALE/geography/yemen.$CA",
        "toolTipText": qsTr("Yemen"),
        "x": "0.192",
        "y": "0.692"
    },
    {
        "pixmapfile": "asia/united_arab_emirates.png",
        "soundFile": "voices-$CA/$LOCALE/geography/united_arab_emirates.$CA",
        "toolTipText": qsTr("United Arab Emirates"),
        "x": "0.236",
        "y": "0.598"
    },
    {
        "pixmapfile": "asia/oman.png",
        "soundFile": "voices-$CA/$LOCALE/geography/oman.$CA",
        "toolTipText": qsTr("Oman"),
        "x": "0.255",
        "y": "0.628"
    },
    {
        "pixmapfile": "asia/armenia.png",
        "soundFile": "voices-$CA/$LOCALE/geography/armenia.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.15",
        "y": "0.415"
    },
    {
        "pixmapfile": "asia/kuwait.png",
        "soundFile": "voices-$CA/$LOCALE/geography/kuwait.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.18",
        "y": "0.538"
    },
    {
        "pixmapfile": "asia/cyprus.png",
        "soundFile": "voices-$CA/$LOCALE/geography/cyprus.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.065",
        "y": "0.472"
    },
    {
        "pixmapfile": "asia/lebanon.png",
        "soundFile": "voices-$CA/$LOCALE/geography/lebanon.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.086",
        "y": "0.487"
    },
    {
        "pixmapfile": "asia/bahrain.png",
        "soundFile": "voices-$CA/$LOCALE/geography/bahrain.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.208",
        "y": "0.575"
    },
    {
        "pixmapfile": "asia/qatar.png",
        "soundFile": "voices-$CA/$LOCALE/geography/qatar.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.214",
        "y": "0.586"
    },
    {
        "pixmapfile": "asia/brunei.png",
        "soundFile": "voices-$CA/$LOCALE/geography/brunei.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.744",
        "y": "0.821"
    },
    {
        "pixmapfile": "asia/israel.png",
        "soundFile": "voices-$CA/$LOCALE/geography/israel.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.08",
        "y": "0.517"
    },
    {
        "pixmapfile": "asia/palestine.png",
        "soundFile": "voices-$CA/$LOCALE/geography/palestine.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.081",
        "y": "0.516"
    },
    {
        "pixmapfile": "asia/red_sea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/red_sea.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.128",
        "y": "0.662"
    },
    {
        "pixmapfile": "asia/africa2.png",
        "soundFile": "voices-$CA/$LOCALE/geography/africa2.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.176",
        "y": "0.808"
    },
    {
        "pixmapfile": "asia/africa.png",
        "soundFile": "voices-$CA/$LOCALE/geography/africa.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.054",
        "y": "0.769"
    },
    {
        "pixmapfile": "asia/persian_gulf.png",
        "soundFile": "voices-$CA/$LOCALE/geography/persian_gulf.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.223",
        "y": "0.563"
    },
    {
        "pixmapfile": "asia/mediteranean_sea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/mediteranean_sea.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.042",
        "y": "0.485"
    },
    {
        "pixmapfile": "asia/black_sea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/black_sea.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.059",
        "y": "0.344"
    },
    {
        "pixmapfile": "asia/caspian_sea.png",
        "soundFile": "voices-$CA/$LOCALE/geography/caspian_sea.$CA",
        "type": "SHAPE_BACKGROUND",
        "x": "0.189",
        "y": "0.398"
    }
    ]
}
