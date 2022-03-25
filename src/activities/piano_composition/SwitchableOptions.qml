/* GCompris - SwitchableOptions.qml
*
* SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
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
