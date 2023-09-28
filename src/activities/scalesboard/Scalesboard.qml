/* GCompris - Scalesboard.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "scalesboard.js" as Activity
import "."

ActivityBase {
    id: activity


    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
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
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property int numberOfSubLevels
            property int currentSubLevel
            property int giftWeight
            property int scaleHeight: background.scaleHeight
            readonly property var levels: activity.datasetLoader.data
            property alias masseAreaCenter: masseAreaCenter
            property alias masseAreaLeft: masseAreaLeft
            property alias masseAreaRight: masseAreaRight
            property alias masseCenterModel: masseAreaCenter.masseModel
            property alias masseRightModel: masseAreaRight.masseModel
            property alias question: question
            property alias numpad: numpad
            property bool rightDrop
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool isHorizontal: background.width > background.height
        property bool scoreAtBottom: bar.width * 6 + okButton.width * 1.5 + score.width < background.width

        Image {
            id: scaleBoard
            source: Activity.url + "scale.svg"
            sourceSize.width: isHorizontal ? Math.min(parent.width - okButton.height * 2,
                                                      (parent.height - okButton.height * 2) * 2) : parent.width
            anchors.centerIn: parent
            anchors.verticalCenterOffset: scoreAtBottom ? 0 : okButton.height * -0.5
        }

        Image {
            id: needle
            parent: scaleBoard
            source: Activity.url + "needle.svg"
            sourceSize.width: parent.width * 0.75
            z: -1
            property int angle: - background.scaleHeight * 0.35
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.15
            }
            transform: Rotation {
                origin.x: needle.width / 2
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
            parent: scaleBoard
            source: Activity.url + "plate.svg"
            sourceSize.width: parent.width * 0.35
            z: -10

            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: - parent.paintedWidth * 0.3
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.03 + background.scaleHeight
            }
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            // The Left Drop Area
            MasseArea {
                id: masseAreaLeft
                parent: scaleBoard
                width: plateLeft.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: - parent.paintedWidth * 0.3
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - parent.paintedHeight * 0.44 + background.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                nbColumns: 3
                audioEffects: activity.audioEffects

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // === The Right plate ===
        Image {
            id: plateRight
            parent: scaleBoard
            source: Activity.url + "plate.svg"
            sourceSize.width: parent.width * 0.35
            z: -10
            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: parent.paintedWidth * 0.3
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.03 - background.scaleHeight
            }
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            // The Right Drop Area
            MasseArea {
                id: masseAreaRight
                parent: scaleBoard
                width: plateRight.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.paintedWidth * 0.3
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - parent.paintedHeight * 0.44 - background.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                nbColumns: 3
                dropEnabledForThisLevel: items.rightDrop
                audioEffects: activity.audioEffects

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // === The Initial Masses List ===
        MasseArea {
            id: masseAreaCenter
            parent: scaleBoard
            x: parent.width * 0.05
            y: parent.height * 0.84 - height
            width: parent.width
            masseAreaCenter: masseAreaCenter
            masseAreaLeft: masseAreaLeft
            masseAreaRight: masseAreaRight
            nbColumns: masseModel.count
            audioEffects: activity.audioEffects
        }

        Message {
            id: message
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 10
                left: parent.left
                leftMargin: 10
            }
        }

        Question {
            id: question
            parent: scaleBoard
            anchors.horizontalCenter: scaleBoard.horizontalCenter
            anchors.top: masseAreaCenter.top
            anchors.bottom: masseAreaCenter.bottom
            z: 1000
            width: isHorizontal ? parent.width * 0.5 : background.width - 160 * ApplicationInfo.ratio
            answer: items.giftWeight
            visible: (items.question.text && background.scaleHeight === 0) ? true : false
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
                // restart activity on saving
                background.start()
            }
            onClose: {
                home()
            }
            onStartActivity: {
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 60 * ApplicationInfo.ratio
            enabled: !bonus.isPlaying && masseAreaLeft.weight != 0
            visible: (!question.text || items.question.userEntry) ? true : false
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
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onLevelChanged: message.text = items.levels[bar.level - 1].message ? items.levels[bar.level - 1].message : ""
        }

        Score {
            id: score
            numberOfSubLevels: items.numberOfSubLevels
            currentSubLevel: items.currentSubLevel
        }

        states: [
            State {
                name: "horizontalLayout"; when: background.scoreAtBottom
                AnchorChanges {
                    target: score
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.right: okButton.left
                    anchors.verticalCenter: okButton.verticalCenter
                }
                AnchorChanges {
                    target: okButton
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: bar.verticalCenter
                    anchors.bottom: undefined
                    anchors.right: background.right
                    anchors.left: undefined
                }
                PropertyChanges {
                    target: okButton
                    anchors.bottomMargin: 0
                    anchors.rightMargin: okButton.width * 0.5
                    anchors.verticalCenterOffset: -10
                }
            },
            State {
                name: "verticalLayout"; when: !background.scoreAtBottom
                AnchorChanges {
                    target: score
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.right: okButton.left
                    anchors.verticalCenter: okButton.verticalCenter
                }
                AnchorChanges {
                    target: okButton
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                    anchors.bottom: bar.top
                    anchors.right: undefined
                    anchors.left: background.horizontalCenter
                }
                PropertyChanges {
                    target: okButton
                    anchors.bottomMargin: okButton.height * 0.5
                    anchors.rightMargin: 0
                    anchors.verticalCenterOffset: 0
                }
            }
        ]

        NumPad {
            id: numpad
            onAnswerChanged: question.userEntry = answer
            maxDigit: ('' + items.giftWeight).length + 1
            opacity: question.visible ? 1 : 0
            columnWidth: 60 * ApplicationInfo.ratio
            enableInput: !bonus.isPlaying
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: {
            if(okButton.visible && (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
                    Activity.checkAnswer()
            }
            else if(question.visible) {
                    numpad.updateAnswer(event.key, true);
            }
        }

        Keys.onReleased: {
            if(question.visible) {
                numpad.updateAnswer(event.key, false);
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }

}
