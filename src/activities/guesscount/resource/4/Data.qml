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
    objective: qsTr(" Practice algebraic calculations with four operators.")
    difficulty: 6

    data: [
        {
            "dataItems": [
                [
                   [ ['+','-','*','/'],[  [[1,7,2,3,2],13] ,[[8,1,5,2,3],6] ,[[1,7,2,4,2],5] ,[[9,7,8,2,4],4]] ]
                ]
            ],
            "levelSchema": [3],
            "defaultOperators": [['+','-','*','/']]
        }

    ]
}
