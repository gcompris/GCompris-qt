/* GCompris - FoldablePanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Rectangle {
    id: foldablePanel

    color: items.panelColor
    border.color: items.contentColor

    property real handleOffset
    property alias icon1Source: icon1.source
    property alias icon2Source: icon2.source
    property alias icon2Opacity: icon2.opacity
    property alias icon2Rotation: icon2.rotation
    property alias icon2Mirror: icon2.mirror
    property bool isOpen: false
    property bool isAnimationRunning: false

    property alias icon2: icon2 // needed for ColorsPanel color display on handle

    signal close()

    function toggleOpen() {
        foldablePanel.isOpen = !foldablePanel.isOpen;
        if(foldablePanel.isOpen) {
            items.openPanel = foldablePanel;
            if(items.isHorizontalLayout) {
                openAnimationX.start();
            } else {
                openAnimationY.start();
            }
        } else {
            items.openPanel = null;
            if(items.isHorizontalLayout) {
                closeAnimationX.start();
            } else {
                closeAnimationY.start();
            }
        }
    }

    function forceClose() {
        foldablePanel.state = "empty"
        if(items.isHorizontalLayout) {
            foldablePanel.state = "horizontalLayout";
        } else {
            foldablePanel.state = "verticalLayout";
        }
        foldablePanel.isOpen = false;
        foldablePanel.isAnimationRunning = false;
        foldablePanel.close();
        items.openPanel = null;
        foldablePanel.z = 0;
    }

    // override MouseArea on canvas below
    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: handle
        z: -1
        width: items.panelHandleWidth
        height: items.panelHandleHeight
        radius: items.baseMargins
        color: items.panelColor
        border.color: items.contentColor

        Grid {
            x: items.baseMargins
            y: items.panelGridY
            spacing: items.baseMargins
            columns: items.panelHandleColumns
            rows: items.panelHandleRows

            Image {
                id: icon1
                height: items.buttonSize
                width: items.buttonSize
                sourceSize.width: items.buttonSize
                sourceSize.height: items.buttonSize
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: icon2
                height: items.buttonSize
                width: items.buttonSize
                sourceSize.width: items.buttonSize
                sourceSize.height: items.buttonSize
                fillMode: Image.PreserveAspectFit
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: items.openPanel == null || foldablePanel.isOpen
            onClicked: {
                if(!foldablePanel.isAnimationRunning)
                    foldablePanel.toggleOpen();
            }
        }
    }

    Rectangle {
        id: borderMask
        color: items.panelColor
    }

    NumberAnimation {
        id: openAnimationX
        target: foldablePanel
        property: "x"
        to: activityBackground.width - foldablePanel.width
        duration: 200
        easing.type: Easing.InOutQuad
        onStarted: {
            foldablePanel.isAnimationRunning = true;
            foldablePanel.z = 10;
            items.smudgeSound.play();
        }
        onStopped: {
            foldablePanel.isAnimationRunning = false;
        }
    }

    NumberAnimation {
        id: closeAnimationX
        target: foldablePanel
        property: "x"
        to: activityBackground.width
        duration: 200
        easing.type: Easing.InOutQuad
        onStarted: {
            foldablePanel.isAnimationRunning = true;
            items.smudgeSound.play();
            foldablePanel.close();
        }
        onStopped: {
            foldablePanel.isAnimationRunning = false;
            foldablePanel.z = 0;
        }
    }

    NumberAnimation {
        id: openAnimationY
        target: foldablePanel
        property: "y"
        to: 0
        duration: 200
        easing.type: Easing.InOutQuad
        onStarted: {
            foldablePanel.isAnimationRunning = true;
            foldablePanel.z = 10;
            items.smudgeSound.play();
        }
        onStopped: {
            foldablePanel.isAnimationRunning = false;
        }
    }

    NumberAnimation {
        id: closeAnimationY
        target: foldablePanel
        property: "y"
        to: -foldablePanel.height
        duration: 200
        easing.type: Easing.InOutQuad
        onStarted: {
            foldablePanel.isAnimationRunning = true;
            items.smudgeSound.play();
            foldablePanel.close();
        }
        onStopped: {
            foldablePanel.isAnimationRunning = false;
            foldablePanel.z = 0;
        }
    }

    states: [
        State {
            name: "horizontalLayout"
            when: items.isHorizontalLayout
            PropertyChanges {
                foldablePanel.width: activityBackground.width * 0.7
                foldablePanel.height: layoutArea.height
                foldablePanel.x: activityBackground.width
                foldablePanel.y: 0
                handle.anchors.topMargin: foldablePanel.handleOffset
                handle.anchors.rightMargin: -items.baseMargins
                handle.anchors.leftMargin: 0
                borderMask.width: foldablePanel.border.width
                borderMask.height: handle.height - 2 * foldablePanel.border.width
            }
            AnchorChanges {
                target: handle
                anchors.top: foldablePanel.top
                anchors.right: foldablePanel.left
                anchors.left: undefined
            }
            AnchorChanges {
                target: borderMask
                anchors.horizontalCenter: undefined
                anchors.verticalCenter: handle.verticalCenter
                anchors.left: foldablePanel.left
                anchors.bottom: undefined
            }
        },
        State {
            name: "verticalLayout"
            when: !items.isHorizontalLayout
            PropertyChanges {
                foldablePanel.width: activityBackground.width
                foldablePanel.height: activityBackground.height * 0.6
                foldablePanel.x: 0
                foldablePanel.y: -foldablePanel.height
                handle.anchors.topMargin: -items.baseMargins
                handle.anchors.rightMargin: 0
                handle.anchors.leftMargin: foldablePanel.handleOffset
                borderMask.width: handle.width - 2 * foldablePanel.border.width
                borderMask.height: foldablePanel.border.width
            }
            AnchorChanges {
                target: handle
                anchors.top: foldablePanel.bottom
                anchors.right: undefined
                anchors.left: foldablePanel.left

            }
            AnchorChanges {
                target: borderMask
                anchors.horizontalCenter: handle.horizontalCenter
                anchors.verticalCenter: undefined
                anchors.left: undefined
                anchors.bottom: foldablePanel.bottom
            }
        },
        State {
            name: "empty"
        }
    ]

}
