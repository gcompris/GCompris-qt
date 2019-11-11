/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
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
    objective: qsTr("Learn to calculate remaining stars up to 1000 with coefficients")
    difficulty: 5
    data: [
    {
        "maxValue": 1000,
        "minStars" : [2, 0, 0],
        "maxStars" : [100, 0, 0] 
    },
    {
        "maxValue": 1000,
        "minStars" : [2, 2, 0],
        "maxStars" : [100, 100, 0] 
    },
    {
        "minStars" : [2, 2, 2],
        "maxStars" : [200, 200, 100]
    },
    {
        "minStars" : [2, 2, 2],
        "maxStars" : [300, 300, 100]
    },
    {
        "maxValue": 1000,
        "minStars" : [2, 2, 2],
        "maxStars" : [400, 400, 200]
    }
    ]
}
