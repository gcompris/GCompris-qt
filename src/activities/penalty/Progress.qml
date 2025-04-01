/* GCompris - Progress.qml
*
* SPDX-FileCopyrightText: 2017 Rohit Das <rohit.das950@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

import "../../core"
import "penalty.js" as Activity

Rectangle {
    id: progress
    property real ratio: 0
    property SequentialAnimation anim: anim
    color: "#80ffffff"
    visible: ratio > 0

    Rectangle {
        id: fillRectangle
        height: parent.height - GCStyle.tinyMargins
        width: (parent.width - GCStyle.tinyMargins) * progress.ratio
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: GCStyle.tinyMargins * 0.5
        color: progress.ratio < 1 ? "#00FF00" : "#FF0000"
    }

    SequentialAnimation {
        id: anim
        PropertyAnimation {
            target: progress
            property: "ratio"
            from: 0
            to: 1
            duration: items.duration
        }
        ScriptAction {
            script: { Activity.levelFailed(); }
        }
    }
}
