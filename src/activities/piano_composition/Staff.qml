/* GCompris - Staff.qml
 *
 * SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
