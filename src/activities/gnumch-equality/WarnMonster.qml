/* GCompris - WarnMonster.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"

Rectangle {
    property alias text: warningText

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        timerWarn.stop();
    }

    opacity: 0
    color: GCStyle.lightBg
    border.width: GCStyle.thinnestBorder
    border.color: GCStyle.darkBorder
    radius: GCStyle.halfMargins

    GCText {
        id: warningText
        text: qsTr("Be careful, a troggle!")
        fontSize: largeSize
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
        anchors.margins: GCStyle.halfMargins
        anchors.leftMargin: GCStyle.baseMargins
        anchors.rightMargin: GCStyle.baseMargins
        color: "red"
    }

    onOpacityChanged: timerWarn.start()

    Timer {
        id: timerWarn
        interval: 3000

        onTriggered: parent.opacity = 0
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }
}
