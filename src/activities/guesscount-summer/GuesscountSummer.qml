/* GCompris - guesscount-summer.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1

import "../../core"
import "guesscount-summer.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    property bool needRestart: true

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop
        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
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
            property int sublevel: 0
            property alias operandRow : operandRow
            property  var data
            property int result: data[sublevel-1][1]
            property alias timer: timer
            property alias dialog: dialog
            property GCAudio audioEffects: activity.audioEffects
            property bool solved
            property bool levelchanged : false
            property alias parser: parser
            property var levelArr
            property alias load: dialogActivityConfig
            property alias operators: items.levelArr
            property string mode
            property int currentlevel
        }

        onStart:  if (activity.needRestart) {
                      Activity.start(items);
                      activity.needRestart = false;
                  } else
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

                Repeater{
                    id:levels
                    model: Activity.numberOfLevel
                    Admin{
                        id:level
                        level: modelData+1
                        width: parent.width
                        height: parent.height
                    }
                }
            }
        }

        Rectangle {
            id: row1
            width: parent.width
            height: parent.height/10
            anchors{
                top: parent.top
                topMargin: (parent.height/80)*3
            }
            color: "transparent"
            Rectangle {
                id: questionNo
                width: parent.width*0.328;
                height: parent.height;
                radius: 20.0;
                color: "steelblue"
                anchors{
                    left: parent.left
                    leftMargin: parent.width*0.028
                }
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("%1/%2").arg(items.sublevel).arg(items.data.length)
                }
            }
            Rectangle{
                width: parent.width*0.35;
                height: parent.height;
                radius: 20
                color: "orange"
                anchors{
                    right: parent.right
                    rightMargin: parent.width*0.028
                }
                GCText{
                    id: guess
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("Guesscount: %1").arg(items.result)
                }
            }
        }

        Column {
            spacing: 10
            anchors.top:row1.bottom
            anchors.topMargin: 10
            width: parent.width
            height: parent.height
            OperatorRow {
                width: parent.width
                height: parent.height/10
                mode: items.mode
                operators: items.operators
                level: items.currentlevel
            }
            OperandRow {
                id: operandRow
                width: parent.width
                height: parent.height/10
            }
            Repeater {
                id: repeat
                model: items.operandRow.repeater.model.length-1
                delegate: OperationRow{
                    id: operationRow
                    width: background.width
                    height: background.height/10
                    property alias operationRow: operationRow
                    noOfRows: items.operandRow.repeater.model.length-1
                    rowNo: modelData
                    guesscount: items.result
                    prevResult: modelData ? repeat.itemAt(modelData-1).rowResult : -1
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

                    Flow {
                        id: flow
                        spacing: 5
                        width: dialogActivityConfig.width
                        GCComboBox {
                            id: modeBox
                            model: availableModes
                            background: dialogActivityConfig
                            label: qsTr("Select your mode")
                        }
                        Row{
                            id: labels
                            spacing: 20
                            Repeater{
                                model: 2
                                Row {
                                    spacing: 10
                                    Rectangle {
                                        id: box
                                        width: 20
                                        height: 20
                                        color: modelData==0 ? "red" : "green"
                                    }
                                    GCText{
                                        fontSize: mediumSize
                                        text: modelData==0 ? qsTr("NotSelected") : qsTr("Selected")
                                    }
                                }
                            }
                        }
                        Rectangle{
                            width: parent.width
                            color: "transparent"
                            height: background.height/1.5
                            ListView {
                                anchors.fill: parent
                                visible: modeBox.currentIndex==0
                                spacing: 10
                                model: Activity.dataset.length
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
            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["mode"] ) {
                    items.mode = dataToSave["mode"]
                    if(dataToSave["levelArr"]==undefined)
                        dataToSave["levelArr"]=[]
                    console.log("loaded data :"+ dataToSave['levelArr'])
                    if(dataToSave["levelArr"].length!=Activity.dataset.length)
                        items.levelArr=Activity.add_empty_array(dataToSave["levelArr"],Activity.dataset.length)
                    else
                        items.levelArr = dataToSave["levelArr"]
                }
            }

            onSaveData: {
                items.mode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.modeBox.currentIndex].value;
                console.log("saving data:  "+items.levelArr)
                dataToSave = {"mode": items.mode,"levelArr":items.levelArr}
                activity.needRestart=true
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
                items.levelchanged=true
                Activity.previousLevel()
            }
            onNextLevelClicked: {
                items.levelchanged=true
                Activity.nextLevel()
            }
            onHomeClicked: activity.home()

        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
        Timer {
            id: timer
            interval: 1500
            repeat: false
            onTriggered: {
                items.solved=true
                if(items.sublevel<items.data.length)
                {
                    Activity.next_sublevel()
                }
            }
        }
        Rectangle {
            id: dialog
            width: parent.width*0.49
            height: parent.height/8
            visible: false
            color: "steelblue"
            radius: 30
            anchors.centerIn: parent
            GCText{
                anchors.centerIn: parent
                fontSize: mediumSize
                text: qsTr("result is not an integer")
            }
            onVisibleChanged:SequentialAnimation{
                PropertyAnimation { target: dialog; property: "opacity";from : 1 ; to: 0 ;duration: 3000 }
                PropertyAnimation { target: dialog; property: "visible";to: false }
            }
        }
    }
}
