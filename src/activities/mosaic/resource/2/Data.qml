/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Up to 8 items, on a single line.")
    difficulty: 2

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
            "nbOfCells": 6,
            "layout": [
                [6,1]
            ],
            "modelDisplayLayout": "smaller",
            "images": images.slice(3,9)
        },
        {
            "nbOfCells": 7,
            "layout": [
                [7,1]
            ],
            "modelDisplayLayout": "smaller",
            "images": images.slice(2,9)
        },
        {
            "nbOfCells": 8,
            "layout": [
                [8,1]
            ],
            "modelDisplayLayout": "smaller",
            "images": images.slice(5,13)
        }
    ]
}
