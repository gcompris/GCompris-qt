/* GCompris - multiplication_tables.qml
*
* Copyright (C) 2016 Nitish Chauhan <nitish.nc18@gmail.com>
*
* Authors:
*
*   Nitish Chauhan <nitish.nc18@gmail.com> (Qt Quick port)
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
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import "../../core"
import "."
import "multiplication_tables.js" as Activity
import "multiplicationtables_dataset.js" as Dataset


ActivityBase {
    id: activity

    property string url: "qrc:/gcompris/src/activities/multiplication_tables/resource/"
    property double startTime: 0
    property bool startButtonClicked: false
    property var dataset: Dataset
    property string mode: "multiplicationtables"


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
            property alias bar: bar
            property alias bonus: bonus
            property string modeType: "normalMode"
            property alias startButton: startButton
            property alias stopButton: stopButton
            property alias time: time
            property alias score: score
            property alias questionGrid: questionGrid
            property alias repeater: repeater

            property alias repeaterModel: repeater.model

            property string isSchoolMode: isSchoolMode
            property var data: Dataset
            property alias keyboard: keyboard

        }

        onStart: {
            Activity.start(items, mode, dataset, url)
        }
        onStop: {
            Activity.stop()
        }

        Flow {
            id: questionGrid
            opacity: 1
            anchors.top: parent.top
            anchors.bottom: startStopButton.top
            spacing: 30/800*parent.width
            anchors {
                left: background.left
                right: background.right
                margins: 50/800*parent.width
            }
            Repeater {
                id: repeater
                model: 10
                Question {
                }
            }
        }

        Image {
            id: player
            source: url + "children.svg"
            anchors {
                bottom: bar.bottom
                right: parent.right
                rightMargin: 120/800*parent.width
            }
            width: 80/800*parent.width
            height: 70/800*parent.width
        }

        GCText {
            id: time
            font.pointSize: 17
            font.bold: true
            color: '#4B6319'
            anchors.bottom: startStopButton.top
            anchors.right: parent.right
            anchors {
                bottomMargin: 15/800*parent.width
                rightMargin: 60/800*parent.width
            }
            text: "--"
            Layout.alignment: Qt.AlignCenter
        }

        GCText {
            id: score
            font.pointSize: 17
            anchors.bottom: startStopButton.top
            anchors.right: time.left
            anchors {
                bottomMargin: 15/800*parent.width
                rightMargin: 15/800*parent.width
            }
            color: "#2c3a0f"
            font.bold: true
            Layout.alignment: Qt.AlignCenter
        }

        Flow{
            id: startStopButton
            anchors.right: parent.right
            anchors.bottom: bar.top
            anchors {
                bottomMargin: 30/800*parent.width
                rightMargin: 60/800*parent.width
            }
            spacing: 25/800*parent.width
            Button {
                id: startButton
                text: qsTr("START")
                width: bar.height * 0.8
                height: bar.height * 0.3
                style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: bar.height * 0.8
                        implicitHeight: bar.height * 0.3
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "blue"
                        radius: 4
                        gradient: Gradient {
                            GradientStop {
                                position: 0;color: control.pressed ? "#729fcf" : "#729fcf"
                            }
                            GradientStop {
                                position: 1;color: control.pressed ? "#3465a4" : "#3465a4"
                            }
                        }
                    }
                }
                onClicked: {
                    if (startTime == 0 && startButtonClicked == false) {

                        if(items.isSchoolMode == "school"){

                            Activity.resetvalue2()
                            Activity.canAnswer2()

                        }
                        else{

                            Activity.resetvalue()
                            Activity.canAnswer()

                        }

                        startButton.text = qsTr("START")
                        time.text = qsTr(" Your Timer Started...")
                        startTime = new Date().getTime()
                        startButtonClicked = true
                    }
                }
            }
            Button {
                id: stopButton
                width: bar.height * 0.8
                height: bar.height * 0.3
                text: qsTr("FINISH")
                style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: bar.height * 0.8
                        implicitHeight: bar.height * 0.3
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "blue"
                        radius: 4
                        gradient: Gradient {
                            GradientStop {
                                position: 0;color: control.pressed ? "#729fcf" : "#729fcf"
                            }
                            GradientStop {
                                position: 1;color: control.pressed ? "#3465a4" : "#3465a4"
                            }
                        }
                    }
                }

                onClicked: {
                    if (startButtonClicked == true) {
                        score.visible = true
                        var str1 = (new Date().getTime() - startTime)/1000
                        time.text = qsTr("Your time:- %1 seconds").arg(str1)
                        startTime = 0
                        startButtonClicked = false
                        startButton.text = qsTr("START AGAIN")

                        if(items.isSchoolMode == "school"){

                            Activity.verifyAnswer2()
                            Activity.cannotAnswer2()
                        }
                        else{

                            Activity.verifyAnswer()
                            Activity.cannotAnswer()
                        }


                    }
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
                            property alias repeater2: repeater2
                            property var availableModes: [
                                { "text": qsTr("School mode"), "value": "admin" },
                                { "text": qsTr("Normal mode"), "value": "builtin" }
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
                                }

                                Rectangle {
                                    id : adminquestion
                                    width: parent.width
                                    color: "transparent"
                                    height: parent.height/1.25-labels.height-modeBox.height
                                    anchors {
                                        top: labels.bottom
                                        topMargin: 5
                                    }

                                    Grid {
                                        spacing : 30
                                        columns: 10
                                        Repeater {
                                            id: repeater2
                                            model: Activity.allQuestions
                                            Admin {
                                                visible: modeBox.currentIndex == 0
                                            }
                                        }
                                       }
                                    }
                                }
                            }
                        }

                    onClose: {
                        Activity.initLevel()
                        home()
                    }


                    onLoadData: {
                    }

                    onSaveData: {

                        var j1 = 0
                        for (var i = 0; i < Activity.allQuestions.length; i++) {
                                if(dialogActivityConfig.configItem.repeater2.itemAt(i).questionChecked === true){
                                   Activity.selectedQuestions[j1] = dialogActivityConfig.configItem.repeater2.itemAt(i).selectedQuestionText
                                   Activity.selectedAnswers[j1] = Activity.allAnswers[i]
                                   j1 = j1 + 1

                                }
                            }

                      Activity.loadSchoolMode()
                      items.isSchoolMode = "school"
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
            content: BarEnumContent {
                value: help | home | level | config
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.reloadRandom()
            onConfigClicked: {
                dialogActivityConfig.active = true
                displayDialog(dialogActivityConfig)
            }
        }

        VirtualKeyboard {
                  id: keyboard
                  anchors.bottom: parent.bottom
                  anchors.horizontalCenter: parent.horizontalCenter
                  width: parent.width
                  onKeypress: Activity.processKeyPress(text)
                  onError: console.log("VirtualKeyboard error: " + msg);
              }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
