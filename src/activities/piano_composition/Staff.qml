/* GCompris - Staff.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"

Item {
    id: staff

    property Item main: activity.main

    property int verticalDistanceBetweenLines: height / nbLines

    // Stave
    readonly property int nbLines: 5

    property bool lastPartition: false

    readonly property int yShift: activity.horizontalLayout ? 0 : 1.5

    Repeater {
        id: staffLines
        model: nbLines
        Rectangle {
            width: staff.width
            height: activity.horizontalLayout ? 5 : 3
            border.width: height / 2
            color: "black"
            y: index * verticalDistanceBetweenLines + yShift
        }
    }

    // Ending vertical line of the staff.
    Rectangle {
        id: staffEndLine
        width: activity.horizontalLayout ? 5 : 3
        border.width: width / 2
        height: (nbLines - 1) * verticalDistanceBetweenLines + width
        color: "black"
        x: staff.width
        y: yShift
    }

    // The 2nd vertical line denoting the end of multiple staves
    Rectangle {
        id: multiStaffEndLine
        width: activity.horizontalLayout ? 5 : 3
        border.width: width / 2
        height: (nbLines - 1) * verticalDistanceBetweenLines + width
        visible: lastPartition
        color: "black"
        x: staff.width - 10
        y: yShift
    }
}
