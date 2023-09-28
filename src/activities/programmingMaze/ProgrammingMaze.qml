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
import QtQuick 2.12
import GCompris 1.0
import "../../core"

import "programmingMaze.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property int oldWidth: width
    onWidthChanged: {
        Activity.repositionObjectsOnWidthChanged(width / oldWidth)
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        Activity.repositionObjectsOnHeightChanged(height / oldHeight)
        oldHeight = height
    }

    property bool keyboardNavigationVisible: false

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/programmingMaze/resource/background-pm.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height

        signal start
        signal stop

        property bool insertIntoMain: true
        property alias items: items
        property int buttonWidth: background.width / 10
        property int buttonHeight: background.height / 15.3

        Component.onCompleted: {
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
            property GCSfx audioEffects: activity.audioEffects
            readonly property var levels: activity.datasetLoader.data
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
            property bool activityStopped: false
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
        Keys.forwardTo: tutorialSection

        Keys.enabled: items.isRunCodeEnabled
        Keys.onPressed: {
            activity.keyboardNavigationVisible = true
            if(event.key === Qt.Key_Left)
                areaWithKeyboardInput.moveCurrentIndexLeft()
            if(event.key === Qt.Key_Right)
                areaWithKeyboardInput.moveCurrentIndexRight()
            if(event.key === Qt.Key_Up && items.currentLevelContainsLoop && !background.insertIntoMain)
                increaseButton.increaseClicked()
            if(event.key === Qt.Key_Down && items.currentLevelContainsLoop && !background.insertIntoMain)
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

        function runCodeOrResetTux() {
            if(!Activity.deadEndPoint)
                runCodeMouseArea.executeCode()
            else
                Activity.initLevel()
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
            anchors.left: parent.left
            anchors.top: instructionArea.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            width: parent.width / 2.3
            height: parent.height / 8.9
            radius: 10
            z: 3
            color: "#E8E8E8" //paper white
            border.width: 3 * ApplicationInfo.ratio
            border.color: "#87A6DD"  //light blue

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            function changeConstraintInstructionOpacity() {
                if(opacity)
                    constraintInstruction.hide()
                else
                    constraintInstruction.show()
            }

            function show() {
                if(instructionText.text)
                    opacity = 0.8
            }
            function hide() {
                opacity = 0
            }

            GCText {
                id: instructionText
                anchors.fill: parent
                anchors.margins: parent.border.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap

                readonly property string constraintInstructionText: qsTr("Reach the fish in less than %1 instructions.").arg(items.maxNumberOfInstructionsAllowed + 1)

                text: constraintInstructionText
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: constraintInstruction.changeConstraintInstructionOpacity()
        }

        Repeater {
            id: mazeModel

            anchors.left: parent.left
            anchors.top: parent.top

            Image {
                x: modelData.x * width
                y: modelData.y * height
                width: background.width / 10
                height: (background.height - background.height / 10) / 10
                source: Activity.reverseCountUrl + "ice-block.svg"
            }
        }

        Image {
            id: fish
            sourceSize.width: background.width / 12
            source: Activity.reverseCountUrl + "fish-blue.svg"
        }

        Image {
            id: player
            source: "qrc:/gcompris/src/activities/maze/resource/tux_top_south.svg"
            width: background.width / 12
            sourceSize.width: width
            z: 1
            property int duration: 1000
            readonly property real playerCenterX: x + width / 2
            readonly property real playerCenterY: y + height / 2
        }

        Rectangle {
            id: activeCodeAreaIndicator
            color: "#1dade4"
            opacity: 0.5
            radius: 8 * ApplicationInfo.ratio
            visible: activity.keyboardNavigationVisible
            border.width: 2 * ApplicationInfo.ratio
            border.color: "white"

            function changeActiveCodeAreaIndicator(activeArea) {
                anchors.top = activeArea.top
                anchors.fill = activeArea
            }
        }

        InstructionArea {
            id: instructionArea
        }

        HeaderArea {
            id: mainFunctionHeader
            headerText: qsTr("Main function")
            headerOpacity: background.insertIntoMain ? 1 : 0.5
            onClicked: background.insertIntoMain = true
            anchors.top: parent.top
            anchors.right: parent.right
        }

        CodeArea {
            id: mainFunctionCodeArea
            currentModel: mainFunctionModel
            anchors.right: parent.right
            anchors.top: mainFunctionHeader.bottom

            onTabKeyPressed: {
                mainFunctionCodeArea.currentIndex = -1
                if(!items.currentLevelContainsProcedure && !items.currentLevelContainsLoop) {
                    background.areaWithKeyboardInput = instructionArea
                    instructionArea.currentIndex = 0
                }
                else {
                    background.areaWithKeyboardInput = procedureCodeArea
                    background.insertIntoMain = false
                }
            }
        }

        HeaderArea {
            id: procedureHeader
            headerText: items.currentLevelContainsProcedure ? qsTr("Procedure") + " " : qsTr("Loop") + " "
            headerIcon: items.currentLevelContainsProcedure ? "call-procedure" : "execute-loop"
            headerOpacity: !background.insertIntoMain ? 1 : 0.5
            visible: procedureCodeArea.visible
            onClicked: background.insertIntoMain = false
            anchors.top: mainFunctionCodeArea.bottom
            anchors.right: parent.right
        }

        Item {
            id: loopCounterSelection
            visible: items.currentLevelContainsLoop ? true : false
            width: procedureHeader.width * 0.75
            height: background.buttonHeight * 1.1
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
                height: background.buttonHeight
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                border.width: 1.2 * ApplicationInfo.ratio
                border.color: "grey"
                radius: decreaseButton.width * 0.1

                GCText {
                    id: decreaseSign
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: "#373737"
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
                height: background.buttonHeight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                border.width: 1.2 * ApplicationInfo.ratio
                border.color: "grey"
                radius: loopCounter.width * 0.1

                GCText {
                    id: loopCounterText
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: "#373737"
                    text: loopCounterSelection.loopNumber
                }
            }

            Rectangle {
                id: increaseButton
                width: parent.width * 0.3
                height: background.buttonHeight
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                border.width: 1.2 * ApplicationInfo.ratio
                border.color: "grey"
                radius: increaseButton.width * 0.1

                GCText {
                    id: increaseSign
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: "#373737"
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
            height: items.currentLevelContainsLoop ? background.height * 0.29 - loopCounterSelection.height : background.height * 0.29
            currentModel: procedureModel
            anchors.right: parent.right
            anchors.top: items.currentLevelContainsLoop ? loopCounterSelection.bottom : procedureHeader.bottom
            visible: items.currentLevelContainsProcedure || items.currentLevelContainsLoop ? true : false

            property alias procedureIterator: procedureCodeArea.currentIndex

            onTabKeyPressed: {
                procedureCodeArea.currentIndex = -1
                background.areaWithKeyboardInput = instructionArea
                instructionArea.currentIndex = 0
                background.insertIntoMain = true
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

                        if(constraintInstruction.opacity)
                            constraintInstruction.hide()

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
                tutorialDetails: tutorialImage.selectInstructionTutorial()
                useImage: false
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false
                    tutorialNumber = 0
                }
            }
            onVisibleChanged: {
                if(tutorialImage.visible && (tutorialImage.shownProcedureTutorialInstructions || tutorialImage.shownLoopTutorialInstructions))
                    tutorialSection.visible = true
            }

            function selectInstructionTutorial() {
                if(!tutorialSection.visible) {
                    return "";
                }

                var nextLevelInstructions = items.levels[items.currentLevel].instructions
                if(nextLevelInstructions.indexOf(Activity.EXECUTE_LOOPS) !== -1) {
                    return Activity.loopTutorialInstructions;
                }

                if(nextLevelInstructions.indexOf(Activity.CALL_PROCEDURE) !== -1) {
                    return Activity.procedureTutorialInstructions;
                }

                return Activity.mainTutorialInstructions;
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
