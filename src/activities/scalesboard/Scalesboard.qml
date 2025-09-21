/* GCompris - Scalesboard.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import core 1.0

import "../../core"
import "scalesboard.js" as Activity

ActivityBase {
    id: activity


    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: activityBackground
        anchors.fill: parent
        color: "#DAE7A7"
        signal start
        signal stop

        property int scaleHeight: items.masseAreaLeft.weight == items.masseAreaRight.weight ? 0 :
                                 items.masseAreaLeft.weight > items.masseAreaRight.weight ? 20 : -20

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias errorRectangle: errorRectangle
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property int giftWeight
            property int scaleHeight: activityBackground.scaleHeight
            readonly property var levels: activity.datasets
            property alias masseAreaCenter: masseAreaCenter
            property alias masseAreaLeft: masseAreaLeft
            property alias masseAreaRight: masseAreaRight
            property alias masseCenterModel: masseAreaCenter.masseModel
            property alias masseRightModel: masseAreaRight.masseModel
            property alias question: question
            property alias numpad: numpad
            property bool rightDrop
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool isHorizontal: activityBackground.width > activityBackground.height

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/win.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: metalSound
            source: Activity.url + "metal_hit.wav"
        }

        Rectangle {
            id: floor
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: bar.height * 0.5
            color: "#947f7f"
        }

        Rectangle {
            id: tableFront
            anchors.bottom: floor.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: scaleBoard.bottom
            anchors.topMargin: GCStyle.baseMargins * 2
            color: "#64b2a2"
        }

        Rectangle {
            id: tableTopFront
            anchors.top: scaleBoard.bottom
            anchors.topMargin: GCStyle.baseMargins
            anchors.bottom: tableFront.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: "#8a948c"
        }

        Rectangle {
            id: tableTop
            height: scaleBoard.height * 0.25 + GCStyle.baseMargins
            anchors.bottom: tableTopFront.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: "#bac4ba"
        }

        Image {
            id: tomatoes
            source: Activity.url + "tomatoes.svg"
            anchors.right: scaleBoard.left
            anchors.bottom: scaleBoard.bottom
            sourceSize.height: scaleBoard.height * 0.6
        }

        Image {
            id: leeks
            source: Activity.url + "leeks.svg"
            anchors.left: scaleBoard.right
            anchors.bottom: scaleBoard.bottom
            sourceSize.height: tomatoes.sourceSize.height
        }

        Item {
            id: layoutArea
            anchors.top: instructionPanel.bottom
            anchors.bottom: okButton.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: numpad.columnWidth
            anchors.topMargin: GCStyle.baseMargins * 3
            anchors.bottomMargin: GCStyle.baseMargins
        }

        Image {
            id: scaleBoard
            source: Activity.url + "scale.svg"
            sourceSize.width: Math.min(layoutArea.width, layoutArea.height * 2)
            anchors.centerIn: layoutArea

            Image {
                id: needle
                source: Activity.url + "needle.svg"
                sourceSize.width: parent.width * 0.75
                z: -1
                property int angle: - activityBackground.scaleHeight * 0.35
                anchors {
                    horizontalCenter: scaleBoard.horizontalCenter
                    verticalCenter: scaleBoard.verticalCenter
                    verticalCenterOffset: -scaleBoard.paintedHeight * 0.15
                }
                transform: Rotation {
                    origin.x: needle.width * 0.5
                    origin.y: needle.height * 0.9
                    angle: needle.angle
                }
                Behavior on angle {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            // === The Left plate ===
            Image {
                id: plateLeft
                source: Activity.url + "plate.svg"
                sourceSize.width: parent.width * 0.35
                z: -10

                anchors {
                    horizontalCenter: scaleBoard.horizontalCenter
                    horizontalCenterOffset: -scaleBoard.paintedWidth * 0.3
                    verticalCenter: scaleBoard.verticalCenter
                    verticalCenterOffset: -scaleBoard.paintedHeight * 0.03 + activityBackground.scaleHeight
                }
                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            // The Left Drop Area
            MasseArea {
                id: masseAreaLeft
                width: plateLeft.width
                anchors {
                    horizontalCenter: scaleBoard.horizontalCenter
                    horizontalCenterOffset: -scaleBoard.paintedWidth * 0.3
                    verticalCenter: scaleBoard.verticalCenter
                    verticalCenterOffset: -scaleBoard.paintedHeight * 0.44 + activityBackground.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                metalSound: metalSound
                nbColumns: 3

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            // === The Right plate ===
            Image {
                id: plateRight
                source: Activity.url + "plate.svg"
                sourceSize.width: parent.width * 0.35
                z: -10
                anchors {
                    horizontalCenter: scaleBoard.horizontalCenter
                    horizontalCenterOffset: scaleBoard.paintedWidth * 0.3
                    verticalCenter: scaleBoard.verticalCenter
                    verticalCenterOffset: -scaleBoard.paintedHeight * 0.03 - activityBackground.scaleHeight
                }
                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            // The Right Drop Area
            MasseArea {
                id: masseAreaRight
                width: plateRight.width
                anchors {
                    horizontalCenter: scaleBoard.horizontalCenter
                    horizontalCenterOffset: scaleBoard.paintedWidth * 0.3
                    verticalCenter: scaleBoard.verticalCenter
                    verticalCenterOffset: -scaleBoard.paintedHeight * 0.44 - activityBackground.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                metalSound: metalSound
                nbColumns: 3
                dropEnabledForThisLevel: items.rightDrop

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            // === The Initial Masses List ===
            MasseArea {
                id: masseAreaCenter
                x: parent.width * 0.08
                y: parent.height * 0.86 - height
                width: parent.width * 0.84
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                metalSound: metalSound
                nbColumns: masseModel.count
            }
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * numpad.columnWidth
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            hideIfEmpty: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            color: GCStyle.lightTransparentBg
            border.width: 0
            textItem.color: GCStyle.darkText
        }

        Question {
            id: question
            parent: scaleBoard
            anchors.horizontalCenter: scaleBoard.horizontalCenter
            anchors.bottom: scaleBoard.bottom
            width: scaleBoard.width
            height: scaleBoard.height * 0.5
            z: 1000
            answer: items.giftWeight
            visible: (items.question.text && activityBackground.scaleHeight === 0) ? true : false
        }

        ErrorRectangle {
            id: errorRectangle
            z: 1010
            parent: scaleBoard
            height: parent.height * 0.5
            radius: GCStyle.baseMargins
            imageSize: okButton.width
            function releaseControls() {
                items.buttonsBlocked = false;
            }
            states: [
                State {
                    when: question.visible
                    AnchorChanges {
                        target: errorRectangle
                        anchors.left: question.left
                        anchors.right: question.right
                        anchors.top: question.top
                        anchors.bottom: question.bottom
                    }
                },
                State {
                    when: !question.visible
                    AnchorChanges {
                        target: errorRectangle
                        anchors.left: plateLeft.right
                        anchors.right: plateRight.left
                        anchors.top: scaleBoard.top
                        anchors.bottom: undefined
                    }
                }
            ]
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                activity.levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                // restart activity on saving
                activityBackground.start()
            }
            onClose: {
                activity.home()
            }
            onStartActivity: {
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
            anchors.left: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.5
            enabled: !items.buttonsBlocked && (items.question.text ?  items.question.userEntry : masseAreaLeft.weight != 0)
            ParticleSystemStarLoader {
                id: okButtonParticles
                clip: false
            }
            onClicked: {
                Activity.checkAnswer();
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                activity.displayDialog(dialogActivityConfig)
            }
            onLevelChanged: instructionPanel.textItem.text = items.levels[bar.level - 1].message ? items.levels[bar.level - 1].message : ""
        }

        Score {
            id: score
            anchors.bottom: undefined
            anchors.top: undefined
            anchors.right: okButton.left
            anchors.rightMargin: GCStyle.baseMargins
            anchors.verticalCenter: okButton.verticalCenter
            onStop: { Activity.nextSubLevel(); }
        }

        NumPad {
            id: numpad
            onAnswerChanged: question.userEntry = answer
            maxDigit: ('' + items.giftWeight).length + 1
            opacity: question.visible ? 1 : 0
            columnWidth: 50 * ApplicationInfo.ratio
            enableInput: !items.buttonsBlocked
        }

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            if(okButton.enabled && (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
                    Activity.checkAnswer()
            }
            else if(question.visible) {
                    numpad.updateAnswer(event.key, true);
            }
        }

        Keys.onReleased: (event) => {
            if(question.visible) {
                numpad.updateAnswer(event.key, false);
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
