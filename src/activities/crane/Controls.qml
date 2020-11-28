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

import QtQuick 2.6
import "crane.js" as Activity

Image {
    property string command
    sourceSize.width: background.portrait ? parent.width * 0.175 : parent.width * 0.17
    sourceSize.height: background.portrait ? parent.height * 0.6 : parent.height * 0.48
    width: background.portrait ? parent.width * 0.175 : parent.width * 0.17
    height: background.portrait ? parent.height * 0.6 : parent.height * 0.48
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
