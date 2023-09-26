/* GCompris - FractionsCreate.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "fractions_create.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string mode: "selectPie" // or "findFraction" in fractions_find activity
    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/magic-hat-minus/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

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
            property alias numberOfSubLevels: score.numberOfSubLevels
            property alias currentSubLevel: score.currentSubLevel
            property alias instructionText: instructionTxt.text
            property alias chartItem: chartDisplay
            property alias numeratorValue: numeratorText.value
            property alias denominatorValue: denominatorText.value
            readonly property bool horizontalLayout: background.width >= background.height
            readonly property string mode: activity.mode
            property int numeratorToFind: 0
            property int denominatorToFind: 0
            readonly property var levels: activity.datasetLoader.data
            property string chartType: "pie"
            property bool fixedNumerator: true
            property bool fixedDenominator: true
        }

        onStart: {
            Activity.start(items, activity.mode);
        }
        onStop: { Activity.stop() }

        Keys.enabled: !bonus.isPlaying

        Keys.onPressed: {
            if([Qt.Key_Enter, Qt.Key_Return].indexOf(event.key) != -1 && items.itemIndex !== -1) {
                okButton.clicked();
            }
        }

        //instruction rectangle
        Rectangle {
            id: instruction
            anchors.centerIn: instructionTxt
            width: instructionTxt.width + 20
            height: instructionTxt.height
            opacity: 0.8
            radius: 10
            border.width: 2
            z: 10
            border.color: "#DDD"
            color: "#373737"
        }
        //instruction for playing the game
        GCText {
            id: instructionTxt
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: regularSize
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.9, text.length * 8), parent.width * 0.5)
            wrapMode: TextEdit.WordWrap
        }

        Item {
            id: layoutArea
            width: parent.width - 20
            height: parent.height - instructionTxt.height - bar.height * 1.2 - 30
            anchors.top: instruction.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: chartLayoutArea
            width: layoutArea.width - okButton.width - 10 * ApplicationInfo.ratio
            height: layoutArea.height
            anchors {
                top: layoutArea.top
                left: layoutArea.left
            }
        }

        Item {
            id: rightLayoutArea
            width:  layoutArea.width - chartLayoutArea.width
            height: layoutArea.height
            anchors.top: layoutArea.top
            anchors.right: layoutArea.right
        }

        ChartDisplay {
            id: chartDisplay
            layoutWidth: chartLayoutArea.width
            layoutHeight: chartLayoutArea.height
            anchors.centerIn: chartLayoutArea
        }

        Item {
            id: fractionTextDisplay
            width: rightLayoutArea.width
            anchors.top: rightLayoutArea.top
            anchors.bottom: okButton.top
            anchors.bottomMargin: 10 * ApplicationInfo.ratio

            FractionNumber {
                id: numeratorText
                value: 0
                width: parent.width
                height: 30 * ApplicationInfo.ratio
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: fractionBar.bottom
                anchors.bottomMargin: 10
                interactive: activity.mode === "findFraction" && !items.fixedNumerator
                onLeftClicked: {
                    if(items.numeratorValue > 0) {
                        items.numeratorValue --;
                    }
                }
                onRightClicked: {
                    items.numeratorValue ++;
                }
            }
            Rectangle {
                id: fractionBar
                width: parent.width
                height: 5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
            }
            FractionNumber {
                id: denominatorText
                value: 0
                width: parent.width
                height: numeratorText.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: fractionBar.bottom
                anchors.topMargin: 10
                interactive: activity.mode === "findFraction" && !items.fixedDenominator
                onLeftClicked: {
                    if(items.denominatorValue > 0) {
                        items.denominatorValue --;
                    }
                }
                onRightClicked: {
                    items.denominatorValue ++;
                }
            }
        }

        BarButton {
            id: okButton
            enabled: !bonus.isPlaying
            anchors {
                bottom: score.top
                bottomMargin: 10 * ApplicationInfo.ratio
                horizontalCenter: rightLayoutArea.horizontalCenter
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 60 * ApplicationInfo.ratio

            onClicked: {
                chartDisplay.checkAnswer();
            }
        }

        Score {
            id: score
            anchors {
                top: undefined
                bottom: rightLayoutArea.bottom
                horizontalCenter: rightLayoutArea.horizontalCenter
            }
        }

        states: [
            State {
                name: "horizontalState"
                when: items.horizontalLayout
                AnchorChanges {
                    target: fractionTextDisplay
                    anchors.left: chartDisplay.right
                }
            },
            State {
                name: "verticalState"
                when: !items.horizontalLayout
                AnchorChanges {
                    target: fractionTextDisplay
                    anchors.left: rightLayoutArea.left
                }
            }
        ]

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onClose: {
                home()
            }
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }

}
