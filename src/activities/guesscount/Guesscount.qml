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
import GCompris 1.0
import "../../core"
import "guesscount.js" as Activity
import "dataset.js" as Data

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    property bool needRestart: true

    pageComponent: Image {
        id: background
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
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property int sublevel: 0
            property alias operatorRow: operatorRow
            property alias operandRow: operandRow
            property var data
            readonly property var levels: activity.datasetLoader.data
            property int result: data[sublevel-1][1]
            property alias timer: timer
            property alias warningDialog: warningDialog
            property GCSfx audioEffects: activity.audioEffects
            property bool solved
            property bool levelchanged: false
            property var levelArr: Data.defaultOperators
            property string mode: "builtin"
            property int currentlevel
            property var resultArr: ["", "", "", ""]
        }

        onStart: if (activity.needRestart) {
                     Activity.start(items);
                     activity.needRestart = false;
                 }
                 else
                     Activity.initLevel();
        onStop: { Activity.stop() }

        JsonParser {
            id: parser
            onError: console.error("Guesscount: Error parsing JSON: " + msg);
        }

        Loader {
            id: admin
            active: false
            sourceComponent: Column {
                spacing: 10
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

        Rectangle {
            id: top
            height: parent.height/10
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 20 * ApplicationInfo.ratio
            }
            color: "transparent"
            Rectangle {
                id: questionNo
                width: parent.width * 0.2
                height: parent.height
                radius: 20
                color: "steelblue"
                anchors.left: parent.left

                GCText {
                    color: "#E8E8E8"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: parent.height
                    fontSizeMode: Text.Fit
                    minimumPointSize: 7
                    fontSize: mediumSize
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("%1/%2").arg(items.sublevel).arg(items.data.length)
                }
            }
            Rectangle {
                id: guessLabel
                width: parent.width * 0.7
                height: parent.height
                radius: 20
                color: "orange"
                anchors {
                    left: questionNo.right
                    leftMargin: 20 * ApplicationInfo.ratio
                }
                Rectangle {
                    id: insideFill
                    width: parent.width - anchors.margins
                    height: parent.height - anchors.margins
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.margins: parent.height/4
                    radius: 10
                    color: "#E8E8E8"
                }
                GCText {
                    id: guess
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: insideFill.width
                    height: insideFill.height
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
            spacing: 10
            anchors.top: top.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: parent.width
            height: parent.height-top.height-background.height/5
            OperatorRow {
                id: operatorRow
                width: parent.width
                height: parent.height/7
                mode: items.mode
            }
            OperandRow {
                id: operandRow
                width: parent.width
                height: parent.height/7
            }
            Repeater {
                id: repeat
                model: operatorRow.repeater.model.length
                delegate: OperationRow {
                    id: operationRow
                    width: col.width
                    height: col.height/7
                    property alias operationRow: operationRow
                    noOfRows: operatorRow.repeater.model.length
                    rowNo: modelData
                    guesscount: items.result
                    prevText: index != 0 ? items.resultArr[index - 1] : ""
                    prevComplete: prevText != "" ? true : false
                    reparent: items.solved || items.levelchanged
                    // This workaround is needed to fix a bug caused by the repeater creating instances from
                    // the last item to the first one but only the very first time it is loaded, so we can't // safely bind values to repeat.itemAt(index-1).property. Using an intermediate array is
                    // the only solution I found. Also changes directly inside the array aren't detected by
                    // the binding, so it needs to be copied to and from another temporary array.
                    onTextChanged: {
                        var tmpResultArr = items.resultArr
                        tmpResultArr[index] = text
                        items.resultArr = tmpResultArr
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
                background.stop()
                background.start()
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
                items.levelchanged = true
                Activity.previousLevel()
            }
            onNextLevelClicked: {
                items.levelchanged = true
                Activity.nextLevel()
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSublevel)
        }
        Timer {
            id: timer
            interval: 1500
            repeat: false
            onTriggered: {
                items.solved = true
            }
        }

        Rectangle {
            id: warningDialog
            width: parent.width*0.49
            height: parent.height/6
            visible: false
            color: "#373737"
            radius: 30
            property alias dialogText: dialogText
            anchors.centerIn: parent
            GCText {
                id: dialogText
                anchors.centerIn: parent
                anchors {
                    centerIn: warningDialog
                }
                opacity: warningDialog.opacity
                z: warningDialog.z
                fontSize: background.vert ? regularSize : smallSize
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: TextEdit.WordWrap
            }
            states: [
                State {
                    when: warningDialog.visible
                    PropertyChanges {
                        target: top
                        opacity: 0.5
                    }
                    PropertyChanges {
                        target: col
                        opacity: 0.5
                    }
                },
                State {
                    when: !warningDialog.visible
                    PropertyChanges {
                        target: top
                        opacity: 1
                    }
                    PropertyChanges {
                        target: col
                        opacity: 1
                    }
                }
            ]
        }
    }
}
