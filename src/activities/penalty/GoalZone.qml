/* GCompris - GoalZone.qml
*
* SPDX-FileCopyrightText: 2017 Rohit Das <rohit.das950@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

import './penalty.js' as Activity

Item {
    id: goalZone
    required property Progress progress
    required property string side

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: Activity.changeBallState(goalZone.side, goalZone.progress)
    }
}
