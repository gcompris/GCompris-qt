/* GCompris - PaintCursor.qml
 *
 * SPDX-FileCopyrightText: 2018 Bruno Coudoin <bruno.coudoin@gcompris.net>
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

Item {
    id: cursor
    property int nbX: 0
    property int nbY: 0
    Image {
        width: parent.height * 0.9
        height: width
        sourceSize.width: width
        sourceSize.height: width
        source: Activity.url + "cursor.svg"
        visible: true
        anchors.centerIn: parent
    }
}
