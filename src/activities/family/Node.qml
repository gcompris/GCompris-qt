/* GCompris - Node.qml
 *
 * SPDX-FileCopyrightText: 2016 Rajdeep Kaur <rajdeep.kaur@kde.org>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *
 *   Rajdeep Kaur <rajdeep.kaur@kde.org>
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

Rectangle {
    id: nodeItem
    required property int xPosition
    required property int yPosition
    required property string nodeValue
    required property string currentState
    required property int nodeWeight

    property alias nodeImageSource: nodeImage.source

    radius: width * 0.5

    function changeState(state_) {
        currentPointer.state = state_
    }

    Image {
        id: nodeImage
        source: nodeImageSource
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.7
        height: width
        sourceSize.width: width
        sourceSize.height: width

        SequentialAnimation {
            id: activeAnimation
            running: currentPointer.state === "active" || currentPointer.state === "activeTo"
            loops: Animation.Infinite
            alwaysRunToEnd: true
            NumberAnimation {
                target: nodeImage
                property: "rotation"
                from: 0; to: 10
                duration: 200
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: nodeImage
                property: "rotation"
                from: 10; to: -10
                duration: 400
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: nodeImage
                property: "rotation"
                from: -10; to: 0
                duration: 200
                easing.type: Easing.InQuad
            }
        }
    }

    MouseArea {
        visible: activity.mode == "find_relative" ? true : false
        anchors.fill: parent
        onClicked: selectedPairs.selectNode(currentPointer)
    }
}
