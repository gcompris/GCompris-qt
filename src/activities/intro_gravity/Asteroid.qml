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

import QtQuick 2.6
import "intro_gravity.js" as Activity
import "../../core"
import GCompris 1.0

Image {
    id: asteroid
    sourceSize.height: 100 * ApplicationInfo.ratio
    z: 5

    property alias fallDuration: down.duration

    function startMoving() {
        down.restart()
    }


    NumberAnimation {
        id: down
        target: asteroid
        property: "y"
        to: parent.height
    }
}
