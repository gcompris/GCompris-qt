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

import QtQuick 2.6
import GCompris 1.0
import GCompris 1.0

Data {
    objective: qsTr("Guess a number between 1 and %1").arg(Number(1000).toLocaleString(Qt.locale(ApplicationInfo.localeShort), 'f', 0))
    difficulty: 3
    data: [
        {
            // first number is the minimum number and second is the maximum number
            "objective" : qsTr("Guess a number between 1 and %1").arg(10),
            "maxNumber" : 10
        },
        {
            "objective" : qsTr("Guess a number between 1 and %1").arg(100),
            "maxNumber" : 100
        },
        {
            "objective" : qsTr("Guess a number between 1 and %1").arg(Number(1000).toLocaleString(Qt.locale(ApplicationInfo.localeShort), 'f', 0)),
            "maxNumber" : 1000
        }
    ]
}
