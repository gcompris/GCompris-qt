/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
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
import GCompris 1.0

Data {
    objective: qsTr("Up to 24 items are placed on multiple lines.")
    difficulty: 4

    property var images: [
        "aquarela_colors.svg",
        "giraffe.svg",
        "pencil.svg",
        "mouse_on_cheese.svg",
        "mushroom_house.svg",
        "pencils_paper.svg",
        "pencils.svg",
        "white_cake.svg",
        "die_1.svg",
        "die_2.svg",
        "die_3.svg",
        "die_4.svg",
        "die_5.svg",
        "die_6.svg",
        "die_7.svg",
        "die_0.svg",
        "digital_die0.svg",
        "digital_die1.svg",
        "digital_die2.svg",
        "digital_die3.svg",
        "digital_die4.svg",
        "digital_die5.svg",
        "digital_die6.svg",
        "digital_die7.svg"
    ]

    data: [
        {
            "nbOfCells": 24,
            "layout": [
                 [6,4],
                [12,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.9,
            "images": images.slice(0,24)
        },
        {
            "nbOfCells": 24,
            "layout": [
                [6,4],
                [12,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.9,
            "images": images.slice(0,24)
        },
        {
            "nbOfCells": 24,
            "layout": [
                [6,4],
                [12,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.9,
            "images": images.slice(0,24)
        },
        {
            "nbOfCells": 24,
            "layout": [
                [6,4],
                [12,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.9,
            "images": images.slice(0,24)
        },
        {
            "nbOfCells": 24,
            "layout": [
                [6,4],
               [12,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.9,
            "images": images.slice(0,24)
        },
        {
            "nbOfCells": 24,
            "layout": [
                [6,4],
               [12,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.9,
            "images": images.slice(0,24)
        },
        {
            "nbOfCells": 24,
            "layout": [
                [6,4],
               [12,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.9,
            "images": images.slice(0,24)
        },
        {
            "nbOfCells": 24,
            "layout": [
                [6,4],
               [12,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.9,
            "images": images.slice(0,24)
        }
    ]
}
