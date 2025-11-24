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
            readonly property double ratioWH: 1.6
            // size calculations are based on maximum 4 nbDigits and 4 nbLines
            readonly property int digitWidth: Math.min(100 * ApplicationInfo.ratio, (layoutArea.width - GCStyle.baseMargins * 2) / (nbDigits + 2))
            property int digitHeight: 1
            readonly property int digitBgWidth: digitWidth - GCStyle.baseMargins
            readonly property int digitBgHeight: digitHeight - GCStyle.baseMargins
            readonly property bool okOnSide: layoutArea.width - digitWidth * 6 - GCStyle.baseMargins * 2 >= 2 * (okButton.width + GCStyle.baseMargins * 2)

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
            property alias caption: instructionPanel.textItem
            property alias numberRepeater: numberRepeater
            property alias okButton: okButton
            property alias numPad: numPad
            property alias miniPad: miniPad
            property alias negativeNumberWarning: negativeNumberWarning
            property bool inputLocked: true
            property string createAdditionText: qsTr("Write your own addition and solve it.")
            property string createSubtractionText: qsTr("Write your own subtraction and solve it.")

            property alias crashSound: crashSound
            property alias completeTaskSound: completeTaskSound
            property alias errorRectangle: errorRectangle
            property alias client: client
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Client {    // Client for server version. Prepare data from activity to server
            id: client
            getDataCallback: function() {
                // We send digit per digit for each number, allowing to have the carry and tens used for display
                var numbers = new Array(items.numberRepeater.length);
                for (var i = 0; i < items.numberRepeater.count; i++) {
                    var number = items.numberRepeater.itemAt(i)
                    var jsonNumber = new Array(number.digitRepeater.count)
                    for (var j = 0; j < number.digitRepeater.count; j++) {
                        var digit = number.digitRepeater.itemAt(j)
                        jsonNumber[j] = {
                            "expected": digit.expected,
                            "tensValue": digit.tensValue,
                            "carryValue": digit.carryValue,
                            "value": digit.value
                        }
                    }
                    numbers[i] = jsonNumber
                }

                var jsonResultNumber = new Array(items.resultNumber.digitRepeater.length);
                for (var j = 0; j < items.resultNumber.digitRepeater.count; j++) {
                    var digit = items.resultNumber.digitRepeater.itemAt(j)
                    jsonResultNumber[j] = {
                        "expected": digit.expected,
                        "tensValue": digit.tensValue,
                        "carryValue": digit.carryValue,
                        "value": digit.value
                    }
                }
                var data = {
                    "numbers": numbers,
                    "resultNumber": jsonResultNumber
                }
                return data
            }
        }

        GCSoundEffect {
            id: crashSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: completeTaskSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        ListModel { id: numbersModel }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 3 * GCStyle.baseMargins - score.width
            panelHeight: score.height
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: score.top
            anchors.horizontalCenterOffset: -(score.width + GCStyle.baseMargins) * 0.5
        }

        Item {
            id: layoutArea
            anchors.top: instructionPanel.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.5
        }

        Rectangle {
            id: board
            property int digitCount: 0
            property int result: 0
            width: resultNumber.width + GCStyle.baseMargins * 2
            height: childrenRect.height + GCStyle.baseMargins * 2
            anchors.top: layoutArea.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: GCStyle.lightBg
            radius: GCStyle.tinyMargins

            Column {
                spacing: 0
                x: GCStyle.baseMargins
                y: GCStyle.baseMargins
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
                    height: GCStyle.baseMargins
                    Rectangle {
                        width: resultNumber.width
                        height: 2 * ApplicationInfo.ratio
                        anchors.centerIn: parent
                        color: GCStyle.darkerText
                    }
                }

                MathNumber {
                    id: resultNumber
                    digitCount: board.digitCount
                    droppable: true
                    digitsVisible: !readyButton.visible
                    enabled: okButton.visible
                    lineIndex: -1   // Means result number line

                    onNumberValueChanged: {
                        initNumberLine();
                    }
                }
            }
        }

        Item {
            id: rightSideArea
            anchors.left: board.right
            anchors.right: layoutArea.right
            anchors.top: layoutArea.top
            anchors.bottom: layoutArea.bottom
            anchors.margins: GCStyle.baseMargins
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 60 * ApplicationInfo.ratio
            anchors.top: board.bottom
            anchors.topMargin: GCStyle.baseMargins
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: Activity.checkResult()
            mouseArea.enabled: !items.inputLocked
        }

        states: [
            State {
                name: "okRight"
                when: items.okOnSide
                PropertyChanges {
                    items.digitHeight: Math.min(items.digitWidth, (layoutArea.height - equalLine.height  - GCStyle.baseMargins * 2) / (items.nbLines + 1))
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
                    items.digitHeight: Math.min(items.digitWidth, (layoutArea.height - equalLine.height - okButton.height - GCStyle.baseMargins * 3) / (items.nbLines + 1))
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
            property color color: "#E5E5E5"
            property alias repeater: repeater
            property int maxX: activityBackground.width - width - GCStyle.baseMargins
            property int maxY: activityBackground.height - height - GCStyle.baseMargins
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
                        radius: GCStyle.tinyMargins
                        border.color: GCStyle.grayBorder
                        border.width: GCStyle.thinnestBorder

                        Rectangle {
                            color: "#33000000"
                            anchors.fill: parent
                            visible: miniArea.containsMouse
                        }

                        GCText {
                            id: padText
                            anchors.fill: parent
                            anchors.margins: GCStyle.tinyMargins
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            fontSize: regularSize
                            fontSizeMode: Text.Fit
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
            property int maxX: activityBackground.width - width - GCStyle.baseMargins
            property int maxY: activityBackground.height - height - GCStyle.baseMargins
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
                    border.color: GCStyle.grayBorder
                    border.width: GCStyle.thinnestBorder
                    radius: GCStyle.tinyMargins

                    GCText {
                        anchors.fill: parent
                        anchors.margins: GCStyle.halfMargins
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
            y: board.y + GCStyle.baseMargins + resultNumber.y
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

        Rectangle {
            id: negativeNumberWarning
            visible: false
            enabled: visible
            anchors.fill: layoutArea
            radius: GCStyle.halfMargins
            color: GCStyle.darkBg
            border.color: GCStyle.lightBorder
            border.width: GCStyle.thinnestBorder

            GCText {
                anchors.fill: parent
                anchors.margins: GCStyle.baseMargins
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                color: GCStyle.lightText
                fontSize: mediumSize
                text: qsTr("The result should not be a negative number.")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.visible = false;
                    items.inputLocked = false;
                }
            }
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
