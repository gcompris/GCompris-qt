/* GCompris - GraduatedLineRead.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "graduated_line_read.js" as Activity

ActivityBase {
    id: activity
    property string activityMode: "tick2number" // Possible values: tick2number, number2tick
    property string instruction: qsTr("Find the requested number.")

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
            property alias background: background
            property int currentLevel: activity.currentLevel
            property int currentSubLevel: 0
            property int numberOfSubLevel: 0
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias numPad: numPad
            property var levels: activity.datasetLoader.data
            property GCSfx audioEffects: activity.audioEffects

            property int solutionGrad: 0                // Solution's graduation
            property int rulerHeight: 100
            property int orientation: Qt.LeftToRight      // Updated with ApplicationSettings in start() function

            property alias ruler: ruler
            property alias cursor: cursor
            property alias rulerModel: rulerModel
            property alias leftLimit: leftLimit
            property alias rightLimit: rightLimit
            property string answer: ""
            property alias errorRectangle: errorRectangle
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items, activityMode) }
        onStop: { Activity.stop() }

        GCText {
            id: caption
            anchors.top: parent.top
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            fontSize: mediumSize
            height: 120
            text: activity.instruction
        }

        ListModel { id: rulerModel }

        Rectangle {
            id: rulerView
            anchors.top: caption.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40
            height: 20 * items.rulerHeight / 10
            color: "beige"
            radius: 5
            Column {
                width: parent.width
                height: 7 * items.rulerHeight / 10
                anchors.margins: 30
                anchors.horizontalCenter: parent.horizontalCenter
                Row {
                    id: cursor
                    width: parent.width - 20
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    layoutDirection: items.orientation
                    Repeater {
                        model: rulerModel
                        delegate : Rectangle {
                            property int value: value_
                            property bool hidden: (index !== items.solutionGrad)
                            property alias textValue: txt.text
                            width: ruler.width / rulerModel.count
                            height: parent.height
                            color: "transparent"
                            opacity: hidden ? 0.0 : 1.0
                            Rectangle {
                                width: 180
                                height: 80 * parent.height / 100
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                radius: 10
                                color: "white"
                                border.width: 3
                            }
                            GCText {
                                id: txt
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignBottom
                                text: ""
                                fontSize: smallSize
                            }
                        }
                    }
                }

                Row {
                    id: ruler
                    width: parent.width - 20
                    height: items.rulerHeight
                    layoutDirection: items.orientation
                    anchors.horizontalCenter: parent.horizontalCenter
                    Repeater {
                        model: rulerModel
                        delegate : Rectangle {
                            property int value: value_
                            property int thickness: thickness_
                            width: ruler.width / rulerModel.count
                            height: 100
                            color: "transparent"
                            transform: Scale { origin.x: width / 2; xScale: (items.orientation === Qt.LeftToRight) ? 1 : -1 }
                            Column {
                                height: parent.height
                                width: parent.width
                                spacing: 0
                                Rectangle {
                                    width: parent.width
                                    height: 8 * items.rulerHeight / 10
                                    color: "transparent"
                                    Rectangle {     // Line between graduations
                                        width: (index && (index !== (rulerModel.count - 1))) ? parent.width : parent.width / 2
                                        height: Activity.segmentThickness
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: (index) ? parent.left : undefined
                                        anchors.right: (!index) ? parent.right : undefined
                                        color: "peru"
                                    }
                                    Rectangle {     // vertical graduation
                                        width: thickness
                                        height: ((!index) || (index === (rulerModel.count - 1)) || (index === items.solutionGrad))
                                                ?  parent.height : (parent.height / 2)
                                        anchors.centerIn: parent
                                        color: (index === items.solutionGrad) ? "black" : "peru"
                                        radius: 3
                                    }
                                }
                            }
                        }
                    }
                }
            }
            GCText {
                id: leftLimit
                width: ruler.width / rulerModel.count
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                horizontalAlignment: Text.AlignHCenter
                fontSize: smallSize
            }
            GCText {
                id: rightLimit
                width: ruler.width / rulerModel.count
//                width: 300
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignHCenter
                fontSize: smallSize
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
            height: NumPad.height
            anchors.top: rulerView.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 100
            Image {
                id: leftButton
                source: 'qrc:/gcompris/src/core/resource/arrow_left.svg'
                smooth: true
                width: 100
                height: 100
                sourceSize.width: width
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                visible: (activityMode === "number2tick")
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
                width: 200
                height: 80
                color: "white"
                border.width: 3
                radius: 10
                anchors.verticalCenter: parent.verticalCenter
                visible: (activityMode === "number2tick")
                GCText {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    fontSize: mediumSize
                    text: items.answer
                }
            }

            GridView {
                id: numPad
                width: 3 * cellWidth
                height: 4 * cellHeight
                cellWidth: 84
                cellHeight: 64
                interactive: false
                visible: (activityMode === "tick2number")
                model: padModel
                delegate: Rectangle {
                    id: numKey
                    width: 80
                    height: 60
                    anchors.margins: 2
                    color: numArea.containsMouse ? "darkgray" : "lightgray"
                    border.color: "gray"
                    border.width: 2
                    radius: 5
                    GCText {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: label
                    }
                    MouseArea {
                        id: numArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !items.buttonsBlocked
                        onClicked: Activity.handleKeys(key)
                    }
                    states: [
                        State {
                            name: ""
                            PropertyChanges {
                                target: numKey
                                color: numArea.containsMouse ? "darkgray" : "lightgray"
                            }
                        },
                        State {
                            name: "pressed"
                            PropertyChanges {
                                target: numKey
                                color: "dimgray"
                            }
                        }
                    ]
                    transitions: [
                        Transition {
                            to: "pressed"
                            SequentialAnimation {
                                ScriptAction { script: audioEffects.play('qrc:/gcompris/src/core/resource/sounds/audioclick.wav') }
                                ColorAnimation { duration: 100 }
                                ScriptAction { script: state = "" }
                            }
                        }
                    ]
                    Component.onCompleted: Activity.mapToPad[key] = index
                }


                ErrorRectangle { // TODO Would be good to have it in the cursor
                    id: errorRectangle
                    anchors.fill: parent
                    imageSize: 60 * ApplicationInfo.ratio
                    function releaseControls() {
                        items.buttonsBlocked = false;
                    }
                }
            }
            Image {
                id: rightButton
                source: 'qrc:/gcompris/src/core/resource/arrow_right.svg'
                smooth: true
                width: 100
                height: 100
                sourceSize.width: width
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                visible: (activityMode === "number2tick")
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

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Score {
            id: score
            numberOfSubLevels: items.numberOfSubLevel
            currentSubLevel: items.currentSubLevel
            anchors.top: undefined
            anchors.right: rulerView.right
            anchors.left: undefined
            anchors.bottom: rulerView.top
            anchors.bottomMargin: 10
            margins: 0
            onStop: Activity.nextSubLevel()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: displayDialog(dialogHelp)
            onActivityConfigClicked: displayDialog(dialogActivityConfig)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 100
            anchors.top: tools.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            sourceSize.width: width
            onClicked: Activity.checkResult()
            visible: (items.cursor.children[items.solutionGrad].textValue !== "") || (activityMode === "number2tick")
            mouseArea.enabled: !items.buttonsBlocked
        }
        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
        Keys.onPressed: Activity.handleEvents(event)
    }

}
