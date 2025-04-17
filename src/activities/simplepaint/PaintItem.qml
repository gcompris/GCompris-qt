/* GCompris - PaintItem.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "simplepaint.js" as Activity
import core 1.0
import "../../core"

Rectangle {
    id: paint
    border.color: GCStyle.darkBorder

    function touched() {
        paint.color = Activity.getColor()
    }
}
