/* GCompris - OperandRow.qml
 *
 * SPDX-FileCopyrightText: 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import "../../core"

Row {
    id: operandRow
    property alias repeater: repeater
    property int rowSum
    spacing: 20
    Repeater {
        id: repeater
        delegate: DragTile {
            id: root
            type: "operands"
            width: operandRow.width*0.1
            height: operandRow.height
        }
    }
}
