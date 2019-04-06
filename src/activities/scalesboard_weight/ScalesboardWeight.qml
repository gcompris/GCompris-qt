/* GCompris - Scalesboard.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import "../scalesboard"

Scalesboard {

    function g(value) {
        /* g == gram */
        return qsTr("%1 g").arg(value)
    }

    function kg(value) {
        /* kg == kilogram */
        return qsTr("%1 kg").arg(value)
    }

    dataset: [
            {
                "masses": [[1, kg(1)], [2, kg(2)], [2, kg(2)], [5, kg(5)],
                          [5, kg(5)], [10, kg(10)], [10, kg(10)]],
                "targets": [[3, kg(3)], [4, kg(4)], [6, kg(6)], [7, kg(7)], [8, kg(8)], [9, kg(9)]],
                "rightDrop": false,
                "message": qsTr('The "kg" symbol at the end of a number means kilogram.') + " " +
                           qsTr('The kilogram is a unit of mass, a property which corresponds to the ' +
                                'common perception of how "heavy" an object is.')
            },
            {
                "masses": [[100, g(100)], [200, g(200)], [200, g(200)], [500, g(500)],
                          [500, g(500)], [1000, g(1000)], [1000, g(1000)]],
                "targets": [[300, g(300)], [400, g(400)], [600, g(600)], [700, g(700)],
                           [800, g(800)], [900, g(900)]],
                "rightDrop": false,
                "message": qsTr('The "g" symbol at the end of a number means gram. One kilogram equals 1000 grams')
            },
            {
                "masses": [[100, g(100)], [200, g(200)], [200, g(200)], [500, g(500)],
                          [500, g(500)], [1000, kg(1)], [1000, kg(1)]],
                "targets": [[1200, kg(1.2)], [1300, kg(1.3)], [1400, kg(1.4)],
                           [1500, kg(1.5)], [1600, kg(1.6)]],
                "rightDrop": false,
                "message": qsTr('Remember, one kilogram ("kg") equals 1000 grams ("g").')
            },
            {
                "masses": [[200, g(200)], [500, g(500)], [1000, kg(1)], [1000, kg(1)], [1200, kg(1.2)]],
                "targets": [[300, g(300)], [800, g(800)], [1300, kg(1.3)]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale.")
            },
            {
                "masses": [[200, g(200)], [400, g(400)], [700, g(700)], [1000, kg(1)], [1200, kg(1.2)]],
                "targets": [[300, g(300)], [500, g(500)], [800, g(800)], [900, g(900)]],
                "rightDrop": true
            },
            {
                "masses": [[500, g(500)], [800, g(800)], [900, g(900)], [1000, kg(1)],
                          [1100, kg(1.1)], [1200, kg(1.2)]],
                "targets": [[600, g(600)], [700, g(700)], [1300, kg(1.3)], [1400, kg(1.4)],
                           [1500, kg(1.5)], [1600, kg(1.6)], [1700, kg(1.7)], [1800, kg(1.8)]],
                "rightDrop": true
            },
            {
                "masses": [[1, kg(1)], [2, kg(2)], [2, kg(2)], [5, kg(5)],
                          [5, kg(5)], [1, kg(10)], [1, kg(10)]],
                "targets": [[3, kg(3)], [4, kg(4)], [6, kg(6)], [7, kg(7)], [8, kg(8)], [9, kg(9)]],
                "rightDrop": false,
                "message": qsTr("Now you have to guess the weight of the gift."),
                "question": qsTr("Enter the weight of the gift in kilogram: %1")
            },
            {
                "masses": [[100, g(100)], [200, g(200)], [200, g(200)], [500, g(500)],
                          [500, g(500)], [1000, g(1000)], [1000, g(1000)]],
                "targets": [[300, g(300)], [400, g(400)], [600, g(600)], [700, g(700)],
                           [800, g(800)], [900, g(900)]],
                "rightDrop": false,
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[2, kg(2)], [2, kg(2)], [5, kg(5)], [5, kg(5)], [5, kg(5)]],
                "targets": [[8, kg(8)], [11, kg(11)], [13, kg(13)]],
                "rightDrop": true,
                "message": qsTr("Take care, you can drop weights on both sides of the scale."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[100, g(100)], [200, g(200)], [200, g(200)], [500, g(500)],
                          [500, g(500)], [1000, kg(1)], [1000, kg(1)]],
                "targets": [[1200, kg(1.2)], [1300, kg(1.3)], [1400, kg(1.4)],
                           [1500, kg(1.5)], [1600, kg(1.6)]],
                "rightDrop": false,
                "message": qsTr("Remember, one kilogram ('kg') equals 1000 grams ('g')."),
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[200, g(200)], [500, g(500)], [1000, kg(1)], [1000, kg(1)], [1200, kg(1.2)]],
                "targets": [[300, g(300)], [800, g(800)], [1300, kg(1.3)]],
                "rightDrop": true,
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[200, g(200)], [400, g(400)], [700, g(700)], [1000, kg(1)], [1200, kg(1.2)]],
                "targets": [[300, g(300)], [500, g(500)], [800, g(800)], [900, g(900)]],
                "rightDrop": true,
                "question": qsTr("Enter the weight of the gift in gram: %1")
            },
            {
                "masses": [[500, g(500)], [800, g(800)], [900, g(900)], [1000, kg(1)],
                          [1100, kg(1.1)], [1200, kg(1.2)]],
                "targets": [[600, g(600)], [700, g(700)], [1300, kg(1.3)], [1400, kg(1.4)],
                           [1500, kg(1.5)], [1600, kg(1.6)], [1700, kg(1.7)], [1800, kg(1.8)]],
                "rightDrop": true,
                "question": qsTr("Enter the weight of the gift in gram: %1")
            }
]

}
