/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 * Authors:
 *   Sambhav Kaul <sambhav.kaul12@gmail.com>
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
    objective: qsTr("Guess a number between 1 and %1").arg(20)
    difficulty: 1
    data: [
        {
            // first number is the minimum number and second is the maximum number
            "objective" : qsTr("Guess a number between 1 and %1").arg(10),
            "maxNumber" : 10
        },
        {
            "objective" : qsTr("Guess a number between 1 and %1").arg(15),
            "maxNumber" : 15
        },
        {
            "objective" : qsTr("Guess a number between 1 and %1").arg(20),
            "maxNumber" : 20
        }
    ]
}
