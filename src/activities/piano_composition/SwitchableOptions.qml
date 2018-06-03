/* GCompris - SwitchableOptions.qml
*
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
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import GCompris 1.0

import "../../core"

Image {
    id: switchableOptions

    property int currentIndex: 0
    property int nbOptions: 1

    signal clicked

    sourceSize.width: optionsRow.iconsWidth
    anchors.top: parent.top
    anchors.topMargin: -6
    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.currentIndex = (parent.currentIndex + 1) % nbOptions
            clickAnimation.start()
            parent.clicked()
        }
    }

    SequentialAnimation {
        id: clickAnimation
        NumberAnimation {
            target: switchableOptions
            property: "scale"
            to: 0.7
            duration: 150
        }
        NumberAnimation {
            target: switchableOptions
            property: "scale"
            to: 1
            duration: 150
        }
    }
}
