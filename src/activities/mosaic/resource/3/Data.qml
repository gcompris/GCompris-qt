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
        "oil_paint.svg",
        "tux.svg",
        "pencil.svg",
        "banana.svg",
        "mushroom.svg",
        "pencils_paper.svg",
        "pencils.svg",
        "orange.svg",
        "dice_1.svg",
        "dice_2.svg",
        "dice_3.svg",
        "dice_4.svg",
        "dice_5.svg",
        "dice_6.svg",
        "dice_7.svg",
        "dice_0.svg",
        "digital_dice0.svg",
        "digital_dice1.svg",
        "digital_dice2.svg",
        "digital_dice3.svg",
        "digital_dice4.svg",
        "digital_dice5.svg",
        "digital_dice6.svg",
        "digital_dice7.svg"
    ]

    data: [
        {
            "nbOfCells": 8,
            "layout": [
                [4,2]
            ],
            "modelDisplayLayout": "sameSize",
            "images": images.slice(0,8)
        },
        {
            "nbOfCells": 8,
            "layout": [
                [4,2]
            ],
            "modelDisplayLayout": "sameSize",
            "images": images.slice(1,9)
        },
        {
            "nbOfCells": 8,
            "layout": [
                [4,2]
            ],
            "modelDisplayLayout": "sameSize",
            "images": images.slice(2,10)
        },
        {
            "nbOfCells": 8,
            "layout": [
                [4,2]
            ],
            "modelDisplayLayout": "sameSize",
            "images": images.slice(3,11)
        },
        {
            "nbOfCells": 16,
            "layout": [
                [8,2]
            ],
            "modelDisplayLayout": "sameSize",
            "images": images.slice(4,20)
        },
        {
            "nbOfCells": 16,
            "layout": [
                [8,2]
            ],
            "modelDisplayLayout": "sameSize",
            "images": images.slice(5,21)
        },
        {
            "nbOfCells": 16,
            "layout": [
                [8,2]
            ],
            "modelDisplayLayout": "sameSize",
            "images": images.slice(6,22)
        },
        {
            "nbOfCells": 16,
            "layout": [
                [8,2]
            ],
            "modelDisplayLayout": "sameSize",
            "images": images.slice(2,18)
        }
    ]
}
