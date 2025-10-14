/* GCompris - BinaryBulb.qml
 *
 * SPDX-FileCopyrightText: 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   RAJAT ASTHANA <rajatasthana4@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import core 1.0

import "../../core"
import "binary_bulb.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "../digital_electricity/resource/texture01.webp"
        fillMode: Image.Tile
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
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias bulbs: bulbs
            property int numberSoFar: 0
            property int numberToConvert: 0
            property int numberOfBulbs: 0
            property int currentSelectedBulb: -1
            property alias score: score
            readonly property var levels: activity.datasets
            property alias errorRectangle: errorRectangle
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property bool buttonsBlocked: false
            property alias client: client
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Client {    // Client for server version. Prepare data from activity to server
            id: client
            getDataCallback: function() {
                var data = {
                    "expected": items.numberToConvert,
                    "result": items.numberSoFar
                }
                return data
            }
        }

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: "../digital_electricity/resource/texture01.webp"
            anchors.fill: parent
            fillMode: Image.Tile
            z: 5
            visible: true
            Tutorial {
                id: tutorialSection
                tutorialDetails: ListModel {
                    ListElement {
                        instruction: qsTr("This activity teaches how to convert decimal numbers to binary numbers.")
                        instructionQml: "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial1.qml"
                    }
                    ListElement {
                        instruction: qsTr("Computers use transistors to count and transistors have only two states, 0 and 1. Mathematically, these states are represented by 0 and 1, which makes up the binary system of numeration.")
                        instructionQml: "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial2.qml"
                    }
                    ListElement {
                        instruction: qsTr("In the activity 0 and 1 are simulated by bulbs, switched on or off.")
                        instructionQml: "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial3.qml"
                    }
                    ListElement {
                        instruction: qsTr("Binary system uses these numbers very efficiently, allowing to count from 0 to 255 with 8 bits only.")
                        instructionQml: "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial4.qml"
                    }
                    ListElement {
                        instruction: qsTr("Each bit adds a progressive value, corresponding to the powers of 2, ascending from right to left: bit 1 → 2⁰=1 , bit 2 → 2¹=2 , bit 3 → 2²=4 , bit 4 → 2³=8 , bit 5 → 2⁴=16 , bit 6 → 2⁵=32 , bit 7 → 2⁶=64 , bit 8 → 2⁷=128.")
                        instructionQml: "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial5.qml"
                    }
                    ListElement {
                        instruction: qsTr("To convert a decimal 5 to a binary value, 1 and 4 are added.")
                        instructionQml: "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial6.qml"
                    }
                    ListElement {
                        instruction: qsTr("Their corresponding bits are set to 1, the others are set to 0. Decimal 5 is equal to binary 101.")
                        instructionQml: "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial7.qml"
                    }
                    ListElement {
                        instruction: qsTr("This image will help you to compute bits' value.")
                        instructionQml: "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial5.qml"
                    }
                }

                useImage: false
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false
                }
            }
        }
        // Tutorial section ends

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: [tutorialSection]

        Keys.onPressed: (event) => {
            if(items.buttonsBlocked)
                return
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                Activity.equalityCheck()
            }
            else if(event.key === Qt.Key_Space) {
                if(items.currentSelectedBulb != -1) {
                    Activity.changeState(items.currentSelectedBulb)
                }
            }
            else if(event.key === Qt.Key_Left) {
                if(--items.currentSelectedBulb < 0) {
                    items.currentSelectedBulb = items.numberOfBulbs-1
                }
            }
            else if(event.key === Qt.Key_Right) {
                if(++items.currentSelectedBulb >= items.numberOfBulbs) {
                    items.currentSelectedBulb = 0
                }
            }
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            textItem.text: qsTr("What is the binary representation of %1?").arg(items.numberToConvert)
        }

        Row {
            id: bulbsRow
            anchors.top: instructionPanel.bottom
            anchors.topMargin: GCStyle.baseMargins * 2
            anchors.horizontalCenter: parent.horizontalCenter
            height: activityBackground.height * 0.3
            spacing: 0
            Repeater {
                id: bulbs
                model: items.numberOfBulbs
                LightBulb {
                    required property int index
                    height: bulbsRow.height
                    width: Math.min(GCStyle.bigButtonHeight, (activityBackground.width - 2 * GCStyle.baseMargins) / 8)
                    valueVisible: items.levels[items.currentLevel].bulbValueVisible
                    position: index
                }
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: bulbsRow
            z: score.z
            imageSize: okButton.width
            function releaseControls() { items.buttonsBlocked = false; }
        }

        Rectangle {
            width: reachedSoFar.contentWidth + 2 * GCStyle.baseMargins
            height: reachedSoFar.contentHeight + GCStyle.halfMargins
            anchors.centerIn: reachedSoFar
            color: GCStyle.darkBg
            opacity: 0.5
            radius: GCStyle.halfMargins
            visible: reachedSoFar.visible
        }

        GCText {
            id: reachedSoFar
            anchors.left: score.right
            anchors.right: okButton.left
            anchors.top: bulbsRow.bottom
            anchors.bottom: bar.top
            anchors.margins: 4 * GCStyle.baseMargins
            anchors.topMargin: GCStyle.baseMargins
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            fontSize: largeSize
            fontSizeMode: Text.Fit
            text: items.numberSoFar
            visible: items.levels[items.currentLevel].enableHelp
        }

        BarButton {
            id: okButton
            anchors {
                verticalCenter: reachedSoFar.verticalCenter
                right: parent.right
                margins: GCStyle.baseMargins
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
            onClicked: Activity.equalityCheck()
            enabled: !items.buttonsBlocked
        }


        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home()
            }

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
            }

            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: tutorialImage.visible ? (help | home | activityConfig) : (help | home | level | activityConfig) }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Score {
            id: score
            visible: !tutorialImage.visible
            anchors.bottom: bar.top
            anchors.right: undefined
            anchors.left: parent.left
            anchors.bottomMargin: GCStyle.baseMargins
            anchors.leftMargin: GCStyle.baseMargins
            onStop: Activity.nextSubLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
