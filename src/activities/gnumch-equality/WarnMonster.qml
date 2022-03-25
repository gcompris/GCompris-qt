/* GCompris - WarnMonster.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

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

    width: warningText.contentWidth * 1.1
    height: warningText.height * 1.1
    opacity: 0
    border.width: 2
    border.color: "#373737"
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
