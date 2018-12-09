/* GCompris - KeyOption.qml
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

Item {
    id: clefOption
    
    property alias clefButtonIndex: clefButton.currentIndex
    property bool clefButtonVisible: false
    signal clefAdded
    
    width: optionsRow.iconsWidth * 2
    height: optionsRow.iconsWidth
    visible: clefButtonVisible
    Rectangle {
        color: "yellow"
        opacity: 0.1
        border.width: 2
        border.color: "black"
        anchors.fill: parent
        radius: 10
    }
    
    SwitchableOptions {
        id: clefButton
        nbOptions: 2
        source: "qrc:/gcompris/src/activities/piano_composition/resource/" + (!currentIndex ? "trebbleClefButton.svg"
        : "bassClefButton.svg")
        width: optionsRow.iconsWidth * 0.9
        sourceSize.width: width
        visible: clefButtonVisible
        onClicked: {
            //: Treble clef and Bass clef are the notations to indicate the pitch of the sound written on it.
            emitOptionMessage(!currentIndex ? qsTr("Treble clef") : qsTr("Bass clef"))
        }
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
    
    BarButton {
        id: addClefButton
        width: clefButton.width
        sourceSize.width: width
        source: "qrc:/gcompris/src/activities/piano_composition/resource/add.svg"
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        visible: clefButton.visible
        onClicked: {
            background.clefType = !clefButton.currentIndex ? "Treble" : "Bass"
            emitOptionMessage(!clefButton.currentIndex ? qsTr("Added Treble clef") : qsTr("Added Bass clef"))
            parent.scale = 1
            clefAdded()
        }
    }
}
