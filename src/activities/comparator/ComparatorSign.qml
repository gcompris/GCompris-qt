/* GCompris - ComparatorSign.qml
*
* SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Johnny Jazeix <jazeix@gmail.com>
*   Timothée Giet <animtim@gmail.com>
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

import "../../core"

Item {
    id: signButton
    property string signValue
    property bool isSelected: false

    signal clicked

    onClicked: {
        symbolSelectionList.enterSign(signButton.signValue);
    }

    Component.onCompleted: {
        actualButton.clicked.connect(clicked)
    }

    BarButton {
        id: actualButton
        anchors.centerIn: parent
        width: Math.min(parent.width - GCStyle.baseMargins, parent.height)
        source: signButton.signValue == "=" ? "qrc:/gcompris/src/activities/comparator/resource/equal.svg" :
                                    "qrc:/gcompris/src/activities/comparator/resource/superior.svg"
        rotation: signButton.signValue == "<" ? 180 : 0
        enabled: !bonus.isPlaying

        Rectangle {
            z: -1
            anchors.fill: parent
            radius: width * 0.5
            color: "#34FFFFFF"
            border.color: signButton.isSelected ? GCStyle.whiteBorder : "#34000000"
            border.width: signButton.isSelected ? GCStyle.midBorder : GCStyle.thinBorder
        }
    }
}
