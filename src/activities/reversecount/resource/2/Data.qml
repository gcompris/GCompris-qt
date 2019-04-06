/* GCompris - Data.qml
 *
 * Copyright (C) 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
import GCompris 1.0
import "../../../../core"

Dataset {
    objective: qsTr("Numbers between 2 and 18")
    difficulty: 2
    data: [
    {
        "minNumber": 2,
        "maxNumber": 5,
        "numberOfFish": 5
    },
    {
        "minNumber": 3,
        "maxNumber": 6,
        "numberOfFish": 5
    },
    {
        "minNumber": 4,
        "maxNumber": 7,
        "numberOfFish": 5
    },
    {
        "minNumber": 4,
        "maxNumber": 8,
        "numberOfFish": 5
    },
    {
        "minNumber": 5,
        "maxNumber": 9,
        "numberOfFish": 5
    }
    ]
}
