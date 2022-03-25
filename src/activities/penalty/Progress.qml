/* GCompris - Progress.qml
*
* SPDX-FileCopyrightText: 2017 Rohit Das <rohit.das950@gmail.com>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

Rectangle {
    id: progress
    property int ratio: 0
    property ParallelAnimation anim: animation
    opacity: items.progressBarOpacity
    anchors.top: parent.top
    anchors.topMargin: parent.height / parent.implicitHeight * 100
    width: ratio / 100 * parent.width / parent.implicitWidth * 200
    height: parent.height / parent.implicitHeight * 20
    ParallelAnimation {
        id: animation
        onRunningChanged: {
            if (!animation.running) {
                timerBonus.start()
            }
        }
        PropertyAnimation {
            target: progress
            property: "ratio"
            from: 0
            to: 100
            duration: items.duration
        }
        PropertyAnimation {
            target: progress
            property: "color"
            from: "#00FF00"
            to: "#FF0000"
            duration: items.duration
        }
    }
}
