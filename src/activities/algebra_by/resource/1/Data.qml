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
    objective: qsTr("This is a long long long long objective. We want to see it it can display long long texts. But it is not long long long enough. Or maybe it is...")
    data: [
    {
        "maxNumber": 1, /* Max number on each domino side */
        "minNumber": 1,
        "numberOfFish": 3
    },
    {
        "maxNumber": 2,
        "minNumber": 1,
        "numberOfFish": 4
    },
    {
        "maxNumber": 3,
        "minNumber": 1,
        "numberOfFish": 5
    },
    {
        "maxNumber": 4,
        "minNumber": 1,
        "numberOfFish": 5
    }
    ]
}
