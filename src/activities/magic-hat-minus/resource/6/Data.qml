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
import GCompris 1.0

Data {
    //: Coefficients are the numbers by which the numbers of stars are multiplied to get the total
    objective: qsTr("Calculate remaining stars up to 10000 with coefficients.")
    difficulty: 6
    data: [
    {
        "maxValue": 10000,
        "minStars" : [2, 0, 0],
        "maxStars" : [1000, 0, 0]
    },
    {
        "maxValue": 10000,
        "minStars" : [2, 2, 0],
        "maxStars" : [1000, 1000, 0]
    },
    {
        "maxValue": 10000,
        "minStars" : [2, 2, 2],
        "maxStars" : [2000, 2000, 1000]
    },
    {
        "maxValue": 10000,
        "minStars" : [2, 2, 2],
        "maxStars" : [3000, 3000, 1000]
    },
    {
        "maxValue": 10000,
        "minStars" : [2, 2, 2],
        "maxStars" : [4000, 4000, 2000]
    }
   ]
}
