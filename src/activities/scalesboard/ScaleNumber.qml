/* GCompris - Scalesboard.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

Scalesboard {
    dataset: [
            {
                "masses": [1, 2, 2, 5, 5, 10, 10],
                "targets": [3, 4, 6, 7, 8, 9],
                "rightDrop": false
            },
            {
                "masses": [1, 2, 2, 5, 5, 10, 10],
                "targets": [12, 13, 14, 15, 16],
                "rightDrop": false
            },
            {
                "masses": [2, 2, 5, 5, 5],
                "targets": [8, 11, 13],
                "rightDrop": true
            },
            {
                "masses": [2, 5, 10, 10],
                "targets": [3, 8, 13],
                "rightDrop": true
            },
            {
                "masses": [2, 4, 7, 10],
                "targets": [3, 5, 8, 9],
                "rightDrop": true
            },
            {
                "masses": [5, 8, 9, 10, 11, 12],
                "targets": [6, 7, 13, 14, 15, 16, 17, 18],
                "rightDrop": true
            }
]



}
