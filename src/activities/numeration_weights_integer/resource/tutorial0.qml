/* GCompris - tutorial0.qml
 *
 * Copyright (C) 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
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
    id: tutorial0

    Component.onCompleted: {
        console.log("tutorial0_screen_loaded")

        //this is not a good solution, it does not work if tutorial0 is called before initLevel() is finished //?

        console.log("yyyyyyyyyyyyyyyyyyyy")
        Activity.numbersToConvert.unshift(1204)
        Activity.items.numberToConvertRectangle.text = Activity.numbersToConvert[0]
        console.log(Activity.numbersToConvert)
    }
}
