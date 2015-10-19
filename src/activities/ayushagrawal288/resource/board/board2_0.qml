/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
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
import QtQuick 2.0

QtObject {
    property string instruction: qsTr("Monuments of India")
    property variant levels: [
        {
            "pixmapfile" : "india/background.png",
            "type" : "SHAPE_BACKGROUND_IMAGE"
        },
        {
            "pixmapfile" : "india/goldentemplepunjab.png",
            "toolTipText" : qsTr("Golden Temple, Punjab"),
            "x" : "0.278",
            "y" : "0.228",
            "height" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/hawamahalrajasthan.png",
            "toolTipText" : qsTr("Hawa Mahal, Rajasthan"),
            "x" : "0.216",
            "y" : "0.377",
            "height" : "0.18",
            "width" : "0.18"
        },
        {
            "pixmapfile" : "india/tajmahal.png",
            "toolTipText" : qsTr("Taj Mahal, Uttar Pradesh"),
            "x" : "0.459",
            "y" : "0.36",
            "height" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/gatewayindiamaharastra.png",
            "toolTipText" : qsTr("Gateway of India, Maharashtra"),
            "x" : "0.179",
            "y" : "0.610",
            "height" : "0.25",
            "width" : "0.25"
        },
        {
            "pixmapfile" : "india/sanchistupasmadyapradesh.png",
            "toolTipText" : qsTr("Sanchi Stupas, Madhya Pradesh"),
            "x" : "0.375",
            "y" : "0.461",
            "height" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/ajantacavemaharastra.png",
            "toolTipText" : qsTr("Ajanta Caves, Maharashtra"),
            "x" : "0.314",
            "y" : "0.624",
            "height" : "0.20",
            "width" : "0.20"
        },
        {
            "pixmapfile" : "india/suntempleorrisa.png",
            "toolTipText" : qsTr("Sun Temple, Orrisa"),
            "x" : "0.591",
            "y" : "0.584",
            "height" : "0.18",
            "width" : "0.18"
        },
        {
            "pixmapfile" : "india/mysorepalacekarnataka.png",
            "toolTipText" : qsTr("Mysore Palace, Karnataka"),
            "x" : "0.295",
            "y" : "0.748",
            "height" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/chaarminartelangana.png",
            "toolTipText" : qsTr("Chaar Minar, Telangana"),
            "x" : "0.405",
            "y" : "0.66",
            "height" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/victoriamemorialwstbengal.png",
            "toolTipText" : qsTr("Victoria Memorial, West Bengal"),
            "x" : "0.689",
            "y" : "0.445",
            "height" : "0.20",
            "width" : "0.20"
        },
        {
            "pixmapfile" : "india/ranggharassam.png",
            "toolTipText" : qsTr("Rang Ghar Assam"),
            "x" : "0.842",
            "y" : "0.37",
            "height" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/qutubminardelhi.png",
            "toolTipText" : qsTr("Qutub Minar, Delhi"),
            "x" : "0.336",
            "y" : "0.31",
            "height" : "0.25",
            "width" : "0.25"
        }
    ]
}
