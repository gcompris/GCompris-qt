/* GCompris - guesscount.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import "../../core"
import "guesscount.js" as Activity

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
            dialogActivityConfig.getInitialConfiguration()
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
            property alias bar: bar
            property alias bonus: bonus
            property int sublevel: 0
            property alias operandRow: operandRow
            property var data
            property int result: data[sublevel-1][1]
            property alias timer: timer
            property alias warningDialog: warningDialog
            property GCSfx audioEffects: activity.audioEffects
            property bool solved
            property bool levelchanged: false
            property var levelArr
            property string mode
            property int currentlevel
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
                    model: Activity.numberOfLevel
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
            width: parent.width
            height: parent.height/10
            anchors {
                top: parent.top
                topMargin: 20
            }
            color: "transparent"
            Rectangle {
                id: questionNo
                width: parent.width*0.2
                height: parent.height
                radius: 20
                color: "steelblue"
                anchors {
                    right: guessLabel.left
                    rightMargin: 20
                }
                GCText {
                    color: "#E8E8E8"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("%1/%2").arg(items.sublevel).arg(items.data.length)
                }
            }
            Rectangle {
                id: guessLabel
                width: parent.width*0.4
                height: parent.height
                radius: 20
                color: "orange"
                anchors {
                    horizontalCenter: parent.horizontalCenter
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
                    fontSize: smallSize
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
                operators: items.levelArr
                level: items.currentlevel
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
                    prevText: modelData ? repeat.itemAt(modelData-1).text : ''
                    prevComplete: modelData ? repeat.itemAt(modelData-1).complete : false
                    reparent: items.solved || items.levelchanged
                }

            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias modeBox: modeBox
                    property var availableModes: [
                        { "text": qsTr("Admin"), "value": "admin" },
                        { "text": qsTr("BuiltIn"), "value": "builtin" }
                    ]
                    Rectangle {
                        id: flow
                        width: dialogActivityConfig.width
                        height: background.height
                        GCComboBox {
                            id: modeBox
                            anchors {
                                top: parent.top
                                topMargin: 5
                            }

                            model: availableModes
                            background: dialogActivityConfig
                            label: qsTr("Select your mode")
                        }
                        Row {
                            id: labels
                            spacing: 20
                            anchors {
                                top: modeBox.bottom
                                topMargin: 5
                            }
                            visible: modeBox.currentIndex == 0
                            Repeater {
                                model: 2
                                Row {
                                    spacing: 10
                                    Rectangle {
                                        id: label
                                        width: background.width*0.3
                                        height: background.height/15
                                        radius: 20.0;
                                        color: modelData ? "green" : "red"
                                        GCText {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSize: smallSize
                                            text: modelData ? qsTr("Selected") : qsTr("Not Selected")
                                        }
                                    }
                                }
                            }
                        }
                        Rectangle {
                            width: parent.width
                            color: "transparent"
                            height: parent.height/1.25-labels.height-modeBox.height
                            anchors {
                                top: labels.bottom
                                topMargin: 5
                            }
                            ListView {
                                anchors.fill: parent
                                visible: modeBox.currentIndex == 0
                                spacing: 5
                                model: Activity.numberOfLevel
                                clip: true
                                delegate: Admin {
                                    id: level
                                    level: modelData
                                    levelOperators: items.levelArr
                                    width: background.width
                                    height: background.height/10
                                }
                            }
                        }
                    }
                }
            }
            onClose: {
                if(Activity.configDone(items.levelArr)){
                    Activity.initLevel()
                    home()
                }
            }
            onLoadData: {
                if(dataToSave && dataToSave["mode"] ) {
                    items.mode = dataToSave["mode"]
                    if(dataToSave["levelArr"] == undefined)
                        dataToSave["levelArr"] = Activity.defaultOperators
                    if(dataToSave["levelArr"].length != Activity.numberOfLevel)
                        items.levelArr = Activity.defaultOperators
                    else
                        items.levelArr = dataToSave["levelArr"]
                }
                else{
                    items.mode='builtin'
                    items.levelArr = Activity.defaultOperators
                }
            }

            onSaveData: {
                items.mode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.modeBox.currentIndex].value
                dataToSave = {"mode": items.mode, "levelArr":items.levelArr}
                activity.needRestart = true
            }


            function setDefaultValues() {
                for(var i = 0 ; i < dialogActivityConfig.configItem.availableModes.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableModes[i].value === items.mode) {
                        dialogActivityConfig.configItem.modeBox.currentIndex = i;
                        break;
                    }
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | config}
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues();
                displayDialog(dialogActivityConfig)
            }
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
            color: "steelblue"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
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
                style: Text.Outline
                styleColor: "black"
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
