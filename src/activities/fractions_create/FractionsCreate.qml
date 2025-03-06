/* GCompris - FractionsCreate.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "fractions_create.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string mode: "selectPie" // or "findFraction" in fractions_find activity
    pageComponent: Image {
        id: activityBackground
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
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias errorRectangle: errorRectangle
            property alias numberOfSubLevels: score.numberOfSubLevels
            property alias score: score
            property alias instructionItem: instructionPanel.textItem
            property alias chartItem: chartDisplay
            property alias numeratorValue: numeratorText.value
            property alias denominatorValue: denominatorText.value
            readonly property bool horizontalLayout: activityBackground.width >= activityBackground.height
            readonly property string mode: activity.mode
            property int numeratorToFind: 0
            property int denominatorToFind: 0
            property int chartRepeaterModel: Math.ceil(items.numeratorToFind / items.denominatorToFind)
            readonly property var levels: activity.datasets
            property string chartType: "pie"
            property bool fixedNumerator: true
            property bool fixedDenominator: true
            property bool buttonsBlocked: false
        }

        onStart: {
            Activity.start(items, activity.mode);
        }
        onStop: { Activity.stop() }

        Keys.enabled: !items.buttonsBlocked

        Keys.onPressed: (event) => {
            if([Qt.Key_Enter, Qt.Key_Return].indexOf(event.key) != -1 && items.itemIndex !== -1) {
                okButton.clicked();
            }
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
        }

        Item {
            id: layoutArea
            width: parent.width - 2 * GCStyle.baseMargins
            anchors.top: instructionPanel.bottom
            anchors.topMargin: GCStyle.baseMargins
            anchors.bottom: parent.bottom
            anchors.bottomMargin: bar.height * 1.3
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: chartLayoutArea
            width: layoutArea.width - okButton.width - GCStyle.baseMargins
            height: layoutArea.height
            anchors {
                top: layoutArea.top
                left: layoutArea.left
            }
        }

        Item {
            id: rightLayoutArea
            width:  layoutArea.width - chartLayoutArea.width - GCStyle.baseMargins
            height: layoutArea.height
            anchors.top: layoutArea.top
            anchors.right: layoutArea.right
        }

        ChartDisplay {
            id: chartDisplay
            layoutWidth: chartLayoutArea.width
            layoutHeight: chartLayoutArea.height
            gridItemHeight: items.horizontalLayout ?
                Math.min(layoutWidth / items.chartRepeaterModel, layoutHeight) :
                Math.min(layoutWidth, layoutHeight / items.chartRepeaterModel)
            gridItemWidth: items.horizontalLayout ? gridItemHeight : layoutWidth
            width: items.horizontalLayout ? gridItemWidth * items.chartRepeaterModel : gridItemWidth
            height: items.horizontalLayout ? gridItemHeight : gridItemHeight * items.chartRepeaterModel
            flow: items.horizontalLayout ? Flow.LeftToRight : Flow.TopToBottom
            anchors.centerIn: chartLayoutArea
            numberOfCharts: items.chartRepeaterModel
        }

        Item {
            id: fractionTextDisplay
            width: rightLayoutArea.width
            anchors.top: rightLayoutArea.top
            anchors.bottom: okButton.top
            anchors.bottomMargin: GCStyle.baseMargins

            FractionNumber {
                id: numeratorText
                value: 0
                width: parent.width
                height: 40 * ApplicationInfo.ratio
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: fractionBar.bottom
                anchors.bottomMargin: GCStyle.halfMargins
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
                height: GCStyle.midBorder
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: GCStyle.whiteBorder
            }
            FractionNumber {
                id: denominatorText
                value: 0
                width: parent.width
                height: numeratorText.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: fractionBar.bottom
                anchors.topMargin: GCStyle.halfMargins
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

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: activity.mode === "findFraction" ? fractionTextDisplay : chartDisplay
            radius: activity.mode === "findFraction" ? GCStyle.baseMargins : (items.chartType === "pie" ? Math.min(width, height) : 0)
            imageSize: okButton.width
            function releaseControls() {
                items.buttonsBlocked = false;
            }
        }

        BarButton {
            id: okButton
            enabled: !items.buttonsBlocked
            anchors {
                bottom: score.top
                bottomMargin: GCStyle.baseMargins
                horizontalCenter: rightLayoutArea.horizontalCenter
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
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
                right: undefined
                left: undefined
            }
            onStop: {
                Activity.nextSubLevel();
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
                activityBackground.stop()
                activityBackground.start()
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
