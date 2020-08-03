/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
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
    objective: qsTr("Subtractions with 1, 2, 3, 4 and 5.")
    difficulty: 3

    data: [
        {
            questionsArray: ["2 - 1", "3 - 1", "3 - 2", "4 - 1", "4 - 2", "4 - 3", "5 - 1", "5 - 2", "5 - 3", "5 - 4"],
            answersArray: [1,2,1,3,2,1,4,3,2,1],
            circlesModel: 5

        }
    ]
}
