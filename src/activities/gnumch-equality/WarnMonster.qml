/* GCompris - WarnMonster.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
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

Rectangle {
    property alias text: warningText

    width: warningText.contentWidth * 1.1
    height: warningText.height * 1.1
    opacity: 0
    border.width: 2
    radius: 5

    anchors.horizontalCenter: topPanel.horizontalCenter
    anchors.verticalCenter: topPanel.verticalCenter

    GCText {
        id: warningText
        text: qsTr("Be careful, a troggle!")
        fontSize: largeSize
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "red"
    }

    onOpacityChanged: timerWarn.start()

    Timer {
        id: timerWarn
        interval: 2500

        onTriggered: parent.opacity = 0
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 500
        }
    }
}
