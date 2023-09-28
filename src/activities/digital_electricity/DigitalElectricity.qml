/* GCompris - DigitalElectricity.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (mouse drag refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "digital_electricity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "texture02.webp"
        fillMode: Image.Tile
        signal start
        signal stop

        property bool hori: background.width >= background.height

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: tutorialInstruction

        Keys.onPressed: {
            if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && okButton.enabled) {
                Activity.checkAnswer()
            }
            if (event.key === Qt.Key_Plus) {
                Activity.zoomIn()
            }
            if (event.key === Qt.Key_Minus) {
                Activity.zoomOut()
            }
            if (event.key === Qt.Key_Right) {
                playArea.x -= 200;
            }
            if (event.key === Qt.Key_Left) {
                playArea.x += 200
            }
            if (event.key === Qt.Key_Up) {
                playArea.y += 200
            }
            if (event.key === Qt.Key_Down) {
                playArea.y -= 200
            }
            if (playArea.x >= mousePan.drag.maximumX) {
                playArea.x = mousePan.drag.maximumX
            }
            if (playArea.y >= mousePan.drag.maximumY) {
                playArea.y = mousePan.drag.maximumY
            }
            if (playArea.x <= mousePan.drag.minimumX) {
                playArea.x = mousePan.drag.minimumX
            }
            if (playArea.y <= mousePan.drag.minimumY) {
                playArea.y = mousePan.drag.minimumY
            }
        }

        onHoriChanged: {
            if (hori == true) {
                playArea.x += items.toolsMargin
                playArea.y -= items.toolsMargin
            } else {
                playArea.x -= items.toolsMargin
                playArea.y += items.toolsMargin
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias playArea: playArea
            property alias mousePan: mousePan
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias availablePieces: availablePieces
            property alias toolTip: toolTip
            property alias infoTxt: infoTxt
            property alias truthTablesModel: truthTablesModel
            property alias displayTruthTable: inputOutputTxt.displayTruthTable
            property alias dataset: dataset
            property alias tutorialDataset: tutorialDataset
            property string mode: "tutorial"
            property bool isTutorialMode: mode == "tutorial" ? true : false
            property alias infoImage: infoImage
            property alias tutorialInstruction: tutorialInstruction
            property real toolsMargin: 90 * ApplicationInfo.ratio
            property real zoomLvl: 0.25
        }

        Loader {
            id: dataset
            asynchronous: false
        }

        TutorialDataset {
            id: tutorialDataset
        }

        IntroMessage {
            id: tutorialInstruction
            intro: []
            textContainerWidth: background.hori ? parent.width - inputComponentsContainer.width - items.toolsMargin : 0.9 * background.width
            textContainerHeight: background.hori ? 0.5 * parent.height : parent.height - inputComponentsContainer.height - (bar.height * 2) - items.toolsMargin
            anchors {
                fill: undefined
                top: background.hori ? parent.top : inputComponentsContainer.bottom
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: background.hori ? inputComponentsContainer.right : parent.left
                leftMargin: 5
            }
            z: 5
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle {
            id: visibleArea
            color: "#00000000"
            width: background.hori ? background.width - items.toolsMargin - 10 : background.width - 10
            height: background.hori ? background.height - bar.height - items.toolsMargin - 10 : background.height - bar.height - 10
            anchors {
                fill: undefined
                top: background.hori ? parent.top : inputComponentsContainer.bottom
                topMargin: 5
                right: parent.right
                rightMargin: 5
                left: background.hori ? inputComponentsContainer.right : parent.left
                leftMargin: 5
                bottom: bar.top
                bottomMargin: 20
            }
            z: 6

            GCText {
                id: infoTxt
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 2
                }
                fontSizeMode: Text.Fit
                minimumPixelSize: 10
                font.pixelSize: 150
                color: "white"
                horizontalAlignment: Text.AlignHLeft
                width: Math.min(implicitWidth, 0.90 * parent.width)
                height:  inputOutputTxt.visible == false ? Math.min(implicitHeight, 0.7 * parent.height) :
                        Math.min(implicitHeight, (inputOutputTxt.inputs > 2 ? 0.3 : 0.4) * parent.height)
                wrapMode: TextEdit.WordWrap
                visible: false
                z: 4
            }

            Rectangle {
                id: infoTxtContainer
                anchors.fill: parent
                opacity: 1
                radius: 10
                color: "#373737"
                border.width: 2
                border.color: "#F2F2F2"
                visible: infoTxt.visible
                MouseArea {
                    anchors.fill: parent
                    onClicked: infoTxt.visible = false
                }
                z: 3
            }

            Image {
                id: infoImage
                property bool imgVisible: false
                height: source == "" ? 0 : parent.height * 0.3 - 10
                width: source == "" ? 0 : parent.width - 10
                fillMode: Image.PreserveAspectFit
                visible: infoTxt.visible && imgVisible
                anchors {
                    top: infoTxt.bottom
                    horizontalCenter: infoTxtContainer.horizontalCenter
                }
                z: 5
            }

            ListModel {
                id: truthTablesModel
                property int rows
                property int columns
                property int inputs
                property int outputs
            }

            Row {
                id: inputOutputTxt
                z: 5
                property bool displayTruthTable
                visible: infoTxt.visible && displayTruthTable
                property int inputs: truthTablesModel.inputs
                property int outputs: truthTablesModel.outputs
                property int cellSize: (inputs > 2 ? 0.65 : 0.5) * parent.height / (truthTablesModel.rows + 1)
                property int maxWidth: Math.min(cellSize, parent.width * 0.95 / truthTablesModel.columns)
                property int minSize: 2.5 * cellSize
                height: cellSize
                anchors {
                    top: infoTxt.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                Rectangle {
                    color: "#A7D9F9"
                    width: inputOutputTxt.inputs > 1 ? inputOutputTxt.maxWidth * inputOutputTxt.inputs : inputOutputTxt.minSize
                    height: inputOutputTxt.cellSize
                    border.color: "#373737"
                    border.width: 1
                    GCText {
                        anchors.centerIn: parent
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 10
                        color: "#353535"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                        width: parent.width
                        text: qsTr("Input")
                    }
                }
                Rectangle {
                    color: "#A7F9DD"
                    width: inputOutputTxt.outputs > 1 ? inputOutputTxt.maxWidth * inputOutputTxt.outputs : inputOutputTxt.minSize
                    height: inputOutputTxt.cellSize
                    border.color: "#373737"
                    border.width: 1
                    GCText {
                        anchors.centerIn: parent
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 10
                        color: "#353535"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                        width: parent.width
                        text: qsTr("Output")
                    }
                }
            }

            Grid {
                id: truthTable
                rows: truthTablesModel.rows
                columns: truthTablesModel.columns
                height: rows * inputOutputTxt.cellSize
                z: 5
                visible: inputOutputTxt.visible
                anchors {
                    top: inputOutputTxt.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                Repeater {
                    id: repeater
                    model: truthTablesModel
                    delegate: blueSquare
                    Component {
                        id: blueSquare
                        Rectangle {
                            width: ((index % truthTable.columns) / (truthTablesModel.inputs - 1)) <= 1 ?
                                   (inputOutputTxt.inputs > 1 ? inputOutputTxt.maxWidth : inputOutputTxt.minSize) :
                                   (inputOutputTxt.outputs > 1 ? inputOutputTxt.maxWidth : inputOutputTxt.minSize)
                            height: inputOutputTxt.cellSize
                            border.color: "#373737"
                            border.width: 1
                            color: {
                                if(truthTablesModel.inputs == 1) {
                                    return index%2 == 0 ? "#A7D9F9" : "#A7F9DD"
                                }
                                else {
                                    return ((index % truthTable.columns) / (truthTablesModel.inputs - 1)) <= 1 ? "#A7D9F9" : "#A7F9DD"
                                }
                            }

                            GCText {
                                id: truthTableValue
                                anchors.centerIn: parent
                                fontSizeMode: Text.Fit
                                minimumPixelSize: 10
                                color: "#353535"
                                horizontalAlignment: Text.AlignHCenter
                                height: parent.height
                                width: parent.width
                                text: value
                            }
                        }
                    }
                }
            }

        }

        Rectangle {
            id: playArea
            color: "#10000000"
            x: background.hori ? items.toolsMargin : 0
            y: background.hori ? 0 : items.toolsMargin
            width: background.hori ?
                       background.width * 4 - items.toolsMargin : background.width * 4
            height: background.hori ?
                       background.height * 4 - (bar.height * 1.1) :
                       background.height * 4 - (bar.height * 1.1) - items.toolsMargin

            PinchArea {
                id: pinchZoom
                anchors.fill: parent
                onPinchFinished: {
                    if (pinch.scale < 1) {
                        Activity.zoomOut()
                    }
                    if (pinch.scale > 1) {
                        Activity.zoomIn()
                    }
                }
                MouseArea {
                    id: mousePan
                    anchors.fill: parent
                    scrollGestureEnabled: false //needed for pinchZoom
                    drag.target: playArea
                    drag.axis: Drag.XandYAxis
                    drag.minimumX: - playArea.width * items.zoomLvl
                    drag.maximumX: background.hori ? items.toolsMargin : 0
                    drag.minimumY: - playArea.height * items.zoomLvl
                    drag.maximumY: background.hori ? 0 : items.toolsMargin
                    onClicked: {
                        Activity.disableToolDelete();
                        Activity.deselect();
                        availablePieces.hideToolbar();
                    }
                }
            }
        }

        Rectangle {
            id: inputComponentsContainer
            width: background.hori ?
                       items.toolsMargin :
                       background.width
            height: background.hori ?
                        background.height :
                        items.toolsMargin
            color: "#4A3823"
            anchors.left: parent.left
            Image {
                anchors.fill: parent
                anchors.rightMargin: background.hori ? 3 * ApplicationInfo.ratio : 0
                anchors.bottomMargin: background.hori ? 0 : 3 * ApplicationInfo.ratio
                source: Activity.url + "texture01.webp"
                fillMode: Image.Tile
                ListWidget {
                    id: availablePieces
                    hori: background.hori
                }
            }
            z: 10
        }

        Rectangle {
            id: toolTip
            anchors {
                bottom: bar.top
                bottomMargin: 10
                left: inputComponentsContainer.left
                leftMargin: 5
            }
            width: toolTipTxt.width + 10
            height: toolTipTxt.height + 5
            color: "#373737"
            opacity: 1
            radius: 10
            z: 100
            border.width: 2
            border.color: "#F2F2F2"
            property alias text: toolTipTxt.text
            Behavior on opacity { NumberAnimation { duration: 120 } }

            function show(newText) {
                if(newText) {
                    text = newText
                    opacity = 1
                } else {
                    opacity = 0
                }
            }

            GCText {
                id: toolTipTxt
                anchors.centerIn: parent
                fontSize: regularSize
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BarButton {
            id: okButton
            visible: items.isTutorialMode
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                bottomMargin: height * 0.5
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 60 * ApplicationInfo.ratio
            enabled: !tutorialInstruction.visible && !bonus.isPlaying
            onClicked: Activity.checkAnswer()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | (items.isTutorialMode ? level : 0) | reload | activityConfig}
            onHelpClicked: {displayDialog(dialogHelp)}
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onReloadClicked: Activity.reset()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
