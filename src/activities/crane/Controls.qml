/* GCompris - Controls.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import "crane.js" as Activity

Image {
    property string command
    height: parent.paintedHeight * 0.75
    sourceSize.width: height
    fillMode: Image.PreserveAspectFit
    anchors {
        verticalCenter: parent.verticalCenter
    }
    MouseArea {
        anchors.fill: parent
        onPressed: parent.opacity = 0.6
        onReleased: parent.opacity = 1
        onClicked: {
            Activity.move(command)
        }
    }
}
