/* GCompris - VerticalSubtraction.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * References:
 *   https://www.moncrpe.fr/archives/560
 *   https://methodeheuristique.com/page-2/la-soustraction-posee/
 *   https://micetf.fr/operations/
 *   https://lutin-malin.fr/application/generateur-operations
 *
 * Addition will use Regrouping mode. Carry is always added to first line.
 * Subtraction is split in 2 activities for Compensation and Regrouping methods (add carry to last line or subtract carry to first line).
 *
 */
import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "subtraction.js" as Activity

// For Popup
import QtQuick.Controls.Basic

ActivityBase {
    id: activity

    enum OperationType {
        Addition,
        Subtraction
    }
    enum OperationMethod {
        Compensation,
        Regrouping
    }

    property int operation: VerticalSubtraction.OperationType.Subtraction
    property int method: VerticalSubtraction.OperationMethod.Regrouping

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        readonly property string digits: "0123456789"
        anchors.fill: parent
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            // readonly property int digitHeight: 70
            readonly property double ratioWH: 1.6
            readonly property int baseMargins: 10 * ApplicationInfo.ratio
            readonly property int baseRadius: 2 * ApplicationInfo.ratio
            // size calculations are based on maximum 4 nbDigits and 4 nbLines
            readonly property int digitWidth: Math.min(100 * ApplicationInfo.ratio, (layoutArea.width - baseMargins * 2) / (nbDigits + 2))
            property int digitHeight: 1
            readonly property int digitBgWidth: digitWidth - items.baseMargins
            readonly property int digitBgHeight: digitHeight - items.baseMargins
            readonly property bool okOnSide: layoutArea.width - digitWidth * 6 - baseMargins * 2 >= 2 * (okButton.width + baseMargins * 2)

            property var levels: activity.datasets
            property int currentSubLevel: 0
            property int subLevelCount: 0

            property int operation: activity.operation
            property int method: activity.method
            property var operationType: VerticalSubtraction.OperationType
            property var operationMethod: VerticalSubtraction.OperationMethod
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
            property bool inputLocked: true

            property alias crashSound: crashSound
            property alias completeTaskSound: completeTaskSound
            property alias errorRectangle: errorRectangle
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

        Item {
            id: captionArea
            anchors.top: score.top
            anchors.left: parent.left
            anchors.right: score.left
            anchors.bottom: score.bottom
            anchors.leftMargin: items.baseMargins
            anchors.rightMargin: items.baseMargins
        }

        Rectangle {
            color: "#80FFFFFF"
            anchors.centerIn: caption
            width: caption.contentWidth + items.baseMargins * 2
            height: caption.contentHeight + items.baseMargins
            radius: items.baseRadius
        }

        GCText {
            id: caption
            anchors.fill: captionArea
            anchors.margins: items.baseMargins
            fontSize: regularSize
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            id: layoutArea
            anchors.top: captionArea.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: items.baseMargins
            anchors.bottomMargin: bar.height * 1.5
        }

        Rectangle {
            id: board
            property int digitCount: 0
            property int result: 0
            width: resultNumber.width + items.baseMargins * 2
            height: childrenRect.height + items.baseMargins * 2
            anchors.top: layoutArea.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#F0F0F0"
            radius: items.baseRadius

            Column {
                spacing: 0
                x: items.baseMargins
                y: items.baseMargins
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

                Item {
                    id: equalLine
                    width: resultNumber.width
                    height: items.baseMargins
                    Rectangle {
                        width: resultNumber.width
                        height: 2 * ApplicationInfo.ratio
                        anchors.centerIn: parent
                        color: "#191919"
                    }
                }

                MathNumber {
                    id: resultNumber
                    digitCount: board.digitCount
                    droppable: true
                    digitsVisible: !readyButton.visible
                    enabled: okButton.visible
                    lineIndex: -1   // Means result number line
                }
            }
        }

        Item {
            id: rightSideArea
            anchors.left: board.right
            anchors.right: layoutArea.right
            anchors.top: layoutArea.top
            anchors.bottom: layoutArea.bottom
            anchors.margins: items.baseMargins
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 60 * ApplicationInfo.ratio
            anchors.top: board.bottom
            anchors.topMargin: items.baseMargins
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: Activity.checkResult()
            mouseArea.enabled: !items.inputLocked
        }

        states: [
            State {
                name: "okRight"
                when: items.okOnSide
                PropertyChanges {
                    items.digitHeight: Math.min(items.digitWidth, (layoutArea.height - equalLine.height  - items.baseMargins * 2) / (items.nbLines + 1))
                }
                AnchorChanges {
                    target: okButton
                    anchors.verticalCenter: rightSideArea.verticalCenter
                    anchors.horizontalCenter: rightSideArea.horizontalCenter
                    anchors.top: undefined
                }
            },
            State {
                name: "okBottom"
                when: !items.okOnSide
                PropertyChanges {
                    items.digitHeight: Math.min(items.digitWidth, (layoutArea.height - equalLine.height - okButton.height - items.baseMargins * 3) / (items.nbLines + 1))
                }
                AnchorChanges {
                    target: okButton
                    anchors.verticalCenter: undefined
                    anchors.horizontalCenter: activityBackground.horizontalCenter
                    anchors.top: board.bottom
                }
            }
        ]

        Popup {
            id: miniPad
            property var current: null
            property bool isCarry: true
            property string color: "#E5E5E5"
            property alias repeater: repeater
            property int maxX: activityBackground.width - width - items.baseMargins
            property int maxY: activityBackground.height - height - items.baseMargins
            height: 4 * items.digitBgHeight
            width: items.digitBgWidth
            padding: 0
            background: Item {}
            modal: true
            contentItem: Column {
                Repeater {
                    id: repeater
                    model: [ "", "+1", "+2", "+3" ]
                    delegate: Rectangle {
                        width: items.digitBgWidth
                        height: items.digitBgHeight
                        color: miniPad.color
                        radius: items.baseRadius
                        border.color: "#808080"
                        border.width: ApplicationInfo.ratio

                        Rectangle {
                            color: "#33000000"
                            anchors.fill: parent
                            visible: miniArea.containsMouse
                        }

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
                            enabled: !items.inputLocked
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
            ListElement { label: "←"; key: Qt.Key_Backspace }
            ListElement { label: "0";  key: Qt.Key_0 }
            ListElement { label: " ";  key: Qt.Key_Delete }
        }

        Popup {
            id: numPad
            property var currentDigit: null
            property int maxX: activityBackground.width - width - items.baseMargins
            property int maxY: activityBackground.height - height - items.baseMargins
            width: items.digitBgWidth * 3
            height: items.digitBgHeight * 4
            padding: 0
            background: Item {}
            modal: true
            contentItem: GridView {
                id: gridPad
                width: Math.ceil(3 * cellWidth)
                height: Math.ceil(4 * cellHeight)
                cellWidth: items.digitBgWidth
                cellHeight: items.digitBgHeight
                interactive: false
                model: padModel

                delegate: Rectangle {
                    id: numKey
                    width: items.digitBgWidth
                    height: items.digitBgHeight
                    color: numArea.containsMouse ? "#C0C0C0" : "#E5E5E5"
                    border.color: "#808080"
                    border.width: ApplicationInfo.ratio
                    radius: items.baseRadius

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
                        enabled: !items.inputLocked
                        hoverEnabled: true
                        onClicked: {
                            switch (label) {
                            case "←":
                                break
                            case " ":
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

        GCButton {
            id: readyButton
            text: qsTr("Ready")
            visible: !okButton.visible
            anchors.horizontalCenter: activityBackground.horizontalCenter
            y: board.y + items.baseMargins + resultNumber.y
            height: resultNumber.height
            onClicked: Activity.checkDropped()
        }

        ErrorRectangle {
            id: errorRectangle
            x: board.x
            y: board.y
            width: board.width
            height: board.height
            radius: board.radius
            imageSize: height * 0.5
            function releaseControls() { items.inputLocked = false; }
        }

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
                activityBackground.stop()
                activityBackground.start()
            }
        }

        Score {
            id: score
            numberOfSubLevels: items.subLevelCount
            currentSubLevel: items.currentSubLevel
            anchors.bottom: undefined
            anchors.top: activityBackground.top
            anchors.right: activityBackground.right
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

        Keys.onPressed: (event) => {
            if(!items.inputLocked) {
                Activity.handleKeys(event.key)
            }
        }
    }
}
