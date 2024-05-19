/* GCompris - Subtraction.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * References:
 *   https://www.moncrpe.fr/archives/560
 *   https://methodeheuristique.com/page-2/la-soustraction-posee/
 *   https://micetf.fr/operations/
 *   https://lutin-malin.fr/application/generateur-operations
 *
 * Addition will use Borrow mode. Carry is always added to first line.
 * Subtraction will give a choice between Compensation and Borrow (add carry to last line or subtract carry to first line).
 *
 */
import QtQuick 2.12
import QtQuick.Controls 2.15    // for ComboBox. To be removed later.

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "subtraction.js" as Activity

ActivityBase {
    id: activity
    property int operation: 1       // 0: addition,     1: substraction

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        property string digits: "0123456789"
        anchors.fill: parent
        color: "#ABCDEF"
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
            property alias score: score

            property var levels: activity.datasets
            property int currentSubLevel: 0
            property int subLevelCount: 0

            property int operation: activity.operation
            property int method: 1          // 0: compensation, 1: borrow
            property int nbLines: 2
            property int nbDigits: 2
            property bool alreadyLaid: true
            property bool withCarry: false
            property alias numbersModel: numbersModel
            property alias resultNumber: resultNumber
            property alias board: board
            property alias caption: caption
            property alias numberRepeater: numberRepeater
            property alias okButton: okButton
            property alias numPad: numPad
            property alias miniPad: miniPad

            property alias crashSound: crashSound
            property alias completeTaskSound: completeTaskSound
            property bool debug: false

            onMethodChanged: Activity.buildNumbersModel()
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: crashSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: completeTaskSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        ListModel { id: numbersModel }

        GCText {
            id: caption
            anchors.top: parent.top
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            height: 100
        }

        Column {
            anchors.top: caption.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Rectangle {
                id: board
                property int digitCount: 0
                property int result: 0
                width: resultNumber.width + 40
                height: childrenRect.height + 40
                anchors.horizontalCenter: parent.horizontalCenter
                color: "beige"
                radius: 10
                border.width: 3

                Column {
                    spacing: 5
                    Repeater {
                        id: numberRepeater
                        model: numbersModel
                        delegate: MathNumber {
                            numberValue: value_
                            lineIndex: index
                            digitCount: board.digitCount
                            droppable: !items.alreadyLaid
                            operator: operator_
                        }
                    }

                    Rectangle {     // Separator line
                        width: board.width
                        height: 30
                        x: 15
                        color: "transparent"
                        Rectangle {
                            width: resultNumber.width
                            height: 3
                            anchors.bottom: parent.bottom
                            color: "black"
                        }
                    }

                    MathNumber {
                        id: resultNumber
                        digitCount: board.digitCount
                        droppable: true
                        enabled: okButton.visible
                        lineIndex: -1   // Means result number line
                    }
                }
            }

            BarButton {
                id: okButton
                source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                width: 100
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.width: width
                onClicked: Activity.checkResult()
                mouseArea.enabled: !bonus.isPlaying
            }

            GCButton {
                id: readyButton
                text: qsTr("Ready")
                visible: !okButton.visible
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Activity.checkDropped()
            }
        }

        Popup {
            id: miniPad
            property var current: null
            property bool isCarry: true
            property string color: "#E5E5E5"
            property alias repeater: repeater
            property int cellHeight: Activity.digitHeight * Activity.ratioWH / 3
            height: 4 * cellHeight
            width: (Activity.digitHeight / 2) + 2
            padding: 0
            background: Rectangle { color: "transparent" }
            modal: true
            contentItem: Column {
                Repeater {
                    id: repeater
                    model: [ "", "+1", "+2", "+3" ]
                    delegate: Rectangle {
                        width: Activity.digitHeight * Activity.ratioWH / 3
                        height: miniPad.cellHeight
                        color: miniPad.color
                        radius: 3
                        border.color: "#808080"
                        border.width: miniArea.containsMouse ? 2 : 1

                        GCText {
                            id: padText
                            anchors.fill: parent
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            fontSize: tinySize
                            text: modelData ? modelData : ""
                        }

                        MouseArea {
                            id: miniArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (miniPad.isCarry)
                                    miniPad.current.carryValue = (padText.text === "") ? 0 : Number(padText.text)
                                else
                                    miniPad.current.tensValue = (padText.text === "") ? 0 : Number(padText.text)
                                miniPad.close()
                            }
                        }
                    }
                }
            }
        }

        ListModel {
            id: padModel
            ListElement { label: "7";  key: Qt.Key_7 }
            ListElement { label: "8";  key: Qt.Key_8 }
            ListElement { label: "9";  key: Qt.Key_9 }
            ListElement { label: "4";  key: Qt.Key_4 }
            ListElement { label: "5";  key: Qt.Key_5 }
            ListElement { label: "6";  key: Qt.Key_6 }
            ListElement { label: "1";  key: Qt.Key_1 }
            ListElement { label: "2";  key: Qt.Key_2 }
            ListElement { label: "3";  key: Qt.Key_3 }
            ListElement { label: "<<"; key: Qt.Key_Backspace }
            ListElement { label: "0";  key: Qt.Key_0 }
            ListElement { label: "C";  key: Qt.Key_Delete }
        }

        Popup {
            id: numPad
            property var currentDigit: null
            width: gridPad.width
            height: gridPad.height
            padding: 0
            background: Rectangle { color: "transparent" }
            modal: true
            contentItem: GridView {
                id: gridPad
                width: Math.ceil(3 * cellWidth)
                height: Math.ceil(4 * cellHeight)
                cellWidth: Activity.digitHeight
                cellHeight: Activity.digitHeight
                interactive: false
                model: padModel

                delegate: Rectangle {
                    id: numKey
                    width: Activity.digitHeight
                    height: Activity.digitHeight
                    anchors.margins: 2
                    color: numArea.containsMouse ? "#C0C0C0" : "#E5E5E5"
                    border.color: "#808080"
                    border.width: 2
                    radius: height * 0.1

                    GCText {
                        anchors.centerIn: parent
                        width: parent.width * 0.9
                        height: parent.height * 0.9
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSizeMode: Text.Fit
                        fontSize: mediumSize
                        text: label
                    }

                    MouseArea {
                        id: numArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !items.buttonsBlocked
                        onClicked: {
                            switch (label) {
                            case "<<":
                                break
                            case "C":
                                numPad.currentDigit.value = -1
                                break
                            default:
                                numPad.currentDigit.value = label
                                break
                            }
                            items.numPad.close()
                        }
                    }

                    Component.onCompleted: Activity.mapToPad[key] = index
                }
            }
        }


        // Development tools
        Column {
            width: 150

            ComboBox {
                id: comboMethod
                width: parent.width
                visible: items.operation !== 0
                focusPolicy: Qt.NoFocus
                displayText: currentText + " method"
                model: [ "Compensation", "Borrow"]
                currentIndex: items.method
                onCurrentIndexChanged: items.method = currentIndex
            }

            Button {
                focusPolicy: Qt.NoFocus
                text: "Change values"
                onClicked: Activity.initLevel()
                visible: items.debug === true
            }
        }
        // End of development tools

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

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

        Score {
            id: score
            numberOfSubLevels: items.subLevelCount
            currentSubLevel: items.currentSubLevel
            anchors.bottom: undefined
            anchors.top: background.top
            anchors.right: background.right
            onStop: Activity.nextSubLevel()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: displayDialog(dialogActivityConfig)
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Keys.onPressed: (event) => { Activity.handleEvents(event) }
    }
}
