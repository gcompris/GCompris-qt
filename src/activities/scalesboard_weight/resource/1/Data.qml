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
    objective: qsTr("Balance up to 5 grams.")
    difficulty: 2

    function g(value) {
        /* g == gram */
        return qsTr("%1 g").arg(value)
    }

    data: [
        {
            "masses": [[1, g(1)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)]],
            "targets": [[3, g(3)], [4, g(4)], [5, g(5)]],
            "rightDrop": false,
            "message": qsTr('The "g" symbol at the end of a number means gram.')
        },
        {
            "masses": [[6, g(6)], [9, g(9)], [2, g(2)], [7, g(7)], [6, g(6)], [7, g(7)], [8, g(8)]],
            "targets": [[4, g(4)], [3, g(3)], [5, g(5)]],
            "rightDrop": true,
            "message": qsTr("Take care, you can drop weights on both sides of the scale."),
        },
        {
            "masses": [[1, g(1)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)], [1, g(1)], [2, g(2)]],
            "targets": [[4, g(4)], [3, g(3)], [5, g(5)]],
            "rightDrop": false,
            "message": qsTr("Now you have to guess the weight of the gift."),
            "question": qsTr("Enter the weight of the gift in grams: %1")
        }
    ]
}
