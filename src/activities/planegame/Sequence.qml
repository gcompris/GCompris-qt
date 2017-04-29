/* GCompris - Score.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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

Planegame {

    dataset: [
        {
            data: "0 1 2 3 4 5 6 7 8 9 10".split(" "),
            showNext: true
        },
        {
            data: "10 11 12 13 14 15 16 17 18 19 20".split(" "),
            showNext: true
        },
        {
            data: "0 1 2 3 4 5 6 7 8 9 10".split(" "),
            showNext: false
        },
        {
            data: "10 11 12 13 14 15 16 17 18 19 20".split(" "),
            showNext: false
        }
    ]
}
