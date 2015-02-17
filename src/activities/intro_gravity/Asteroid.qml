/*GCompris :- intro_gravity.qml
*
* Copyright (C) 2015 Siddhesh suthar <siddhesh.it@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
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
import "intro_gravity.js" as Activity
import "../../core"
import GCompris 1.0

Image {
    id: asteroid

    property Item background
    property Item items
    property real fallDuration

    fillMode: Image.PreserveAspectFit

    sourceSize.height: 60 * ApplicationInfo.ratio
    x: 0
    y: 5
    z: 5

    Component.onCompleted: {
        x =  Math.floor(Math.random() * (background.width-200) )
        x = x<150 ? x-150 : x
        y =  5
    }

    function startMoving(dur){
        down.duration = dur
        down.restart()
    }


    NumberAnimation {
        id: down
        target: asteroid
        property: "y"
        to: parent.height
        duration: 10000

    }
}
