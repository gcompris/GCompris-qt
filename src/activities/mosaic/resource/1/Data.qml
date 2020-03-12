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
import "../../../../core"

Dataset {
    objective: qsTr("Rebuid the mosaic when items are on single line.")
    difficulty: 1
    data: [
        {
            "nbItems": 2,
            "questionLayout": {2: [2,1]},
            "selectorLayout": {2: [2,1]}

        },
        {
            "nbItems": 3,
            "questionLayout": {3: [3,1]},
            "selectorLayout": {3: [3,1]}

        },
        {
            "nbItems": 4,
            "questionLayout": {4: [4,1]},
            "selectorLayout": {4: [4,1]}

        },
        {
            "nbItems": 5,
            "questionLayout": {5: [5,1]},
            "selectorLayout": {5: [5,1]}

        },
        {
            "nbItems": 6,
            "questionLayout": {6: [6,1]},
            "selectorLayout": {6: [6,1]}

        },
        {
            "nbItems": 8,
            "questionLayout": {8: [8,1]},
            "selectorLayout": {8: [8,1]}

        }

    ]
}
