/* GCompris - ayushagrawal288.qml
 *
 * Copyright (C) 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
 *
 * Authors:
 *   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick)
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
import QtQuick 2.1
import GCompris 1.0

import "../../core"
import "../babymatch"

Babymatch {
    id: activity

    onStart: focus = true
    onStop: {}

    url: "qrc:/gcompris/src/activities/ayushagrawal288/resource/"
    levelCount: 2
    answerGlow: false

    IntroMessage {
        id: message
        anchors {
            top: parent.top
            topMargin: 50
            right: parent.right
            rightMargin: 5
            left: parent.left
            leftMargin: 100
        }

        intro: [
            qsTr("First, click on any of the monuments to select it"
                 +" then drag it to the respective place in the map where it is situated."),
            qsTr("And then drop it by releasing the mouse.")
        ]
    }
}


