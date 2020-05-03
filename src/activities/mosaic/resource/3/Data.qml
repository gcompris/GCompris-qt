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
    objective: qsTr("Up to 16 items are placed on multiple lines.")
    difficulty: 3

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
            "nbOfCells": 8,
            "layout": [
                [4,2],
                [8,1]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.7,
            "images": images.slice(0,8)
        },
        {
            "nbOfCells": 8,
            "layout": [
                [4,2],
                [8,1]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.7,
            "images": images.slice(1,9)
        },
        {
            "nbOfCells": 8,
            "layout": [
                [4,2],
                [8,1]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.7,
            "images": images.slice(2,10)
        },
        {
            "nbOfCells": 8,
            "layout": [
                [4,2],
                [8,1]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.7,
            "images": images.slice(3,11)
        },
        {
            "nbOfCells": 16,
            "layout": [
                [4,4],
                [8,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.7,
            "images": images.slice(4,20)
        },
        {
            "nbOfCells": 16,
            "layout": [
                [4,4],
                [8,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.7,
            "images": images.slice(5,21)
        },
        {
            "nbOfCells": 16,
            "layout": [
                [4,4],
                [8,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.7,
            "images": images.slice(6,22)
        },
        {
            "nbOfCells": 16,
            "layout": [
                [4,4],
                [8,2]
            ],
            "modelDisplayLayout": "doubleColumn",
            "scaleGridRatio": 1.7,
            "images": images.slice(2,18)
        }
    ]
}
