/* GCompris - DigitalElectricity.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "digital_electricity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string mode: "tutorial"
    property bool isTutorialMode: mode == "tutorial" ? true : false

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ffffb3"
        signal start
        signal stop

        property bool vert: background.width > background.height

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Plus) {
                Activity.zoomIn()
            }
            if (event.key == Qt.Key_Minus) {
                Activity.zoomOut()
            }
            if (event.key == Qt.Key_Right) {
                Activity.move(Activity.direction.RIGHT)
            }
            if (event.key == Qt.Key_Left) {
                Activity.move(Activity.direction.LEFT)
            }
            if (event.key == Qt.Key_Up) {
                Activity.move(Activity.direction.UP)
            }
            if (event.key == Qt.Key_Down) {
                Activity.move(Activity.direction.DOWN)
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias playArea: playArea
            property alias bar: bar
            property alias bonus: bonus
            property alias availablePieces: availablePieces
            property alias toolTip: toolTip
            property alias infoTxt: infoTxt
            property alias truthTablesModel: truthTablesModel
            property alias displayTruthTable: inputOutputTxt.displayTruthTable
            property alias dataset: dataset
            property alias tutorialDataset: tutorialDataset
            property alias infoImage: infoImage
            property bool isTutorialMode: activity.isTutorialMode
            property alias tutorialInstruction: tutorialInstruction
        }

        Loader {
            id: dataset
            asynchronous: false
        }

        Dataset {
            id: tutorialDataset
        }

        IntroMessage {
            id: tutorialInstruction
            intro: []
            anchors {
                top: background.vert ? parent.top : inputComponentsContainer.bottom
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: background.vert ? inputComponentsContainer.right : parent.left
                leftMargin: 5
            }
            z: 5
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle {
            id: playArea

            color: "#ffffb3"
            x: background.vert ? 90 * ApplicationInfo.ratio : 0
            y: background.vert ? 0 : 90 * ApplicationInfo.ratio
            width: background.vert ?
                       background.width - 90 * ApplicationInfo.ratio : background.width
            height: background.vert ?
                       background.height - (bar.height * 1.1) :
                       background.height - (bar.height * 1.1) - 90 * ApplicationInfo.ratio
            MouseArea {
                anchors.fill: parent
                onClicked: Activity.deselect()
            }

            GCText {
                id: infoTxt
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: infoTxtContainer.top
                    topMargin: 2
                }
                fontSizeMode: Text.Fit
                minimumPixelSize: 10
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHLeft
                width: Math.min(implicitWidth, 0.90 * parent.width)
                height: inputOutputTxt.visible == false ? Math.min(implicitHeight, 0.9 * parent.height) :
                        Math.min(implicitHeight, (inputOutputTxt.inputs > 2 ? 0.3 : 0.4) * parent.height)
                wrapMode: TextEdit.WordWrap
                visible: false
                z: 4
            }

            Rectangle {
                id: infoTxtContainer
                anchors.centerIn: parent
                width: infoTxt.width + 20
                height: inputOutputTxt.visible == false ? infoTxt.height + infoImage.height + 6 :
                        infoTxt.height + inputOutputTxt.height + truthTable.height + 8
                opacity: 0.8
                radius: 10
                border.width: 2
                border.color: "black"
                visible: infoTxt.visible
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: infoTxt.visible = false
                }
                z: 3
            }

            Image {
                id: infoImage
                property int heightNeed: parent.height - infoTxt.height
                property bool imgVisible: false
                height: source == "" ? 0 : parent.height - infoTxt.height - 10
                width: source == "" ? 0 : parent.width - 10
                fillMode: Image.PreserveAspectFit
                visible: infoTxt.visible && imgVisible
                anchors {
                    top: infoTxt.bottom
                    horizontalCenter: parent.horizontalCenter
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
                property int cellSize: Math.min(parent.height - infoTxt.height - 10, (inputs > 2 ? 0.6 :
                                       0.45) * parent.height) / truthTablesModel.rows
                property int minSize: 2 * cellSize
                height: cellSize
                anchors {
                    top: infoTxt.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                Rectangle {
                    color: "#c7ecfb"
                    width: Math.max(inputOutputTxt.minSize, inputOutputTxt.cellSize * inputOutputTxt.inputs)
                    height: inputOutputTxt.cellSize
                    border.color: "black"
                    border.width: 1
                    GCText {
                        anchors.centerIn: parent
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 10
                        color: "white"
                        style: Text.Outline
                        styleColor: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                        width: parent.width
                        text: qsTr("Input")
                    }
                }
                Rectangle {
                    color: "#47ffc2"
                    width: Math.max(inputOutputTxt.minSize, inputOutputTxt.cellSize * inputOutputTxt.outputs) * 1.5
                    height: inputOutputTxt.cellSize
                    border.color: "black"
                    border.width: 1
                    GCText {
                        anchors.centerIn: parent
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 10
                        color: "white"
                        style: Text.Outline
                        styleColor: "black"
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
                                   (inputOutputTxt.inputs > 1 ? inputOutputTxt.cellSize : inputOutputTxt.minSize) :
                                   (inputOutputTxt.outputs > 1 ? inputOutputTxt.cellSize : inputOutputTxt.minSize) * 1.5
                            height: inputOutputTxt.cellSize
                            border.color: "black"
                            border.width: 1
                            color: ((index % truthTable.columns) / (truthTablesModel.inputs - 1)) <= 1 ?
                                   "#c7ecfb" : "#47ffc2"
                            GCText {
                                id: truthTableValue
                                anchors.centerIn: parent
                                fontSizeMode: Text.Fit
                                minimumPixelSize: 10
                                color: "white"
                                style: Text.Outline
                                styleColor: "black"
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
            id: inputComponentsContainer
            width: background.vert ?
                       90 * ApplicationInfo.ratio :
                       background.width
            height: background.vert ?
                        background.height :
                        90 * ApplicationInfo.ratio
            color: "#FFFF42"
            border.color: "#FFD85F"
            border.width: 4
            anchors.left: parent.left
            ListWidget {
                id: availablePieces
                vert: background.vert ? true : false
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
            opacity: 1
            radius: 10
            z: 100
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            property alias text: toolTipTxt.text
            Behavior on opacity { NumberAnimation { duration: 120 } }

            function show(newText) {
                if(newText) {
                    text = newText
                    opacity = 0.8
                } else {
                    opacity = 0
                }
            }

            GCText {
                id: toolTipTxt
                anchors.centerIn: parent
                fontSize: regularSize
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias modesComboBox: modesComboBox

                    property var availableModes: [
                        { "text": qsTr("Tutorial Mode"), "value": "tutorial" },
                        { "text": qsTr("Free Mode"), "value": "free" },
                    ]

                    Flow {
                        id: flow
                        spacing: 5
                        width: dialogActivityConfig.width
                        GCComboBox {
                            id: modesComboBox
                            model: availableModes
                            background: dialogActivityConfig
                            label: qsTr("Select your Mode")
                        }
                    }
                }
            }

            onClose: home();

            onLoadData: {
                if(dataToSave && dataToSave["modes"]) {
                    activity.mode = dataToSave["modes"];
                }
            }

            onSaveData: {
                var newMode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.modesComboBox.currentIndex].value;
                if (newMode !== activity.mode) {
                    activity.mode = newMode;
                    dataToSave = {"modes": activity.mode};
                    Activity.reset()
                }
            }

            function setDefaultValues() {
                for(var i = 0 ; i < dialogActivityConfig.configItem.availableModes.length; i ++) {
                    if(dialogActivityConfig.configItem.availableModes[i].value === activity.mode) {
                        dialogActivityConfig.configItem.modesComboBox.currentIndex = i;
                        break;
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BarButton {
            id: okButton
            visible: activity.isTutorialMode
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 60 * ApplicationInfo.ratio

            onClicked: Activity.checkAnswer()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | ( activity.isTutorialMode ? level : 0) | reload | config}
            onHelpClicked: {displayDialog(dialogHelp)}
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.reset()
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues()
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
