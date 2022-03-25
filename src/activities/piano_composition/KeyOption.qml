/* GCompris - KeyOption.qml
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
            emitOptionMessage(!clefButton.currentIndex ? qsTr("Treble clef added") : qsTr("Bass clef added"))
            parent.scale = 1
            clefAdded()
        }
    }
}
