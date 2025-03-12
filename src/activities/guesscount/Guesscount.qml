/* GCompris - guesscount.qml
 *
 * SPDX-FileCopyrightText: 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import "../../core"
import "guesscount.js" as Activity
import "dataset.js" as Data

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    property bool needRestart: true

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.baseUrl + "/backgroundW01.svg"
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(warningDialog.visible)
                    warningDialog.visible = false
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias operatorRow: operatorRow
            property alias operandRow: operandRow
            property var data
            readonly property var levels: activity.datasets
            property int result: 0
            property alias warningDialog: warningDialog
            property alias goodAnswerSound: goodAnswerSound
            property bool clearOperations: false
            property bool solved: false
            property var levelArr: Data.defaultOperators
            property string mode: "builtin"
            property int currentlevel
        }

        onStart: if (activity.needRestart) {
                     Activity.start(items);
                     activity.needRestart = false;
                 }
                 else
                     Activity.initLevel();
        onStop: { Activity.stop() }


        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        JsonParser {
            id: parser
            onError: (msg) => console.error("Guesscount: Error parsing JSON: " + msg);
        }

        Loader {
            id: admin
            active: false
            sourceComponent: Column {
                spacing: GCStyle.baseMargins
                width: parent.width
                height: parent.height

                Repeater {
                    id:levels
                    model: 8
                    Admin {
                        id:level
                        level: modelData+1
                        width: parent.width
                        height: parent.height
                        data: items.data
                    }
                }
            }
        }

        Item {
            id: top
            z: 10
            height: score.height
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: GCStyle.baseMargins
            }
            Score {
                id: score
                anchors.left: parent.left
                anchors.right: undefined
                anchors.top: undefined
                anchors.bottom: undefined
                anchors.margins: 0
                anchors.verticalCenter: parent.verticalCenter
                radius: GCStyle.halfMargins
                currentSubLevel: 0
                onStop: Activity.nextSubLevel()

            }
            Rectangle {
                id: guessLabel
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: score.right
                anchors.leftMargin: GCStyle.baseMargins
                radius: GCStyle.halfMargins
                border.color: "orange"
                border.width: GCStyle.midBorder
                color: GCStyle.paperWhite
                GCText {
                    id: guess
                    anchors.centerIn: parent
                    width: parent.width - 2 * GCStyle.baseMargins
                    height: parent.height - GCStyle.baseMargins
                    fontSizeMode: Text.Fit
                    minimumPointSize: 7
                    fontSize: mediumSize
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Guesscount: %1").arg(items.result)
                }
            }
        }

        Column {
            id: col
            spacing: GCStyle.halfMargins
            anchors.top: top.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2
            OperatorRow {
                id: operatorRow
                width: parent.width
                height: Math.min(GCStyle.bigButtonHeight,
                                 parent.height / 6 - GCStyle.halfMargins)
                mode: items.mode
            }
            OperandRow {
                id: operandRow
                width: parent.width
                height: operatorRow.height
            }
            Repeater {
                id: repeat
                model: operatorRow.repeater.model.length
                delegate: OperationRow {
                    id: operationRow
                    width: col.width
                    height: operatorRow.height
                    property alias operationRow: operationRow
                    noOfRows: operatorRow.repeater.model.length
                    rowNo: modelData
                    guesscount: items.result
                    prevText: ""
                    prevComplete: prevText != "" ? true : false
                    reparent: items.clearOperations
                    onTextChanged: {
                        if(index + 1 < repeat.count) {
                            repeat.itemAt(index + 1).prevText = text
                        }
                    }
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
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
                activity.needRestart = true
            }
            onClose: {
                if(Activity.configDone(items.levelArr)){
                    Activity.initLevel()
                    home()
                }
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"]
                    if(activityData["levelArr"] === undefined) {
                        items.levelArr = activityData["levelArr"]

                    }
                    if(activityData["levelArr"]) {
                        items.levelArr = activityData["levelArr"]
                    }
                }
                else {
                    items.mode = "builtin"
                    items.levelArr = Activity.defaultOperators
                }
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: {
                Activity.previousLevel()
            }
            onNextLevelClicked: {
                Activity.nextLevel()
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Rectangle {
            id: warningDialog
            width: Math.min(300 * ApplicationInfo.ratio, col.width)
            height: GCStyle.bigButtonHeight
            visible: false
            color: GCStyle.darkBg
            radius: GCStyle.halfMargins
            border.color: GCStyle.whiteBorder
            border.width: GCStyle.midBorder
            property alias dialogText: dialogText
            anchors.centerIn: col
            GCText {
                id: dialogText
                anchors.centerIn: parent
                fontSize: regularSize
                fontSizeMode: Text.Fit
                color: GCStyle.whiteText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: parent.width - GCStyle.baseMargins * 2
                height: parent.height - GCStyle.baseMargins * 2
                wrapMode: TextEdit.WordWrap
            }
            states: [
                State {
                    when: warningDialog.visible
                    PropertyChanges {
                        top {
                            opacity: 0.5
                        }
                    }
                    PropertyChanges {
                        col {
                            opacity: 0.5
                        }
                    }
                },
                State {
                    when: !warningDialog.visible
                    PropertyChanges {
                        top {
                            opacity: 1
                        }
                    }
                    PropertyChanges {
                        col {
                            opacity: 1
                        }
                    }
                }
            ]
        }
    }
}
