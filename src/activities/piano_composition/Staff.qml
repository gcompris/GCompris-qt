/* GCompris - Staff.qml
 *
 * SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"

Item {
    id: staff
    // staff main lines are centered vertically, and there is extra empty space above/under for other notes...
    required property int index
    required property int nbLines
    required property int lineHeight
    required property int lineThickness

    property bool lastPartition: false

    Repeater {
        id: staffLines
        model: staff.nbLines
        Rectangle {
            width: staff.width
            height: staff.lineThickness
            color: "black"
            y: (index + 4) * staff.lineHeight
        }
    }

    // Ending vertical line of the staff.
    Rectangle {
        id: staffEndLine
        width: staff.lastPartition ? staff.lineThickness * 2 : staff.lineThickness
        height: (staff.nbLines - 1) * staff.lineHeight + staff.lineThickness
        color: "black"
        x: staff.width - width
        y: 4 * staff.lineHeight
    }

    // The 2nd vertical line denoting the end of multiple staves
    Rectangle {
        id: multiStaffEndLine
        width: staff.lineThickness
        height: (staff.nbLines - 1) * staff.lineHeight + staff.lineThickness
        visible: staff.lastPartition
        color: "black"
        x: staff.width - 4 * staff.lineThickness
        y: staffEndLine.y
    }
}
