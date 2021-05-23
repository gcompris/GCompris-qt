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
import QtQuick 2.9
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
    property string mode: "basic"
    property string datasetUrl: "qrc:/gcompris/src/activities/programmingMaze/Dataset.qml"

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
            property alias bar: bar
            property alias bonus: bonus
            property GCSfx audioEffects: activity.audioEffects
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
            property alias dataset: dataset
            property bool isRunCodeEnabled: true
            property bool isTuxMouseAreaEnabled: false
            property bool currentLevelContainsProcedure
            property int maxNumberOfInstructionsAllowed
            property int numberOfInstructionsAdded
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

        onStart: { Activity.start(items, mode, datasetUrl) }
        onStop: { Activity.stop() }

        property var areaWithKeyboardInput: instructionArea

        onAreaWithKeyboardInputChanged: activeCodeAreaIndicator.changeActiveCodeAreaIndicator(areaWithKeyboardInput)

        Keys.enabled: items.isTuxMouseAreaEnabled || items.isRunCodeEnabled
        Keys.onPressed: {
            activity.keyboardNavigationVisible = true
            if(event.key === Qt.Key_Left)
                areaWithKeyboardInput.moveCurrentIndexLeft()
            if(event.key === Qt.Key_Right)
                areaWithKeyboardInput.moveCurrentIndexRight()
            if(event.key === Qt.Key_Up)
                areaWithKeyboardInput.moveCurrentIndexUp()
            if(event.key === Qt.Key_Down)
                areaWithKeyboardInput.moveCurrentIndexDown()
            if(event.key === Qt.Key_Space)
                areaWithKeyboardInput.spaceKeyPressed()
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                runCodeOrResetTux()
            if(event.key === Qt.Key_Tab)
                areaWithKeyboardInput.tabKeyPressed()
            if(event.key === Qt.Key_Delete && activeCodeAreaIndicator.top != instructionArea.top) {
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

                readonly property string resetTuxInstructionText: qsTr("Click on Tux or press the Enter key to reset it or click on the RELOAD button to reload the level.")
                readonly property string constraintInstructionText: qsTr("Reach the fish in less than %1 instructions.").arg(items.maxNumberOfInstructionsAllowed + 1)

                text: items.isTuxMouseAreaEnabled ? resetTuxInstructionText : constraintInstructionText
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

            MouseArea {
                id: tuxMouseArea
                anchors.fill: parent
                enabled: items.isTuxMouseAreaEnabled
                onClicked: {
                    Activity.initLevel()
                }
            }
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
            property string mainText: qsTr("Main function")
            headerText: mainText
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
                if(!items.currentLevelContainsProcedure) {
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
            property string procedureText: qsTr("Procedure") + " ( )"
            headerText: procedureText
            headerOpacity: !background.insertIntoMain ? 1 : 0.5
            visible: procedureCodeArea.visible
            onClicked: background.insertIntoMain = false
            anchors.top: mainFunctionCodeArea.bottom
            anchors.right: parent.right
        }

        CodeArea {
            id: procedureCodeArea
            currentModel: procedureModel
            anchors.right: parent.right
            anchors.top: procedureHeader.bottom
            visible: items.currentLevelContainsProcedure

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

            Tutorial {
                id:tutorialSection
                tutorialDetails: bar.level <= 2 ? Activity.mainTutorialInstructions : Activity.procedureTutorialInstructions
                useImage: false
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false
                    tutorialNumber = 0
                }
            }
            onVisibleChanged: {
                if(tutorialImage.visible && tutorialImage.shownProcedureTutorialInstructions)
                    tutorialSection.visible = true
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: tutorialImage.visible ? help | home : help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: {
                if(tutorialImage.visible)
                    tutorialImage.visible = false;
                activity.home();
            }
            onReloadClicked: Activity.reloadLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
