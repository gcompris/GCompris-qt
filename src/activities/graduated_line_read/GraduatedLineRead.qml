/* GCompris - GraduatedLineRead.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0
import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "graduated_line_read.js" as Activity

ActivityBase {
    id: activity
    property string activityMode: "tick2number" // Possible values: tick2number, number2tick
    property string instruction: qsTr("Find the requested number.")

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: height
        signal start
        signal stop

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
            property int currentSubLevel: 0
            property int numberOfSubLevel: 0
            property alias bonus: bonus
            property alias score: score
            property alias numPad: numPad
            property var levels: activity.datasets
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias clickSound: clickSound
            property alias smudgeSound: smudgeSound
            property int solutionGrad: 0                // Solution's graduation
            property int orientation: Qt.LeftToRight      // Updated with ApplicationSettings in start() function

            property alias ruler: ruler
            property alias cursor: cursor
            property alias rulerModel: rulerModel
            property alias leftLimit: leftLimit
            property alias rightLimit: rightLimit
            property string answer: ""
            property alias errorRectangle: errorRectangle
            property bool buttonsBlocked: false
            property int segmentThickness: GCStyle.thinBorder
        }

        onStart: { Activity.start(items, activity.activityMode) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: clickSound
            source: "qrc:/gcompris/src/core/resource/sounds/audioclick.wav"
        }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            textItem.text: activity.instruction
        }

        Item {
            id: layoutArea
            anchors.top: instructionPanel.bottom
            anchors.bottom: activityBackground.bottom
            anchors.bottomMargin: 1.2 * bar.height
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            anchors.margins: GCStyle.baseMargins
        }

        ListModel { id: rulerModel }

        Rectangle {
            id: rulerView
            anchors.top: layoutArea.top
            anchors.left: layoutArea.left
            anchors.right: layoutArea.right
            height: Math.min(120 * ApplicationInfo.ratio, layoutArea.height * 0.4)
            color: "#e9e9e9"
            radius: GCStyle.baseMargins
            property real rulerWidth: rulerView.width - leftLimit.width
            property real rulerModelWidth: ruler.width / (rulerModel.count - 1)
            Column {
                id: rulerViewColumn
                width: rulerView.rulerWidth
                height: parent.height - GCStyle.baseMargins - leftLimit.contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: rulerView.rulerModelWidth * ((items.orientation === Qt.LeftToRight) ? -0.5 : 0.5)
                anchors.top: parent.top
                anchors.topMargin: GCStyle.baseMargins
                Row {
                    id: cursor
                    z: 100
                    width: parent.width
                    height: parent.height * 0.4
                    anchors.horizontalCenter: parent.horizontalCenter
                    layoutDirection: items.orientation
                    Repeater {
                        model: rulerModel
                        delegate : Item {
                            required property int index
                            required property int value_
                            property int value: value_
                            property bool hidden: (index !== items.solutionGrad)
                            property alias textValue: txt.text
                            width: rulerView.rulerModelWidth
                            height: parent.height
                            opacity: hidden ? 0.0 : 1.0
                            Image {
                                visible: activity.activityMode === "number2tick"
                                source: "qrc:/gcompris/src/activities/graduated_line_read/resource/arrow.svg"
                                anchors.centerIn: parent
                                anchors.verticalCenterOffset: GCStyle.halfMargins
                                height: parent.height
                                width: height
                                sourceSize.width: height
                            }
                            Rectangle {
                                id: txtBg
                                visible: activity.activityMode === "tick2number" ? true : txt.text != ""
                                anchors.centerIn: parent
                                height: parent.height
                                width: 90 * ApplicationInfo.ratio
                                radius: GCStyle.tinyMargins
                                color: GCStyle.whiteBg
                                border.color: "#633E0C"
                                border.width:  GCStyle.thinBorder
                            }
                            GCText {
                                id: txt
                                anchors.centerIn: txtBg
                                height: txtBg.height - GCStyle.baseMargins
                                width: txtBg.width - GCStyle.baseMargins
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: ""
                                fontSize: mediumSize
                                fontSizeMode: Text.Fit
                                color: GCStyle.darkText
                            }
                        }
                    }
                }

                Row {
                    id: ruler
                    width: rulerView.rulerWidth
                    height: parent.height * 0.6
                    layoutDirection: items.orientation
                    anchors.horizontalCenter: parent.horizontalCenter
                    Repeater {
                        model: rulerModel
                        delegate : Item {
                            id: rulerElement
                            required property int index
                            required property int value_
                            required property int thickness_
                            property int value: value_
                            property int thickness: thickness_
                            width: rulerView.rulerModelWidth
                            height: parent.height
                            transform: Scale { origin.x: width * 0.5; xScale: (items.orientation === Qt.LeftToRight) ? 1 : -1 }

                            Rectangle {     // Line between graduations
                                width: (rulerElement.index && (rulerElement.index !== (rulerModel.count - 1))) ? parent.width : parent.width * 0.5
                                height: items.segmentThickness
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: (rulerElement.index) ? parent.left : undefined
                                anchors.right: (!rulerElement.index) ? parent.right : undefined
                                color: "#c27a33"
                            }
                            Rectangle {     // vertical graduation
                                width: rulerElement.thickness
                                height: ((!rulerElement.index) || (rulerElement.index === (rulerModel.count - 1)) || (rulerElement.index === items.solutionGrad))
                                ?  parent.height : (parent.height * 0.5)
                                anchors.centerIn: parent
                                color: (rulerElement.index === items.solutionGrad) ? "#633E0C" : "#c27a33"
                                radius: (rulerElement.index === items.solutionGrad) ? 0 : width * 0.5
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            anchors.centerIn: leftLimit
            width: GCStyle.baseMargins
            height: leftLimit.contentHeight
            color: "#e9e9e9"
        }

        GCText {
            id: leftLimit
            width: 80 * ApplicationInfo.ratio
            anchors.left: layoutArea.left
            anchors.bottom: rulerView.bottom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: smallSize
            fixFontSize: true
        }

        Rectangle {
            anchors.centerIn: rightLimit
            width: GCStyle.baseMargins
            height: rightLimit.contentHeight
            color: "#e9e9e9"
        }

        GCText {
            id: rightLimit
            width: leftLimit.width
            anchors.right: layoutArea.right
            anchors.bottom: rulerView.bottom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: smallSize
            fixFontSize: true
        }

        ErrorRectangle {
            id: errorRectangle
            width: activity.activityMode === "tick2number" ? 90 * ApplicationInfo.ratio : 0
            height: cursor.height
            property real cursorOffset: (rulerView.rulerModelWidth - width) * 0.5
            x: items.orientation === Qt.LeftToRight ? rulerView.x + rulerViewColumn.x + cursor.x + rulerView.rulerModelWidth * items.solutionGrad + cursorOffset :
                rulerView.x + rulerView.width - rulerViewColumn.x - cursor.x - rulerView.rulerModelWidth * items.solutionGrad + cursorOffset
            y: rulerView.y + rulerViewColumn.y + cursor.y
            radius: GCStyle.tinyMargins
            imageSize: height * 1.2
            function releaseControls() {
                items.buttonsBlocked = false;
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
            ListElement { label: "<<";  key: Qt.Key_Backspace }
            ListElement { label: "0";  key: Qt.Key_0 }
            ListElement { label: "C";  key: Qt.Key_Delete }
        }

        Row {
            id: tools
            width: childrenRect.width
            height: layoutArea.height - rulerView.height - anchors.topMargin
            anchors.top: rulerView.bottom
            anchors.topMargin: GCStyle.baseMargins * 2
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: GCStyle.baseMargins
            Image {
                id: leftButton
                source: 'qrc:/gcompris/src/core/resource/arrow_left.svg'
                smooth: true
                width: Math.min(GCStyle.bigButtonHeight, layoutArea.width * 0.15)
                height: width
                sourceSize.width: width
                sourceSize.height: width
                fillMode: Image.PreserveAspectFit
                visible: (activity.activityMode === "number2tick")
                MouseArea {
                    id: leftArea
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: !items.buttonsBlocked
                    onContainsMouseChanged: leftButton.scale = (containsMouse) ? 1.1 : 1.0
                    onClicked: (items.orientation === Qt.LeftToRight) ? Activity.moveLeft() : Activity.moveRight()
                }
                Behavior on scale {
                    PropertyAnimation {
                        target: leftButton
                        properties: "scale"
                        duration: 100
                    }
                }
            }

            Rectangle {
                width: 80 * ApplicationInfo.ratio
                height: 40 * ApplicationInfo.ratio
                color: "white"
                radius: GCStyle.halfMargins
                anchors.verticalCenter: leftButton.verticalCenter
                visible: (activity.activityMode === "number2tick")
                GCText {
                    anchors.centerIn: parent
                    width: parent.width - GCStyle.baseMargins
                    height: parent.height - GCStyle.baseMargins
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    fontSize: mediumSize
                    text: items.answer
                }
            }

            Image {
                id: rightButton
                source: 'qrc:/gcompris/src/core/resource/arrow_right.svg'
                smooth: true
                width: leftButton.width
                height: leftButton.width
                sourceSize.width: leftButton.width
                sourceSize.height: leftButton.width
                fillMode: Image.PreserveAspectFit
                visible: (activity.activityMode === "number2tick")
                MouseArea {
                    id: rightArea
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: !items.buttonsBlocked
                    onContainsMouseChanged: rightButton.scale = (containsMouse) ? 1.1 : 1.0
                    onClicked: (items.orientation === Qt.LeftToRight) ? Activity.moveRight() : Activity.moveLeft()
                }
                Behavior on scale {
                    PropertyAnimation {
                        target: rightButton
                        properties: "scale"
                        duration: 100
                    }
                }
            }

            GridView {
                id: numPad
                width: Math.ceil(3 * cellWidth)
                height: Math.ceil(4 * cellHeight)
                cellWidth: Math.min(60 * ApplicationInfo.ratio, layoutArea.width / 9)
                cellHeight: Math.min(40 * ApplicationInfo.ratio, tools.height / 4)
                interactive: false
                visible: (activity.activityMode === "tick2number")
                model: padModel

                delegate: Rectangle {
                    id: numKey
                    width: numPad.cellWidth - GCStyle.tinyMargins
                    height: numPad.cellHeight - GCStyle.tinyMargins
                    anchors.margins: border.width
                    color: numArea.containsMouse ? "#C0C0C0" : "#E5E5E5"
                    border.color: GCStyle.grayBorder
                    border.width: GCStyle.thinnestBorder
                    radius: GCStyle.tinyMargins

                    required property var key
                    required property int index
                    required property string label

                    GCText {
                        anchors.centerIn: parent
                        width: parent.width - GCStyle.baseMargins
                        height: parent.height - GCStyle.baseMargins
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSizeMode: Text.Fit
                        fontSize: mediumSize
                        text: numKey.label
                    }
                    MouseArea {
                        id: numArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !items.buttonsBlocked
                        onClicked: Activity.handleKeys(numKey.key)
                    }
                    states: [
                        State {
                            name: ""
                            PropertyChanges {
                                numKey {
                                    color: numArea.containsMouse ? "#C0C0C0" : "#E5E5E5"
                                }
                            }
                        },
                        State {
                            name: "pressed"
                            PropertyChanges {
                                numKey {
                                    color: "#999"
                                }
                            }
                        }
                    ]
                    transitions: [
                        Transition {
                            to: "pressed"
                            SequentialAnimation {
                                ScriptAction { script: clickSound.play() }
                                ColorAnimation { duration: 100 }
                                ScriptAction { script: state = "" }
                            }
                        }
                    ]
                    Component.onCompleted: Activity.mapToPad[key] = index
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
            onClose: {
                activity.home()
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        Score {
            id: score
            numberOfSubLevels: items.numberOfSubLevel
            currentSubLevel: items.currentSubLevel
            anchors.top: undefined
            anchors.bottom: activityBackground.bottom
            anchors.bottomMargin: bar.height * 1.5
            anchors.right: activityBackground.right
            anchors.rightMargin: GCStyle.baseMargins
            onStop: Activity.nextSubLevel()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: activity.displayDialog(dialogHelp)
            onActivityConfigClicked: activity.displayDialog(dialogActivityConfig)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: Math.min(GCStyle.bigButtonHeight, tools.height * 0.4)
            anchors.bottom: score.top
            anchors.bottomMargin: GCStyle.baseMargins
            anchors.horizontalCenter: score.horizontalCenter
            onClicked: Activity.checkResult()
            visible: (items.cursor.children[items.solutionGrad].textValue !== "") || (activityMode === "number2tick")
            mouseArea.enabled: !items.buttonsBlocked
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Keys.onPressed: (event) => { Activity.handleEvents(event) }
    }

}
