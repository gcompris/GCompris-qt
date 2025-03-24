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
import core 1.0
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
        id: activityBackground
        source: "qrc:/gcompris/src/activities/braille_fun/resource/hillside.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        property bool horizontalLayout: activityBackground.width >= activityBackground.height

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: [tutorialSection]

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property bool isSubtractionMode: activity.isSubtractionMode
            property bool isAdditionMode: activity.isAdditionMode
            property bool isQuantityMode: activity.isQuantityMode
            property alias activityBackground: activityBackground
            property alias instructionPanel: instructionPanel
            property alias answerBackground: answerBackground
            property alias tutorialSection: tutorialSection
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias numpad: numpad
            readonly property var levels: activity.datasets
            property alias draggedItems: draggedItems
            property alias droppedItems: droppedItems
            property alias largestNumberRepresentation: largestNumberRepresentation
            property alias tutorialImage: tutorialImage
            property alias scrollBar: bottomRectangle.scrollBar
            property alias errorRectangle: errorRectangle
            property string largestNumber
            property string smallestNumber
            property bool helper: false
            property bool typeResult: false
            property double unit: activity.isQuantityMode ? 1 : 0.1
            property bool buttonsBlocked: false
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            timer.stop()
            Activity.stop()
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
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
                onNextPressed: {
                    Activity.loadTutorialText()
                }
                onPreviousPressed: {
                    Activity.loadTutorialText()
                }
            }
        }
        // Tutorial section ends

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * (GCStyle.baseMargins + numpad.columnWidth)
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.1)
            fixedHeight: true
            border.width: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            textItem.text: isSubtractionMode ?
                instructionPanel.subtractionQuestion.arg(items.largestNumber).arg(items.smallestNumber) :
                isAdditionMode ? instructionPanel.additionQuestion.arg(items.largestNumber).arg(items.smallestNumber) :
                isQuantityMode ? instructionPanel.quantityQuestion.arg(items.largestNumber) :
                instructionPanel.decimalQuestion.arg(items.largestNumber)

            property string decimalQuestion: qsTr("Display the number: %1")
            property string additionQuestion: qsTr("Display the result of: %1 + %2")
            property string subtractionQuestion: qsTr("Display the result of: %1 - %2")
            property string quantityQuestion: qsTr("Represent the quantity: %1")
        }

        ListModel {
            id: droppedItems
        }

        Item {
            id: layoutArea
            anchors.top: instructionPanel.bottom
            anchors.topMargin: GCStyle.halfMargins
            anchors.bottom: okButton.top
            anchors.bottomMargin: GCStyle.halfMargins
            anchors.horizontalCenter: activityBackground.horizontalCenter
            width: activityBackground.horizontalLayout ? activityBackground.width * 0.7 : activityBackground.width * 0.95
        }

        Rectangle {
            id: topRectangle
            visible: !isSubtractionMode && !tutorialImage.visible
            anchors.top: layoutArea.top
            color: GCStyle.lightBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinnestBorder
            radius: GCStyle.halfMargins
            z: 10

            states: [
                State {
                    when: activityBackground.horizontalLayout
                    PropertyChanges {
                        topRectangle {
                            width: layoutArea.width
                            // 7/11 of layoutArea
                            height: layoutArea.height * 0.636
                        }
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.right: undefined
                        anchors.horizontalCenter: layoutArea.horizontalCenter
                    }
                },
                State {
                    when: !activityBackground.horizontalLayout && !items.typeResult
                    PropertyChanges {
                        topRectangle {
                            width: layoutArea.width * 0.636
                            height: layoutArea.height
                            anchors.rightMargin: GCStyle.baseMargins
                        }
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.right: activityBackground.right
                        anchors.horizontalCenter: undefined
                    }
                },
                State {
                    when: !activityBackground.horizontalLayout && items.typeResult
                    PropertyChanges {
                        topRectangle {
                            width: layoutArea.width * 0.636
                            height: layoutArea.height
                        }
                    }
                    AnchorChanges {
                        target: topRectangle
                        anchors.right: undefined
                        anchors.horizontalCenter: activityBackground.horizontalCenter
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
                        when: activityBackground.horizontalLayout
                        PropertyChanges {
                            answerZone {
                                cellSize: Math.min(topRectangle.height / 7, topRectangle.width / 11)
                                cellHeight: answerZone.cellSize * 1.125
                                cellWidth: answerZone.cellSize
                                width: answerZone.cellSize * 10
                                height: answerZone.cellSize * 6.875
                                anchors.verticalCenterOffset: answerZone.cellSize * 0.125
                                anchors.horizontalCenterOffset: 0
                                flow: GridView.FlowTopToBottom
                            }
                        }
                    },
                    State {
                        when: !activityBackground.horizontalLayout
                        PropertyChanges {
                            answerZone {
                                cellSize: Math.min(topRectangle.width / 7, topRectangle.height / 11)
                                cellHeight: answerZone.cellSize
                                cellWidth: answerZone.cellSize * 1.125
                                width: answerZone.cellSize * 6.875
                                height: answerZone.cellSize * 10
                                anchors.verticalCenterOffset: 0
                                anchors.horizontalCenterOffset: answerZone.cellSize * 0.125
                                flow: GridView.FlowLeftToRight
                            }
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
            color: GCStyle.lightBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinnestBorder
            radius: GCStyle.halfMargins

            property alias scrollBar: scrollBar

            states: [
                State {
                    when: activityBackground.horizontalLayout
                    PropertyChanges {
                        bottomRectangle {
                            width: layoutArea.width
                            // 3/11 of layoutArea
                            height: layoutArea.height * 0.273
                            anchors.rightMargin: 0
                            // 0.5/11 of layoutArea
                            anchors.topMargin: layoutArea.height * 0.045
                        }
                    }
                    AnchorChanges {
                        target: bottomRectangle
                        anchors.top: topRectangle.bottom
                        anchors.horizontalCenter: activityBackground.horizontalCenter
                        anchors.right: undefined
                    }
                    PropertyChanges {
                        unselectedBar {
                            anchors.verticalCenterOffset: -unselectedBar.height * 0.5
                            anchors.horizontalCenterOffset: 0
                        }
                    }
                    PropertyChanges {
                        selectedBar {
                            anchors.verticalCenterOffset: -selectedBar.height * 0.5
                            anchors.horizontalCenterOffset: 0
                        }
                    }
                    PropertyChanges {
                        scrollBar {
                            width: unselectedBar.width
                            height: bottomRectangle.height * 0.5
                            x: unselectedBar.x
                            y: unselectedBar.y + unselectedBar.height
                        }
                    }
                    PropertyChanges {
                        arrow {
                            rotation: 0
                            x: 0
                        }
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
                    when: !activityBackground.horizontalLayout
                    PropertyChanges {
                        bottomRectangle {
                            width: layoutArea.width * 0.273
                            height: layoutArea.height
                            anchors.rightMargin: layoutArea.width * 0.045
                            anchors.topMargin: 0
                        }
                    }
                    AnchorChanges {
                        target: bottomRectangle
                        anchors.top: layoutArea.top
                        anchors.horizontalCenter: undefined
                        anchors.right: topRectangle.left
                    }
                    PropertyChanges {
                        unselectedBar {
                            anchors.verticalCenterOffset: 0
                            anchors.horizontalCenterOffset: unselectedBar.width * 0.5
                        }
                    }
                    PropertyChanges {
                        selectedBar {
                            anchors.verticalCenterOffset: 0
                            anchors.horizontalCenterOffset: selectedBar.width * 0.5
                        }
                    }
                    PropertyChanges {
                        scrollBar {
                            width: bottomRectangle.width * 0.5
                            height: unselectedBar.height
                            x: unselectedBar.x - scrollBar.width
                            y: unselectedBar.y
                        }
                    }
                    PropertyChanges {
                        arrow {
                            rotation: 90
                            y: 0
                        }
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
                cellSize: activityBackground.horizontalLayout ? Math.min(bottomRectangle.height / 3, bottomRectangle.width / 11) : Math.min(bottomRectangle.width / 3, bottomRectangle.height / 11)
                width: activityBackground.horizontalLayout ? cellSize * 10 : cellSize
                height: activityBackground.horizontalLayout ? cellSize : cellSize * 10
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
                enabled: !items.buttonsBlocked

                onReleased: {
                    selectedBar.Drag.drop()
                    bottomRectangle.resetArrowPosition()
                }
            }

            Item {
                id: scrollBar

                property double horizontalBarLimit: scrollBar.width - arrow.width * 0.5
                property double verticalBarLimit: scrollBar.height - arrow.width * 0.5
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
                        enabled: !items.buttonsBlocked
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: parent.height * 0.25
                        drag.target: arrow
                        onPositionChanged: {
                            if(activityBackground.horizontalLayout) {
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
                    color: GCStyle.whiteBg
                    radius: GCStyle.halfMargins
                    border.color: GCStyle.grayBorder
                    border.width: GCStyle.thinnestBorder
                    GCText {
                        id: text
                        fontSize: smallSize
                        text: activity.isQuantityMode ? scrollBar.currentStep + 1 :
                            Activity.toDecimalLocaleNumber((scrollBar.currentStep + 1) * items.unit)
                        font.bold: true
                        color: GCStyle.darkText
                        fontSizeMode: Text.Fit
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                        anchors.margins: GCStyle.tinyMargins
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
                if(activityBackground.horizontalLayout) {
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
            height: layoutArea.height
            anchors.top: layoutArea.top
            anchors.horizontalCenter: activityBackground.horizontalCenter
            color: GCStyle.lightBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinnestBorder
            radius: GCStyle.halfMargins

            MultipleBars {
                id: multipleBars
            }
        }

        Rectangle {
            id: answerBackground
            visible: items.typeResult
            height: okButton.height
            anchors.left: topRectangle.left
            anchors.right: okButton.left
            anchors.rightMargin: GCStyle.baseMargins
            anchors.verticalCenter: okButton.verticalCenter
            color: GCStyle.lightBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinnestBorder
            radius: GCStyle.halfMargins

            property string userEntry
            property string resultText: qsTr("Enter the result: %1")

            GCText {
                id: userEntryText
                anchors.centerIn: parent
                width: parent.width - GCStyle.baseMargins
                height: parent.height - 2 * GCStyle.baseMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSize: smallSize
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                color: GCStyle.darkText
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
            enableInput: !items.buttonsBlocked
        }

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            if(items.buttonsBlocked)
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

        Image {
            id: hint
            source:"qrc:/gcompris/src/core/resource/bar_hint.svg"
            visible: !isSubtractionMode && !items.typeResult
            sourceSize.width: okButton.width
            fillMode: Image.PreserveAspectFit
            anchors.right: okButton.left
            anchors.rightMargin: GCStyle.baseMargins
            anchors.verticalCenter: okButton.verticalCenter

            MouseArea {
                id: hintMouseArea
                anchors.fill: parent
                enabled: !items.buttonsBlocked
                hoverEnabled: true
                onClicked: items.helper = !items.helper
            }

            states: State {
                when: hintMouseArea.containsMouse
                PropertyChanges {
                    hint {
                        scale: 1.1
                    }
                }
            }
        }

        ErrorRectangle {
            id: errorRectangle
            z: 10
            function releaseControls() {
                items.buttonsBlocked = false;
            }

            states: [
                State {
                    when: !isSubtractionMode && !items.typeResult
                    PropertyChanges {
                        errorRectangle {
                            anchors.fill: topRectangle
                            radius: topRectangle.radius
                            imageSize: droppedItems.count === 0 ? 0 : 60 * ApplicationInfo.ratio
                        }
                    }
                },
                State {
                    when: isSubtractionMode && !items.typeResult
                    PropertyChanges {
                        errorRectangle {
                            anchors.fill: mainRectangle
                            radius: mainRectangle.radius
                            imageSize: 60 * ApplicationInfo.ratio
                        }
                    }
                },
                State {
                    when: items.typeResult
                    PropertyChanges {
                        errorRectangle {
                            anchors.fill: answerBackground
                            radius: answerBackground.radius
                            imageSize: errorRectangle.height * 0.5
                        }
                    }
                }
            ]
        }

        Image {
            id: errorArrow
            z: 20
            source: "qrc:/gcompris/src/activities/learn_decimals/resource/redArrow.svg"
            opacity: errorRectangle.opacity
            visible: !isSubtractionMode && droppedItems.count === 0
            width: GCStyle.bigButtonHeight
            height: width
            sourceSize.width: width
            anchors.margins: unselectedBar.cellSize

            states: [
                State {
                    when: activityBackground.horizontalLayout
                    AnchorChanges {
                        target: errorArrow
                        anchors.left: undefined
                        anchors.verticalCenter: undefined
                        anchors.bottom: bottomRectangle.verticalCenter
                        anchors.horizontalCenter: bottomRectangle.horizontalCenter
                    }
                    PropertyChanges {
                        errorArrow {
                            rotation: 0
                        }
                    }
                },
                State {
                    when: !activityBackground.horizontalLayout
                    AnchorChanges {
                        target: errorArrow
                        anchors.left: bottomRectangle.horizontalCenter
                        anchors.verticalCenter: bottomRectangle.verticalCenter
                        anchors.bottom: undefined
                        anchors.horizontalCenter: undefined
                    }
                    PropertyChanges {
                        errorArrow {
                            rotation: 90
                        }
                    }
                }
            ]
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
            width: GCStyle.bigButtonHeight
            anchors.right: parent.right
            anchors.rightMargin: GCStyle.baseMargins + numpad.columnWidth
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.5
            onClicked: items.typeResult? Activity.verifyNumberTyping(answerBackground.userEntry) : Activity.verifyNumberRepresentation()
            mouseArea.enabled: !items.buttonsBlocked
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            visible: !tutorialImage.visible && !isAdditionMode && !isSubtractionMode
            anchors.top: undefined
            anchors.bottom: undefined
            anchors.right: undefined
            anchors.left: parent.left
            anchors.leftMargin: GCStyle.baseMargins
            anchors.verticalCenter: okButton.verticalCenter
            onStop: Activity.nextSubLevel()
        }
    }
}
