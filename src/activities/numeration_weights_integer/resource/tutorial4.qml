/* GCompris - tutorial4.qml
 *
 * Copyright (C) 2019 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
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
import QtQuick 2.13
import GCompris 1.0

import "../../../core"
import "../../../activities"

import "../numeration_weights_integer.js" as Activity


Item {
    id: tutorial4

    readonly property int animation_DURATION: 1000

    Component.onCompleted: {
        console.log("tutorial4_screen_loaded")
        okButtonAnimation.running = true
    }

    NumberAnimation {
        id: okButtonAnimation

        target: okButton
        property: "opacity";
        to: 0.1
        duration: animation_DURATION

        onFinished: {
            console.log("test")
            okButton.opacity = 1
            Activity.checkAnswer()
        }
    }
}
