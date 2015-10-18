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
            "toolTipText" : "Golden Temple, Punjab",
            "x" : "0.278",
            "y" : "0.228",
            "heigth" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/hawamahalrajasthan.png",
            "toolTipText" : "Hawa Mahal, Rajasthan",
            "x" : "0.216",
            "y" : "0.377",
            "heigth" : "0.11",
            "width" : "0.11"
        },
        {
            "pixmapfile" : "india/tajmahal.png",
            "toolTipText" : "Taj Mahal, Uttar Pradesh",
            "x" : "0.459",
            "y" : "0.36",
            "heigth" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/gatewayindiamaharastra.png",
            "toolTipText" : "Gateway of India, Maharashtra",
            "x" : "0.179",
            "y" : "0.610",
            "heigth" : "0.25",
            "width" : "0.25"
        },
        {
            "pixmapfile" : "india/sanchistupasmadyapradesh.png",
            "toolTipText" : "Sanchi Stupas, Madhya Pradesh",
            "x" : "0.375",
            "y" : "0.461",
            "heigth" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/ajantacavemaharastra.png",
            "toolTipText" : "Ajanta Caves, Maharashtra",
            "x" : "0.314",
            "y" : "0.624",
            "heigth" : "0.25",
            "width" : "0.25"
        },
        {
            "pixmapfile" : "india/suntempleorrisa.png",
            "toolTipText" : "Sun Temple, Orrisa",
            "x" : "0.591",
            "y" : "0.584",
            "heigth" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/mysorepalacekarnataka.png",
            "toolTipText" : "Mysore Palace, Karnataka",
            "x" : "0.295",
            "y" : "0.748",
            "heigth" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/chaarminartelangana.png",
            "toolTipText" : "Chaar Minar, Telangana",
            "x" : "0.405",
            "y" : "0.66",
            "heigth" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/victoriamemorialwstbengal.png",
            "toolTipText" : "Victoria Memorial, West Bengal",
            "x" : "0.689",
            "y" : "0.445",
            "heigth" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/ranggharassam.png",
            "toolTipText" : "Rang Ghar Assam",
            "x" : "0.842",
            "y" : "0.37",
            "heigth" : "0.15",
            "width" : "0.15"
        },
        {
            "pixmapfile" : "india/qutubminardelhi.png",
            "toolTipText" : "Qutub Minar, Delhi",
            "x" : "0.336",
            "y" : "0.31",
            "heigth" : "0.25",
            "width" : "0.25"
        }
    ]
}
