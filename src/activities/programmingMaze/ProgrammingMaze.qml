/* GCompris - ProgrammingMaze.qml
 *
 * SPDX-FileCopyrightText: 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Siddhesh Suthar <siddhesh.it@gmail.com>
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *   Timothée Giet <animtim@gcompris.net> (Layout and graphics rework)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0
import "../../core"

import "programmingMaze.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property int oldWidth: width
    onWidthChanged: {
        Activity.repositionObjectsOnWidthChanged()
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        Activity.repositionObjectsOnHeightChanged()
        oldHeight = height
    }

    property bool keyboardNavigationVisible: false

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/programmingMaze/resource/background-pm.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height

        signal start
        signal stop

        property bool insertIntoMain: true
        property alias items: items
        property int buttonWidth: layoutArea.width * 0.1
        property int buttonHeight: layoutArea.height * 0.065

        Component.onCompleted: {
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
            property alias brickSound: brickSound
            readonly property var levels: activity.datasets
            property alias mazeModel: mazeModel
            property alias instructionModel: instructionModel
            property alias mainFunctionModel: mainFunctionModel
            property alias mainFunctionCodeArea: mainFunctionCodeArea
            property alias procedureModel: procedureModel
            property alias procedureCodeArea: procedureCodeArea
            property alias instructionArea: instructionArea
            property alias player: player
            property alias constraintInstruction: constraintInstruction
            property alias tutorialImage: tutorialImage
            property alias fish: fish
            property alias loopCounterSelection: loopCounterSelection
            property bool isRunCodeEnabled: true
            property bool currentLevelContainsProcedure
            property bool currentLevelContainsLoop
            property int maxNumberOfInstructionsAllowed
            property int numberOfInstructionsAdded
            // When the activity is stopped, avoid calling initLevel on activity width/height changed
            property bool activityStopped: true
        }

        // This function catches the signal emitted after completion of movement of Tux after executing each instruction.
        function checkSuccessAndExecuteNextInstruction() {
            Activity.checkSuccessAndExecuteNextInstruction()
        }

        // This function catches the signal emitted after finding a dead-end in any of the executing instruction.
        function deadEnd() {
            Activity.deadEnd()
        }

        Loader {
            id: dataset
        }

        onStart: { Activity.start(items) }
        onStop: {
            items.activityStopped = true
            Activity.stop()
        }

        property var areaWithKeyboardInput: instructionArea

        onAreaWithKeyboardInputChanged: activeCodeAreaIndicator.changeActiveCodeAreaIndicator(areaWithKeyboardInput)

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: [tutorialSection]

        Keys.enabled: items.isRunCodeEnabled
        Keys.onPressed: (event) => {
            activity.keyboardNavigationVisible = true
            if(event.key === Qt.Key_Left)
                areaWithKeyboardInput.moveCurrentIndexLeft()
            if(event.key === Qt.Key_Right)
                areaWithKeyboardInput.moveCurrentIndexRight()
            if(event.key === Qt.Key_Up && items.currentLevelContainsLoop && !activityBackground.insertIntoMain)
                increaseButton.increaseClicked()
            if(event.key === Qt.Key_Down && items.currentLevelContainsLoop && !activityBackground.insertIntoMain)
                decreaseButton.decreaseClicked()
            if(event.key === Qt.Key_Space)
                areaWithKeyboardInput.spaceKeyPressed()
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                runCodeOrResetTux()
            if(event.key === Qt.Key_Tab)
                areaWithKeyboardInput.tabKeyPressed()
            if(event.key === Qt.Key_Delete && activeCodeAreaIndicator.top !== instructionArea.top) {
                areaWithKeyboardInput.deleteKeyPressed()
            }
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins

            Repeater {
                id: mazeModel
                anchors.left: layoutArea.left
                anchors.top: layoutArea.top

                Image {
                    x: modelData.x * width
                    y: modelData.y * height
                    width: layoutArea.width * 0.1
                    height: layoutArea.height * 0.09
                    source: Activity.reverseCountUrl + "ice-block.svg"
                }
            }

            Image {
                id: fish
                width: layoutArea.width / 12
                sourceSize.width: width
                source: Activity.reverseCountUrl + "fish-blue.svg"
            }

            Image {
                id: player
                source: "qrc:/gcompris/src/activities/maze/resource/tux_top_south.svg"
                width: fish.width
                sourceSize.width: width
                z: 1
                property int duration: 1000
                readonly property real playerCenterX: x + width * 0.5
                readonly property real playerCenterY: y + height * 0.5
            }
        }

        function runCodeOrResetTux() {
            if(!Activity.deadEndPoint)
                runCodeMouseArea.executeCode()
            else
                Activity.initLevel()
        }

        GCSoundEffect {
            id: brickSound
            source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
        }

        ListModel {
            id: instructionModel
        }

        ListModel {
            id: mainFunctionModel
        }

        //If mode is "procedures", then this model will store instructions exist in the procedure area.
        //If mode is "loops", then this model will store Instructions exist in the loop area.
        ListModel {
            id: procedureModel
        }

        Rectangle {
            id: constraintInstruction
            anchors.left: layoutArea.left
            anchors.top: instructionArea.bottom
            anchors.topMargin: GCStyle.halfMargins
            width: layoutArea.width / 2.3
            height: layoutArea.height / 8.9
            radius: GCStyle.halfMargins
            z: 3
            color: GCStyle.lightBg
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.blueBorder

            GCText {
                id: instructionText
                anchors.fill: parent
                anchors.margins: GCStyle.halfMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap

                readonly property string constraintInstructionText: qsTr("Reach the fish in less than %1 instructions.").arg(items.maxNumberOfInstructionsAllowed + 1)

                text: constraintInstructionText
            }
        }

        Rectangle {
            id: activeCodeAreaIndicator
            color: "#1dade4"
            opacity: 0.5
            radius: GCStyle.halfMargins
            visible: activity.keyboardNavigationVisible
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.whiteBorder

            function changeActiveCodeAreaIndicator(activeArea) {
                anchors.top = activeArea.top
                anchors.fill = activeArea
            }
        }

        InstructionArea {
            id: instructionArea
            width: layoutArea.width * 0.5
            height: layoutArea.height * 0.17
            anchors.left: layoutArea.left
            anchors.top: layoutArea.top
            anchors.topMargin: layoutArea.height * 0.4
            buttonWidth: activityBackground.buttonWidth
            buttonHeight: activityBackground.buttonHeight
        }

        HeaderArea {
            id: mainFunctionHeader
            width: layoutArea.width * 0.4
            height: layoutArea.height * 0.1
            headerText: qsTr("Main function")
            headerOpacity: activityBackground.insertIntoMain ? 1 : 0.5
            onClicked: activityBackground.insertIntoMain = true
            anchors.top: layoutArea.top
            anchors.right: layoutArea.right
        }

        CodeArea {
            id: mainFunctionCodeArea
            width: layoutArea.width * 0.4
            height: layoutArea.height * 0.29
            buttonWidth: activityBackground.buttonWidth
            buttonHeight: activityBackground.buttonHeight
            currentModel: mainFunctionModel
            anchors.right: layoutArea.right
            anchors.top: mainFunctionHeader.bottom

            onTabKeyPressed: {
                mainFunctionCodeArea.currentIndex = -1
                if(!items.currentLevelContainsProcedure && !items.currentLevelContainsLoop) {
                    activityBackground.areaWithKeyboardInput = instructionArea
                    instructionArea.currentIndex = 0
                }
                else {
                    activityBackground.areaWithKeyboardInput = procedureCodeArea
                    activityBackground.insertIntoMain = false
                }
            }
        }

        HeaderArea {
            id: procedureHeader
            width: mainFunctionHeader.width
            height: mainFunctionHeader.height
            headerText: items.currentLevelContainsProcedure ? qsTr("Procedure") + " " : qsTr("Loop") + " "
            headerIcon: items.currentLevelContainsProcedure ? "call-procedure" : "execute-loop"
            headerOpacity: !activityBackground.insertIntoMain ? 1 : 0.5
            visible: procedureCodeArea.visible
            onClicked: activityBackground.insertIntoMain = false
            anchors.top: mainFunctionCodeArea.bottom
            anchors.right: layoutArea.right
        }

        Item {
            id: loopCounterSelection
            visible: items.currentLevelContainsLoop ? true : false
            width: procedureHeader.width * 0.75
            height: activityBackground.buttonHeight * 1.1
            anchors.top: procedureHeader.bottom
            anchors.horizontalCenter: procedureHeader.horizontalCenter

            signal setLoopNumber()
            onSetLoopNumber: {
                Activity.loopsNumber = loopCounterSelection.loopNumber
                Activity.createLoopObjectAndInstructions()
            }

            readonly property int minLoopNumber: 1
            readonly property int maxLoopNumber: 9

            property int loopNumber: minLoopNumber

            Rectangle {
                id: decreaseButton
                width: parent.width * 0.3
                height: activityBackground.buttonHeight
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                border.width: GCStyle.thinnestBorder
                border.color: GCStyle.grayBorder
                radius: GCStyle.thinnestBorder

                GCText {
                    id: decreaseSign
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: GCStyle.darkText
                    text: Activity.LoopEnumValues.MINUS_SIGN
                }

                function decreaseClicked() {
                    if(!decreaseButtonArea.enabled)
                        return
                    decreaseAnimation.restart()
                    if(loopCounterSelection.loopNumber == loopCounterSelection.minLoopNumber) {
                        loopCounterSelection.loopNumber = loopCounterSelection.maxLoopNumber
                    }
                    else {
                        loopCounterSelection.loopNumber--
                    }
                    loopCounterSelection.setLoopNumber()
                }

                MouseArea {
                    id: decreaseButtonArea
                    anchors.fill: parent
                    enabled: items.isRunCodeEnabled
                    onClicked: {
                        decreaseButton.decreaseClicked()
                    }
                }
                SequentialAnimation {
                    id: decreaseAnimation
                    PropertyAnimation {
                        target: decreaseButton
                        property: "scale"
                        to: 0.8
                        duration: 150
                    }

                    PropertyAnimation {
                        target: decreaseButton
                        property: "scale"
                        to: 1
                        duration: 150
                    }
                }
            }

            Rectangle {
                id: loopCounter
                width: parent.width * 0.3
                height: activityBackground.buttonHeight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                border.width: GCStyle.thinnestBorder
                border.color: GCStyle.grayBorder
                radius: GCStyle.tinyMargins

                GCText {
                    id: loopCounterText
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: GCStyle.darkText
                    text: loopCounterSelection.loopNumber
                }
            }

            Rectangle {
                id: increaseButton
                width: parent.width * 0.3
                height: activityBackground.buttonHeight
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                border.width: GCStyle.thinnestBorder
                border.color: GCStyle.grayBorder
                radius: GCStyle.thinnestBorder

                GCText {
                    id: increaseSign
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: GCStyle.darkText
                    text: Activity.LoopEnumValues.PLUS_SIGN
                }

                function increaseClicked() {
                    if(!increaseButtonArea.enabled)
                        return
                    increaseAnimation.restart()
                    if(loopCounterSelection.loopNumber == loopCounterSelection.maxLoopNumber) {
                        loopCounterSelection.loopNumber = loopCounterSelection.minLoopNumber
                    }
                    else {
                        loopCounterSelection.loopNumber++
                    }
                    loopCounterSelection.setLoopNumber()
                }

                MouseArea {
                    id: increaseButtonArea
                    anchors.fill: parent
                    enabled: items.isRunCodeEnabled
                    onClicked: {
                        increaseButton.increaseClicked()
                    }
                }
                SequentialAnimation {
                    id: increaseAnimation
                    PropertyAnimation {
                        target: increaseButton
                        property: "scale"
                        to: 0.8
                        duration: 150
                    }

                    PropertyAnimation {
                        target: increaseButton
                        property: "scale"
                        to: 1
                        duration: 150
                    }
                }
            }
        }

        CodeArea {
            id: procedureCodeArea
            width: mainFunctionCodeArea.width
            height: items.currentLevelContainsLoop ? layoutArea.height * 0.29 - loopCounterSelection.height : layoutArea.height * 0.29
            buttonWidth: activityBackground.buttonWidth
            buttonHeight: activityBackground.buttonHeight
            currentModel: procedureModel
            anchors.right: layoutArea.right
            anchors.top: items.currentLevelContainsLoop ? loopCounterSelection.bottom : procedureHeader.bottom
            visible: items.currentLevelContainsProcedure || items.currentLevelContainsLoop ? true : false

            property alias procedureIterator: procedureCodeArea.currentIndex

            onTabKeyPressed: {
                procedureCodeArea.currentIndex = -1
                activityBackground.areaWithKeyboardInput = instructionArea
                instructionArea.currentIndex = 0
                activityBackground.insertIntoMain = true
            }
        }

        Item {
            id: runCodeLayout
            height: constraintInstruction.height
            anchors.left: constraintInstruction.right
            anchors.right: mainFunctionCodeArea.left
            anchors.verticalCenter: constraintInstruction.verticalCenter

            Image {
                id: runCode
                height: Math.min(parent.width, parent.height)
                width: height
                sourceSize.width: height
                sourceSize.height: height
                anchors.centerIn: parent
                source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id: runCodeMouseArea
                    anchors.fill: parent
                    hoverEnabled: ApplicationInfo.isMobile ? false : (!items.isRunCodeEnabled ? false : true)
                    enabled: items.isRunCodeEnabled

                    signal executeCode

                    onEntered: runCode.scale = 1.1
                    onExecuteCode: {
                        if(mainFunctionModel.count)
                            startCodeExecution()
                    }
                    onClicked: executeCode()
                    onExited: runCode.scale = 1

                    function startCodeExecution() {
                        runCodeClickAnimation.start()
                        Activity.resetCodeAreasIndices()

                        // if(constraintInstruction.opacity)
                        //     constraintInstruction.hide()

                        Activity.runCode()
                    }
                }

                SequentialAnimation {
                    id: runCodeClickAnimation
                    NumberAnimation { target: runCode; property: "scale"; to: 0.8; duration: 100 }
                    NumberAnimation { target: runCode; property: "scale"; to: 1.0; duration: 100 }
                }
            }
        }

        ListModel {
            id: mainTutorialInstructions
            Component.onCompleted: {
                append({
                "instruction": "<b><h7>" + qsTr("Instruction Area:") + "</h7></b>" +
                             qsTr("There are 3 instructions which you can use to code and lead Tux to the fish:") + "<li>" +
                             qsTr("<b>1. Move forward:</b> Moves Tux one step forward in the direction it is facing.") + "</li><li>" +
                             qsTr("<b>2. Turn left:</b> Turns Tux to the left.") + "</li><li>" +
                             qsTr("<b>3. Turn right:</b> Turns Tux to the right.") + "</li>",
                "instructionQml": "qrc:/gcompris/src/activities/programmingMaze/resource/tutorial1.qml"
            });
                append({
                "instruction": "<b><h7>" + qsTr("Main Function:") + "</h7></b>" +
                             qsTr("The execution of the code starts here.") + "<li>" +
                             qsTr("-Click on any instruction in the <b>instruction area</b> to add it to the <b>Main Function</b>.") + "</li><li>" +
                             qsTr("-The instructions will execute in order until there's none left, or until a dead-end, or when Tux reaches the fish.") + "</li>",
                "instructionQml": "qrc:/gcompris/src/activities/programmingMaze/resource/tutorial2.qml"
            });
            }
        }

        ListModel {
            id: procedureTutorialInstructions
            Component.onCompleted: {
                append({
                    "instruction": "<b><h7>" + qsTr("Procedure:") + "</h7></b>" +
                                    qsTr("<b>Procedure</b> is a reusable set of instructions which can be <b>used in the code by calling it where needed</b>.") + "<li>" +
                                    qsTr("-To <b>switch</b> between the <b>Procedure area</b> and the <b>Main Function area</b> to add your code, click on the <b>Procedure</b> or <b>Main Function</b> label.") + "</li>",
                    "instructionQml": "qrc:/gcompris/src/activities/programmingMaze/resource/tutorial3.qml"
                })
            }
        }

        ListModel {
            id: loopTutorialInstructions
            Component.onCompleted: {
                append({
                    "instruction": "<b><h7>" + qsTr("Loop:") + "</h7></b>" +
                                    qsTr("<b>Loop</b> is a sequence of instructions that is <b>continually repeated the number of times defined by the number inside it</b>.") + "<li>" +
                                    qsTr("-To <b>switch</b> between the <b>Loop area</b> and the <b>Main Function area</b> to add your code, click on the <b>Loop</b> or <b>Main Function</b> label.") + "</li>",
                    "instructionQml": "qrc:/gcompris/src/activities/programmingMaze/resource/tutorial4.qml"
                })
            }
        }

        Image {
            id: tutorialImage
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
            anchors.fill: parent
            z: 5
            visible: true

            property bool shownProcedureTutorialInstructions: false
            property bool shownLoopTutorialInstructions: false

            Tutorial {
                id:tutorialSection
                tutorialDetails: visible ? tutorialImage.selectInstructionTutorial() : null
                useImage: false
                onSkipPressed: {
                    tutorialImage.visible = false
                    tutorialNumber = 0
                }
            }
            onVisibleChanged: {
                if(tutorialImage.visible && (tutorialImage.shownProcedureTutorialInstructions || tutorialImage.shownLoopTutorialInstructions))
                    tutorialSection.visible = true
            }

            function selectInstructionTutorial() {
                var nextLevelInstructions = items.levels[items.currentLevel].instructions
                if(nextLevelInstructions.indexOf(Activity.EXECUTE_LOOPS) !== -1) {
                    return loopTutorialInstructions;
                }

                if(nextLevelInstructions.indexOf(Activity.CALL_PROCEDURE) !== -1) {
                    return procedureTutorialInstructions;
                }

                return mainTutorialInstructions;
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

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: tutorialImage.visible ? help | home : help | home | level | reload | activityConfig}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onReloadClicked: Activity.reloadLevel()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
                loose.connect(Activity.resetTuxPosition)
            }
        }
    }
}
