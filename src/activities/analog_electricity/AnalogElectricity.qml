/* GCompris - AnalogElectricity.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (DigitalElectricity code)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (DigitalElectricity code)
 *   Timothée Giet <animtim@gmail.com> (mouse drag refactoring)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (Qt Quick port of AnalogElectricity)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "analog_electricity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.urlDigital + "texture02.webp"
        fillMode: Image.Tile
        signal start
        signal stop

        onWidthChanged: resizeTimer.restart();
        onHeightChanged: resizeTimer.restart();

        Timer {
            id: resizeTimer
            interval: 200
            repeat: false
            running: false
            triggeredOnStart: false
            onTriggered: Activity.updateWiresOnResize();
        }

        Timer {
            id: netlistTimer
            interval: 500
            repeat: false
            running: false
            triggeredOnStart: false
            onTriggered: Activity.createNetlist();
        }

        property bool hori: background.width >= background.height

        Component.onCompleted: {
            dialogActivityConfig.initialize();
            activity.start.connect(start);
            activity.stop.connect(stop);
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: tutorialInstruction

        Keys.onPressed: {
            if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && okButton.enabled) {
                Activity.checkAnswer()
            }
            if (event.key === Qt.Key_Plus) {
                Activity.zoomIn();
            }
            if (event.key === Qt.Key_Minus) {
                Activity.zoomOut();
            }
            if (event.key === Qt.Key_Right) {
                playArea.x -= 200;
            }
            if (event.key === Qt.Key_Left) {
                playArea.x += 200;
            }
            if (event.key === Qt.Key_Up) {
                playArea.y += 200;
            }
            if (event.key === Qt.Key_Down) {
                playArea.y -= 200;
            }
            if (playArea.x >= mousePan.drag.maximumX) {
                playArea.x = mousePan.drag.maximumX;
            }
            if (playArea.y >= mousePan.drag.maximumY) {
                playArea.y = mousePan.drag.maximumY;
            }
            if (playArea.x <= mousePan.drag.minimumX) {
                playArea.x = mousePan.drag.minimumX;
            }
            if (playArea.y <= mousePan.drag.minimumY) {
                playArea.y = mousePan.drag.minimumY;
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias playArea: playArea
            property alias mousePan: mousePan
            property alias availablePieces: availablePieces
            property alias tutorialDataset: tutorialDataset
            property alias toolTip: toolTip
            property alias infoTxt: infoTxt
            property alias infoImage: infoImage
            property alias dataset: dataset
            property alias netlistTimer: netlistTimer
            property real toolsMargin: 90 * ApplicationInfo.ratio
            property real zoomLvl: 0.25
            property string mode: "tutorial"
            property bool isTutorialMode: mode == "tutorial" ? true : false
            property alias tutorialInstruction: tutorialInstruction

        }

        Loader {
            id: dataset
            asynchronous: false
        }

        TutorialDataset {
            id: tutorialDataset
        }

        IntroMessage {
            id: tutorialInstruction
            intro: []
            textContainerWidth: background.hori ? parent.width - inputComponentsContainer.width - items.toolsMargin : 0.9 * background.width
            textContainerHeight: background.hori ? 0.5 * parent.height : parent.height - inputComponentsContainer.height - (bar.height * 2) - items.toolsMargin
            anchors {
                fill: undefined
                top: background.hori ? parent.top : inputComponentsContainer.bottom
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: background.hori ? inputComponentsContainer.right : parent.left
                leftMargin: 5
            }
            z: 5
        }

        onStart: Activity.start(items);
        onStop: {
            resizeTimer.stop();
            netlistTimer.stop();
            Activity.stop();
        }

        Rectangle {
            id: visibleArea
            color: "#00000000"
            width:background.width - items.toolsMargin - 10
            height: background.height - bar.height - items.toolsMargin - 10
            anchors {
                fill: undefined
                top: parent.top
                topMargin: 5
                right: parent.right
                rightMargin: 5
                left: inputComponentsContainer.right
                leftMargin: 5
                bottom: bar.top
                bottomMargin: 20
            }
            z: 6

            GCText {
                id: infoTxt
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 2
                }
                fontSizeMode: Text.Fit
                minimumPixelSize: 10
                font.pixelSize: 150
                color: "white"
                horizontalAlignment: Text.AlignHLeft
                width: Math.min(implicitWidth, 0.90 * parent.width)
                height: Math.min(implicitHeight, 0.7 * parent.height)
                wrapMode: TextEdit.WordWrap
                visible: false
                z: 4
            }

            Rectangle {
                id: infoTxtContainer
                anchors.fill: parent
                opacity: 1
                radius: 10
                color: "#373737"
                border.width: 2
                border.color: "#F2F2F2"
                visible: infoTxt.visible
                MouseArea {
                    anchors.fill: parent
                    onClicked: infoTxt.visible = false
                }
                z: 3
            }

            Image {
                id: infoImage
                property bool imgVisible: false
                height: source == "" ? 0 : parent.height * 0.3 - 10
                width: source == "" ? 0 : parent.width - 10
                fillMode: Image.PreserveAspectFit
                visible: infoTxt.visible && imgVisible
                anchors {
                    top: infoTxt.bottom
                    horizontalCenter: infoTxtContainer.horizontalCenter
                }
                z: 5
            }
        }

        Rectangle {
            id: playArea
            color: "#10000000"
            x: items.toolsMargin
            y: 0
            width: background.width * 4 - items.toolsMargin
            height: background.height * 4 - (bar.height * 1.1)

            property double sizeMultiplier:
                playArea.width > playArea.height ? playArea.width : playArea.height

            PinchArea {
                id: pinchZoom
                anchors.fill: parent
                onPinchFinished: {
                    if (pinch.scale < 1) {
                        Activity.zoomOut();
                    }
                    if (pinch.scale > 1) {
                        Activity.zoomIn();
                    }
                }
                MouseArea {
                    id: mousePan
                    anchors.fill: parent
                    scrollGestureEnabled: false //needed for pinchZoom
                    drag.target: playArea
                    drag.axis: Drag.XandYAxis
                    drag.minimumX: - playArea.width * items.zoomLvl
                    drag.maximumX: items.toolsMargin
                    drag.minimumY: - playArea.height * items.zoomLvl
                    drag.maximumY: 0
                    onClicked: {
                        Activity.disableToolDelete();
                        Activity.deselect();
                        availablePieces.hideToolbar();
                    }
                }
            }
        }

        Rectangle {
            id: inputComponentsContainer
            width: items.toolsMargin
            height: background.height
            color: "#4A3823"
            anchors.left: parent.left
            Image {
                id: containerTexture
                anchors.fill: parent
                anchors.rightMargin: 3 * ApplicationInfo.ratio
                anchors.bottomMargin: 0
                source: Activity.urlDigital + "texture01.webp"
                fillMode: Image.Tile
                ListWidget {
                    id: availablePieces
                    hori: background.hori
                }
            }
            z: 10
        }

        Rectangle {
            id: toolTip
            anchors {
                bottom: bar.top
                bottomMargin: 10
                left: inputComponentsContainer.left
                leftMargin: 5
            }
            width: toolTipTxt.width + 10
            height: toolTipTxt.height + 5
            color: "#373737"
            opacity: 0
            radius: 10
            z: 100
            border.width: 2
            border.color: "#F2F2F2"
            property alias text: toolTipTxt.text
            Behavior on opacity { NumberAnimation { duration: 120 } }

            function show(newText) {
                if(newText) {
                    text = newText;
                    opacity = 1;
                } else {
                    opacity = 0;
                }
            }

            GCText {
                id: toolTipTxt
                anchors.centerIn: parent
                fontSize: regularSize
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home();
        }

        BarButton {
            id: okButton
            visible: items.isTutorialMode
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                bottomMargin: height * 0.5
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 60 * ApplicationInfo.ratio
            enabled: !tutorialInstruction.visible && !bonus.isPlaying
            onClicked: Activity.checkAnswer();
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | (items.isTutorialMode ? level : 0) | reload | activityConfig }
            onHelpClicked: displayDialog(dialogHelp);
            onPreviousLevelClicked: Activity.previousLevel();
            onNextLevelClicked: Activity.nextLevel();
            onHomeClicked: home();
            onReloadClicked: Activity.reset();
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig);
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel);
        }

        states: [
            State {
                id: "horizontalView"
                when: background.hori
                PropertyChanges {
                    target: visibleArea
                    width: background.width - items.toolsMargin - 10
                    height: background.height - bar.height - items.toolsMargin - 10
                }
                AnchorChanges {
                    target: visibleArea
                    anchors.top: parent.top
                    anchors.left: inputComponentsContainer.right
                }
                PropertyChanges {
                    target: playArea
                    x: items.toolsMargin
                    y: 0
                    width: background.width * 4 - items.toolsMargin
                    height: background.height * 4 - (bar.height * 1.1)
                }
                PropertyChanges {
                    target: mousePan
                    drag.maximumX: items.toolsMargin
                    drag.maximumY: 0
                }
                PropertyChanges {
                    target: inputComponentsContainer
                    width: items.toolsMargin
                    height: background.height
                }
                PropertyChanges {
                    target: containerTexture
                    anchors.rightMargin: 3 * ApplicationInfo.ratio
                    anchors.bottomMargin: 0
                }
            },
            State {
                id: "verticalView"
                when: !background.hori
                PropertyChanges {
                    target: visibleArea
                    width: background.width - 10
                    height: background.height - bar.height - 10
                }
                AnchorChanges {
                    target: visibleArea
                    anchors.top: inputComponentsContainer.bottom
                    anchors.left: parent.left
                }
                PropertyChanges {
                    target: playArea
                    x: 0
                    y: items.toolsMargin
                    width: background.width * 4
                    height: background.height * 4 - (bar.height * 1.1) - items.toolsMargin
                }
                PropertyChanges {
                    target: mousePan
                    drag.maximumX: 0
                    drag.maximumY: items.toolsMargin
                }
                PropertyChanges {
                    target: inputComponentsContainer
                    width: background.width
                    height: items.toolsMargin
                }
                PropertyChanges {
                    target: containerTexture
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 3 * ApplicationInfo.ratio
                }
            }
        ]
    }
}
