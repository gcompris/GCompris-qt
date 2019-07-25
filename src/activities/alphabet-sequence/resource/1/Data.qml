
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
    objective: qsTr("Select letters in alphabetical order")
    difficulty: 1
    data: [
        {
            data: qsTr("a/b/c/d/e").split("/"),
            showNext: true
        },
        {
            data: qsTr("f/g/h/i/j/k").split("/"),
            showNext: true
        },
        {
            data: qsTr("a/b/c/d/e/f/g/h/i/j/k").split("/"),
            showNext: false
        },
        {
            data: qsTr("l/m/n/o/p").split("/"),
            showNext: false
        },
        {
            data: qsTr("q/r/s/t/u").split("/"),
            showNext: false
        },
        {
            data: qsTr("a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u").split("/"),
            showNext: false
        },
        {
            data: qsTr("u/v/w/x/y/z").split("/"),
            showNext: false
        },
        {
            data: qsTr("a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z").split("/"),
            showNext: false
        }
    ]
}
