/* GCompris - learn_decimals.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "learn_decimals.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool isSubtractionMode: false
    property bool isAdditionMode: false
    property bool isQuantityMode: false

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/braille_fun/resource/hillside.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        property bool horizontalLayout: background.width >= background.height
        property bool scoreAtBottom: bar.width * 9 < background.width

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: tutorialSection

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property bool isSubtractionMode: activity.isSubtractionMode
            property bool isAdditionMode: activity.isAdditionMode
            property bool isQuantityMode: activity.isQuantityMode
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias numpad: numpad
            readonly property var levels: activity.datasetLoader.data
            property alias draggedItems: draggedItems
            property alias droppedItems: droppedItems
            property alias largestNumberRepresentation: largestNumberRepresentation
            property alias tutorialImage: tutorialImage
            property alias scrollBar: bottomRectangle.scrollBar
            property string largestNumber
            property string smallestNumber
            property bool helper: false
            property bool typeResult: false
            property double unit: activity.isQuantityMode ? 1 : 0.1
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            timer.stop()
            Activity.stop()
        }

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
            anchors.fill: parent
            visible: true
            z: 5
            Tutorial {
                id: tutorialSection
                useImage: false
                tutorialDetails: isSubtractionMode ? Activity.subtractionInstructions :
                    isAdditionMode ? Activity.additionInstructions :
                    isQuantityMode ? Activity.quantityInstructions :
                    Activity.tutorialInstructions
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false
                }
            }
        }
        // Tutorial section ends

        Rectangle {
            id: decimalNumber
            width: background.width * 0.6
            height: parent.height / 12
            radius: 10
            color: "#373737"
            anchors.horizontalCenter: background.horizontalCenter
            anchors.top: background.top
            anchors.topMargin: 5 * ApplicationInfo.ratio

            property string decimalQuestion: qsTr("Display the number: %1")
            property string additionQuestion: qsTr("Display the result of: %1 + %2")
            property string subtractionQuestion: qsTr("Display the result of: %1 - %2")
            property string quantityQuestion: qsTr("Represent the quantity: %1")

            GCText {
                anchors.centerIn: parent
                width: parent.width - 10 * ApplicationInfo.ratio
                height: parent.height
                text: isSubtractionMode ? decimalNumber.subtractionQuestion.arg(items.largestNumber).arg(items.smallestNumber) :
                    isAdditionMode ? decimalNumber.additionQuestion.arg(items.largestNumber).arg(items.smallestNumber) :
                    isQuantityMode ? decimalNumber.quantityQuestion.arg(items.largestNumber) :
                    decimalNumber.decimalQuestion.arg(items.largestNumber)
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.DemiBold
                color: "white"
            }
        }

        ListModel {
            id: droppedItems
        }

        Item {
            id: layoutArea
            anchors.top: decimalNumber.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            anchors.bottom: okButton.top
            anchors.bottomMargin: background.scoreAtBottom ? bar.height * 0.5 : anchors.topMargin
            anchors.horizontalCenter: background.horizontalCenter
            width: background.horizontalLayout ? background.width * 0.7 : background.width * 0.95
        }

        Rectangle {
            id: topRectangle
            visible: !isSubtractionMode && !tutorialImage.visible
            anchors.top: layoutArea.top
            color: "#F2F2F2"
            border.color: "#373737"
            border.width: 2
            radius: 10
            z: 10

            states: [
                State {
                    when: background.horizontalLayout
                    PropertyChanges {
                        target: topRectangle
                        width: layoutArea.width
                        // 7/11 of layoutArea
                        height: layoutArea.height * 0.636
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.right: undefined
                        anchors.horizontalCenter: layoutArea.horizontalCenter
                    }
                },
                State {
                    when: !background.horizontalLayout && !items.typeResult
                    PropertyChanges {
                        target: topRectangle
                        width: layoutArea.width * 0.636
                        height: layoutArea.height
                        anchors.rightMargin: 10 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.right: background.right
                        anchors.horizontalCenter: undefined
                    }
                },
                State {
                    when: !background.horizontalLayout && items.typeResult
                    PropertyChanges {
                        target: topRectangle
                        width: layoutArea.width * 0.636
                        height: layoutArea.height
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.right: undefined
                        anchors.horizontalCenter: background.horizontalCenter
                    }
                }
            ]

            DropArea {
                id: dropArea
                anchors.fill: parent

                readonly property int maxDroppedItems: 6
                onDropped: {
                    if(droppedItems.count === dropArea.maxDroppedItems) return;
                    droppedItems.append( {"selectedSquareNumbers": bottomRectangle.currentStep + 1 } );
                    timer.restart()
                }
            }

            Timer {
                id: timer
                interval: 1000
                onTriggered: {
                    if(droppedItems.count == 1) return;
                    Activity.organizeDroppedBars();
                }
            }

            SingleBar {
                id: answerZone
                anchors.centerIn: topRectangle
                selectedModel: droppedItems
                isAnswerRepresentation: true
                isUnselectedBar: false
                states: [
                    State {
                        when: background.horizontalLayout
                        PropertyChanges {
                            target: answerZone
                            cellSize: Math.min(topRectangle.height / 7, topRectangle.width / 11)
                            cellHeight: cellSize * 1.125
                            cellWidth: cellSize
                            width: cellSize * 10
                            height: cellSize * 6.875
                            anchors.verticalCenterOffset: cellSize * 0.125
                            anchors.horizontalCenterOffset: 0
                            flow: GridView.FlowTopToBottom
                        }
                    },
                    State {
                        when: !background.horizontalLayout
                        PropertyChanges {
                            target: answerZone
                            cellSize: Math.min(topRectangle.width / 7, topRectangle.height / 11)
                            cellHeight: cellSize
                            cellWidth: cellSize * 1.125
                            width: cellSize * 6.875
                            height: cellSize * 10
                            anchors.verticalCenterOffset: 0
                            anchors.horizontalCenterOffset: cellSize * 0.125
                            flow: GridView.FlowLeftToRight
                        }
                    }
                ]
            }
        }

        ListModel {
            id: draggedItems
        }

        Rectangle {
            id: bottomRectangle
            visible: !isSubtractionMode && !items.typeResult
            color: "#F2F2F2"
            border.color: "#373737"
            border.width: 2
            radius: 10

            property alias scrollBar: scrollBar

            states: [
                State {
                    when: background.horizontalLayout
                    PropertyChanges {
                        target: bottomRectangle
                        width: layoutArea.width
                        // 3/11 of layoutArea
                        height: layoutArea.height * 0.273
                        anchors.rightMargin: 0
                        // 0.5/11 of layoutArea
                        anchors.topMargin: layoutArea.height * 0.045
                    }
                    AnchorChanges {
                        target: bottomRectangle
                        anchors.top: topRectangle.bottom
                        anchors.horizontalCenter: background.horizontalCenter
                        anchors.right: undefined
                    }
                    PropertyChanges {
                        target: unselectedBar
                        anchors.verticalCenterOffset: -unselectedBar.height * 0.5
                        anchors.horizontalCenterOffset: 0
                    }
                    PropertyChanges {
                        target: selectedBar
                        anchors.verticalCenterOffset: -selectedBar.height * 0.5
                        anchors.horizontalCenterOffset: 0
                    }
                    PropertyChanges {
                        target: scrollBar
                        width: unselectedBar.width
                        height: bottomRectangle.height * 0.5
                        x: unselectedBar.x
                        y: unselectedBar.y + unselectedBar.height
                    }
                    PropertyChanges {
                        target: arrow
                        rotation: 0
                        x: 0
                    }
                    AnchorChanges {
                        target: arrow
                        anchors.top: parent.top
                        anchors.right: undefined
                    }
                    AnchorChanges {
                        target: hintArea
                        anchors.top: arrow.bottom
                        anchors.horizontalCenter: arrow.horizontalCenter
                        anchors.right: undefined
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    when: !background.horizontalLayout
                    PropertyChanges {
                        target: bottomRectangle
                        width: layoutArea.width * 0.273
                        height: layoutArea.height
                        anchors.rightMargin: layoutArea.width * 0.045
                        anchors.topMargin: 0
                    }
                    AnchorChanges {
                        target: bottomRectangle
                        anchors.top: layoutArea.top
                        anchors.horizontalCenter: undefined
                        anchors.right: topRectangle.left
                    }
                    PropertyChanges {
                        target: unselectedBar
                        anchors.verticalCenterOffset: 0
                        anchors.horizontalCenterOffset: unselectedBar.width * 0.5
                    }
                    PropertyChanges {
                        target: selectedBar
                        anchors.verticalCenterOffset: 0
                        anchors.horizontalCenterOffset: selectedBar.width * 0.5
                    }
                    PropertyChanges {
                        target: scrollBar
                        width: bottomRectangle.width * 0.5
                        height: unselectedBar.height
                        x: unselectedBar.x - width
                        y: unselectedBar.y
                    }
                    PropertyChanges {
                        target: arrow
                        rotation: 90
                        y: 0
                    }
                    AnchorChanges {
                        target: arrow
                        anchors.top: undefined
                        anchors.right: parent.right
                    }
                    AnchorChanges {
                        target: hintArea
                        anchors.top: undefined
                        anchors.horizontalCenter: undefined
                        anchors.right: arrow.left
                        anchors.verticalCenter: arrow.verticalCenter
                    }
                }
            ]

            property int currentStep: scrollBar.currentStep

            SingleBar {
                id: unselectedBar
                opacity: 0.5
                cellSize: background.horizontalLayout ? Math.min(bottomRectangle.height / 3, bottomRectangle.width / 11) : Math.min(bottomRectangle.width / 3, bottomRectangle.height / 11)
                width: background.horizontalLayout ? cellSize * 10 : cellSize
                height: background.horizontalLayout ? cellSize : cellSize * 10
                anchors.centerIn: bottomRectangle

                selectedModel: draggedItems
                isAnswerRepresentation: false
                isUnselectedBar: true
            }

            SingleBar {
                id: selectedBar
                cellSize: unselectedBar.cellSize
                width: unselectedBar.width
                height: unselectedBar.height
                anchors.centerIn: bottomRectangle

                selectedModel: draggedItems
                isAnswerRepresentation: false
                isUnselectedBar: false

                Drag.active: dragArea.drag.active

                states: [
                    State {
                        when: dragArea.drag.active
                        ParentChange {
                            target: selectedBar
                            parent: topRectangle
                        }
                    }
                ]
            }

            MouseArea {
                id: dragArea
                width: selectedBar.width
                height: selectedBar.height
                anchors.fill: selectedBar
                anchors.centerIn: parent
                drag.target: selectedBar

                onReleased: {
                    selectedBar.Drag.drop()
                    bottomRectangle.resetArrowPosition()
                }
            }

            Item {
                id: scrollBar

                property double horizontalBarLimit: scrollBar.width - arrow.width / 2
                property double verticalBarLimit: scrollBar.height - arrow.width / 2
                property double arrowOrigin: unselectedBar.cellSize * 0.5
                property alias arrowX: arrow.x
                property alias arrowY: arrow.y
                property int currentStep: 0

                Image {
                    id: arrow
                    source: "qrc:/gcompris/src/activities/learn_decimals/resource/arrow.svg"
                    sourceSize.width: width
                    width: unselectedBar.cellSize
                    height: width

                    MouseArea {
                        id: arrowMouseArea
                        width: parent.width * 2
                        height: parent.height * 1.5
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: parent.height * 0.25
                        drag.target: arrow
                        onPositionChanged: {
                            if(background.horizontalLayout) {
                                //range of the horizontal scrolling
                                if(arrow.x < scrollBar.arrowOrigin) {
                                    arrow.x = scrollBar.arrowOrigin
                                }
                                else if(arrow.x > scrollBar.horizontalBarLimit) {
                                    arrow.x = scrollBar.horizontalBarLimit
                                }

                                scrollBar.currentStep = Math.round((arrow.x - scrollBar.arrowOrigin) / unselectedBar.cellSize) ;
                                arrow.x = (scrollBar.currentStep + 0.5) * unselectedBar.cellSize
                            }
                            else {
                                // range of the vertical scrolling
                                if(arrow.y < scrollBar.arrowOrigin) {
                                    arrow.y = scrollBar.arrowOrigin
                                }
                                else if(arrow.y > scrollBar.verticalBarLimit) {
                                    arrow.y = scrollBar.verticalBarLimit
                                }

                                scrollBar.currentStep = Math.round((arrow.y - scrollBar.arrowOrigin) / unselectedBar.cellSize);
                                arrow.y = (scrollBar.currentStep + 0.5) * unselectedBar.cellSize
                            }

                            Activity.changeSingleBarVisibility(scrollBar.currentStep + 1)
                        }
                    }
                }
                Rectangle {
                    id: hintArea
                    visible: items.helper
                    width: unselectedBar.cellSize * 1.1
                    height: width
                    color: "#FFFFFF"
                    radius: 5 * ApplicationInfo.ratio
                    border.color: "#808080"
                    border.width: 2
                    GCText {
                        id: text
                        fontSize: regularSize
                        text: activity.isQuantityMode ? scrollBar.currentStep + 1 :
                            Activity.toDecimalLocaleNumber((scrollBar.currentStep + 1) * items.unit)
                        font.bold: true
                        color: "#373737"
                        fontSizeMode: Text.Fit
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                        width: parent.width - 4
                        height: width
                    }
                }

                onWidthChanged: {
                    if(items.draggedItems.count != 0) {
                        bottomRectangle.resetArrowPosition()
                    }
                }
                onHeightChanged: {
                    if(items.draggedItems.count != 0) {
                        bottomRectangle.resetArrowPosition()
                    }
                }
            }

            function resetArrowPosition() {
                if(background.horizontalLayout) {
                    scrollBar.arrowX = scrollBar.arrowOrigin
                }
                else {
                    scrollBar.arrowY = scrollBar.arrowOrigin
                }
                Activity.changeSingleBarVisibility(1)
                scrollBar.currentStep = 0
            }
        }

        ListModel {
            id: largestNumberRepresentation
        }

        Rectangle {
            id: mainRectangle
            visible: isSubtractionMode
            width: topRectangle.width
            height: background.scoreAtBottom ? layoutArea.height - okButton.height : layoutArea.height
            anchors.top: layoutArea.top
            anchors.horizontalCenter: background.horizontalCenter
            color: "#F2F2F2"
            border.color: "#373737"
            border.width: 2
            radius: 10

            MultipleBars {
                id: multipleBars
            }
        }

        Rectangle {
            id: answerBackground
            visible: items.typeResult
            height: okButton.height
            color: "#f2f2f2"
            border.color: "#373737"
            border.width: 2
            radius: 10

            property string userEntry
            property string resultText: qsTr("Enter the result: %1")

            GCText {
                id: userEntryText
                anchors.centerIn: parent
                width: parent.width - 10 * ApplicationInfo.ratio
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSize: smallSize
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                color: "#373737"
                text: answerBackground.resultText.arg(answerBackground.userEntry)
            }
        }

        NumPad {
            id: numpad
            displayDecimalButton: true
            onAnswerChanged: {
                answerBackground.userEntry = answer
            }
            maxDigit: 3
            opacity: items.typeResult ? 1 : 0
            columnWidth: 60 * ApplicationInfo.ratio
            enableInput: !bonus.isPlaying
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: {
            if(bonus.isPlaying)
                return
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                if(items.typeResult) {
                    Activity.verifyNumberTyping(answerBackground.userEntry)
                }
                else {
                    Activity.verifyNumberRepresentation()
                }
            }
            else {
               numpad.updateAnswer(event.key, true);
            }
        }

        states: [
            State {
                when: background.scoreAtBottom
                AnchorChanges {
                    target: answerBackground
                    anchors.left: undefined
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: mainRectangle.bottom
                    anchors.verticalCenter: undefined
                }
                PropertyChanges {
                    target: answerBackground
                    width: mainRectangle.width
                    anchors.topMargin: 5 * ApplicationInfo.ratio
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
                when: !background.scoreAtBottom
                AnchorChanges {
                    target: answerBackground
                    anchors.left: topRectangle.left
                    anchors.horizontalCenter: undefined
                    anchors.top: undefined
                    anchors.verticalCenter: okButton.verticalCenter
                }
                PropertyChanges {
                    target: answerBackground
                    width: mainRectangle.width - okButton.width * 1.2
                    anchors.topMargin: 0
                }
                AnchorChanges {
                    target: okButton
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                    anchors.bottom: bar.top
                    anchors.right: mainRectangle.right
                    anchors.left: undefined
                }
                PropertyChanges {
                    target: okButton
                    anchors.bottomMargin: okButton.height * 0.5
                    anchors.rightMargin: 0
                    anchors.verticalCenterOffset: 0
                }
            }
        ]

        Image {
            id: hint
            source:"qrc:/gcompris/src/core/resource/bar_hint.svg"
            visible: !isSubtractionMode && !items.typeResult
            sourceSize.width: okButton.width
            fillMode: Image.PreserveAspectFit
            anchors.right: okButton.left
            anchors.rightMargin: okButton.width * 0.3
            anchors.verticalCenter: okButton.verticalCenter

            MouseArea {
                id: hintMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: items.helper = !items.helper
            }

            states: State {
                when: hintMouseArea.containsMouse
                PropertyChanges {
                    target: hint
                    scale: 1.1
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onClose: home()
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

            content: tutorialImage.visible ? tutorialBar : withConfig
            property BarEnumContent tutorialBar: BarEnumContent { value: help | home }
            property BarEnumContent withConfig: BarEnumContent { value: help | home | level | activityConfig }

            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 60 * ApplicationInfo.ratio
            sourceSize.width: width
            onClicked: items.typeResult? Activity.verifyNumberTyping(answerBackground.userEntry) : Activity.verifyNumberRepresentation()
            mouseArea.enabled: !bonus.isPlaying
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Score {
            id: score
            visible: !tutorialImage.visible && !isAdditionMode && !isSubtractionMode
            height: okButton.height * 0.9
            anchors.top: undefined
            anchors.bottom: undefined
            anchors.right: hint.visible ? hint.left : okButton.left
            anchors.verticalCenter: okButton.verticalCenter
        }
    }
}
