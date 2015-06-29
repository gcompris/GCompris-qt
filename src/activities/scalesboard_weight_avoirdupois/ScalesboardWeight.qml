/* GCompris - ScalesboardWeight.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import "../scalesboard"

Scalesboard {

    function oz(value) {
        /* oz == ounce */
        return qsTr("%1 oz").arg(value)
    }

    function lb(value) {
        /* lb == pound */
        return qsTr("%1 lb").arg(value)
    }

    dataset: [
            {
                "masses": [[1, lb(1)], [2, lb(2)], [2, lb(2)], [5, lb(5)],
                          [5, lb(5)], [10, lb(10)], [10, lb(10)]],
                "targets": [[3, lb(3)], [4, lb(4)], [6, lb(6)], [7, lb(7)], [8, lb(8)], [9, lb(9)]],
                "rightDrop": false,
                "message": qsTr('The "lb" symbol at the end of a number means pound.') + " " +
                           qsTr('The pound is a unit of mass, a property which corresponds to the ' +
                                'common perception of how "heavy" an object is. This unit is used in the USA.')
            },
            {
                "masses": [[1, oz(1)], [2, oz(2)], [2, oz(2)], [4, oz(4)],
                          [8, oz(8)], [16, oz(16)]],
                "targets": [[3, oz(3)], [4, oz(4)], [6, oz(6)], [7, oz(7)],
                           [16, oz(16)], [24, oz(24)], [28, oz(28)]],
                "rightDrop": false,
                "message": qsTr('The "oz" symbol at the end of a number means ounce. One pound equals sixteen ounces')
            },
            {
                "masses": [[4, oz(4)], [4, oz(4)], [8, oz(8)], [8, oz(8)],
                          [8, oz(8)], [16, lb(1)]],
                "targets": [[16, lb(1)], [20, oz(20)], [32, lb(2)],
                           [28, oz(28)]],
                "rightDrop": false,
                "message": qsTr('Remember, one pound ("lb") equals sixteen ounces ("oz").')
            },
            {
                "masses": [[1, oz(1)], [4, oz(4)], [6, oz(6)], [8, oz(8)],
                          [10, oz(10)], [16, lb(1)]],
                "targets": [[3, oz(3)], [9, oz(9)], [11, oz(11)], [32, lb(2)]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale.")
            },
            {
                "masses": [[4, oz(4)], [4, oz(4)], [8, oz(8)], [8, oz(8)],
                          [8, oz(8)], [16, lb(1)]],
                "targets": [[16, lb(1)], [20, oz(20)], [32, lb(2)],
                           [28, oz(28)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in ounce: %1")
            },
            {
                "masses": [[1, oz(1)], [4, oz(4)], [6, oz(6)], [8, oz(8)],
                          [10, oz(10)], [16, lb(1)]],
                "targets": [[3, oz(3)], [9, oz(9)], [11, oz(11)], [32, lb(2)]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale."),
                "question": qsTr("Enter the weight of the gift in ounce: %1")
            }
]

}
