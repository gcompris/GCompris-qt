/* GCompris - SwitchableOptions.qml
*
* Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
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

Image {
    id: switchableOptions

    property int currentIndex: 0
    property int nbOptions: 1
    
    signal clicked

    sourceSize.width: optionsRow.iconsWidth

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            parent.currentIndex = (parent.currentIndex + 1) % nbOptions
            //clickAnimation.start()
            parent.clicked()
        }
    }
    
    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: switchableOptions
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: switchableOptions
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: switchableOptions
                scale: 1.1
            }
        }
    ]
    
    Behavior on scale { NumberAnimation { duration: 70 } }
    Behavior on opacity { PropertyAnimation { duration: 200 } }
}
