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
import core 1.0

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
        color: GCStyle.lightTransparentBg
        border.width: GCStyle.thinnestBorder
        border.color: GCStyle.blueBorder
        anchors.fill: parent
        radius: GCStyle.halfMargins
    }

    SwitchableOptions {
        id: clefButton
        nbOptions: 2
        source: "qrc:/gcompris/src/activities/piano_composition/resource/" + (!currentIndex ? "trebbleClefButton.svg"
        : "bassClefButton.svg")
        width: optionsRow.iconsWidth - 2 * GCStyle.tinyMargins
        visible: clefButtonVisible
        onClicked: {
            //: Treble clef and Bass clef are the notations to indicate the pitch of the sound written on it.
            emitOptionMessage(!currentIndex ? qsTr("Treble clef") : qsTr("Bass clef"))
        }
        anchors.left: parent.left
        anchors.leftMargin: GCStyle.tinyMargins
        anchors.verticalCenter: parent.verticalCenter
    }

    BarButton {
        id: addClefButton
        width: clefButton.width
        source: "qrc:/gcompris/src/activities/piano_composition/resource/add.svg"
        anchors.right: parent.right
        anchors.rightMargin: GCStyle.tinyMargins
        anchors.verticalCenter: parent.verticalCenter
        visible: clefButton.visible
        onClicked: {
            activityBackground.clefType = !clefButton.currentIndex ? "Treble" : "Bass"
            emitOptionMessage(!clefButton.currentIndex ? qsTr("Treble clef added") : qsTr("Bass clef added"))
            parent.scale = 1
            clefAdded()
        }
    }
}
