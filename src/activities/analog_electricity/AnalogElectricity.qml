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
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "analog_electricity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
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

        property bool hori: activityBackground.width >= activityBackground.height

        Component.onCompleted: {
            dialogActivityConfig.initialize();
            activity.start.connect(start);
            activity.stop.connect(stop);
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: [tutorialInstruction]

        Keys.onPressed: (event) => {
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
            property alias activityBackground: activityBackground
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
            property real toolsMargin: 83 * ApplicationInfo.ratio
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

        Item {
            id: introArea
            anchors {
                fill: parent
                topMargin: (activityBackground.hori ? 0 : inputComponentsContainer.height) + GCStyle.baseMargins
                rightMargin: GCStyle.baseMargins
                leftMargin: (activityBackground.hori ? inputComponentsContainer.width : 0) + GCStyle.baseMargins
                bottomMargin: bar.height * 2
            }
        }

        IntroMessage {
            id: tutorialInstruction
            intro: []
            customIntroArea: introArea
            z: 100
        }

        onStart: Activity.start(items);
        onStop: {
            resizeTimer.stop();
            netlistTimer.stop();
            Activity.stop();
        }

        Item {
            id: visibleArea
            width:activityBackground.width - items.toolsMargin - GCStyle.baseMargins
            height: activityBackground.height - bar.height - items.toolsMargin - GCStyle.baseMargins
            anchors {
                fill: undefined
                top: parent.top
                topMargin: GCStyle.halfMargins
                right: parent.right
                rightMargin: GCStyle.halfMargins
                left: inputComponentsContainer.right
                leftMargin: GCStyle.halfMargins
                bottom: bar.top
                bottomMargin: GCStyle.baseMargins
            }
            z: 6

            GCText {
                id: infoTxt
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: GCStyle.tinyMargins
                }
                fontSizeMode: Text.Fit
                minimumPixelSize: 10
                font.pixelSize: 150
                color: GCStyle.whiteText
                horizontalAlignment: (Core.isLeftToRightLocale(ApplicationSettings.locale)) ? Text.AlignLeft : Text.AlignRight
                width: Math.min(implicitWidth, 0.90 * parent.width)
                height: Math.min(implicitHeight, 0.7 * parent.height)
                wrapMode: TextEdit.WordWrap
                visible: false
                z: 4
            }

            Rectangle {
                id: infoTxtContainer
                anchors.fill: parent
                radius: GCStyle.halfMargins
                color: GCStyle.darkBg
                border.width: GCStyle.thinnestBorder
                border.color: GCStyle.lightBorder
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
                height: source == "" ? 0 : parent.height * 0.3 - GCStyle.halfMargins
                width: source == "" ? 0 : parent.width - GCStyle.halfMargins
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
            width: activityBackground.width * 4 - items.toolsMargin
            height: activityBackground.height * 4 - (bar.height * 1.1)

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
            height: activityBackground.height
            color: "#4A3823"
            anchors.left: parent.left
            Image {
                id: containerTexture
                anchors.fill: parent
                anchors.rightMargin: GCStyle.midBorder
                source: Activity.urlDigital + "texture01.webp"
                fillMode: Image.Tile
                ListWidget {
                    id: availablePieces
                }
            }
            z: 10
        }

        Rectangle {
            id: toolTip
            anchors {
                bottom: bar.top
                bottomMargin: GCStyle.halfMargins
                left: inputComponentsContainer.left
                leftMargin: GCStyle.halfMargins
            }
            width: toolTipTxt.width + GCStyle.baseMargins
            height: toolTipTxt.height + GCStyle.halfMargins
            color: GCStyle.darkBg
            opacity: 0
            radius: GCStyle.halfMargins
            z: 100
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.lightBorder
            property alias text: toolTipTxt.text
            Behavior on opacity { NumberAnimation { duration: 120 } }

            function show(newText: string) {
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
                color: GCStyle.whiteText
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
                rightMargin: GCStyle.baseMargins
                bottomMargin: height * 0.5
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
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
                id: horizontalView
                when: activityBackground.hori
                PropertyChanges {
                    visibleArea {
                        width: activityBackground.width - items.toolsMargin - GCStyle.baseMargins
                        height: activityBackground.height - bar.height - items.toolsMargin - GCStyle.baseMargins
                    }
                }
                AnchorChanges {
                    target: visibleArea
                    anchors.top: parent.top
                    anchors.left: inputComponentsContainer.right
                }
                PropertyChanges {
                    playArea {
                        x: items.toolsMargin
                        y: 0
                        width: activityBackground.width * 4 - items.toolsMargin
                        height: activityBackground.height * 4 - (bar.height * 1.1)
                    }
                }
                PropertyChanges {
                    mousePan {
                        drag.maximumX: items.toolsMargin
                        drag.maximumY: 0
                    }
                }
                PropertyChanges {
                    inputComponentsContainer {
                        width: items.toolsMargin
                        height: activityBackground.height
                    }
                }
                PropertyChanges {
                    containerTexture {
                        anchors.rightMargin: GCStyle.midBorder
                        anchors.bottomMargin: 0
                    }
                }
            },
            State {
                id: verticalView
                when: !activityBackground.hori
                PropertyChanges {
                    visibleArea {
                        width: activityBackground.width - GCStyle.baseMargins
                        height: activityBackground.height - bar.height - GCStyle.baseMargins
                    }
                }
                AnchorChanges {
                    target: visibleArea
                    anchors.top: inputComponentsContainer.bottom
                    anchors.left: parent.left
                }
                PropertyChanges {
                    playArea {
                        x: 0
                        y: items.toolsMargin
                        width: activityBackground.width * 4
                        height: activityBackground.height * 4 - (bar.height * 1.1) - items.toolsMargin
                    }
                }
                PropertyChanges {
                    mousePan {
                        drag.maximumX: 0
                        drag.maximumY: items.toolsMargin
                    }
                }
                PropertyChanges {
                    inputComponentsContainer {
                        width: activityBackground.width
                        height: items.toolsMargin
                    }
                }
                PropertyChanges {
                    containerTexture {
                        anchors.rightMargin: 0
                        anchors.bottomMargin: GCStyle.midBorder
                    }
                }
            }
        ]
    }
}
