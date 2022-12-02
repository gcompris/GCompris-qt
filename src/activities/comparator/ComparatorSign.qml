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

BarButton {
    id: signButton
    height: parent.height
    width: parent.height
    sourceSize.height: height * scale
    source: signValue == "=" ? "qrc:/gcompris/src/activities/comparator/resource/equal.svg" :
                                "qrc:/gcompris/src/activities/comparator/resource/superior.svg"
    rotation: signValue == "<" ? 180 : 0
    property string signValue
    property bool isSelected: false

    enabled: !bonus.isPlaying

    onClicked: {
        symbolSelectionList.enterSign(signValue);
    }
    Rectangle {
        z: -1
        anchors.fill: parent
        radius: width * 0.5
        color: "#34FFFFFF"
        border.color: isSelected ? "#FFFFFF" : "#34000000"
        border.width: isSelected ? 6 : 4
    }
}
