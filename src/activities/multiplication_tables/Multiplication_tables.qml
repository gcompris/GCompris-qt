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
            property string mode2: "normalMode"
            property alias start_button: start_button
            property alias stop_button: stop_button
            property alias time: time
            property alias score: score
            property alias questionGrid: questionGrid
            property alias repeater: repeater
        }

        onStart: {
            Activity.start(items, mode, dataset, url)
        }
        onStop: {
            Activity.stop()
        }

        Flow {
            id: questionGrid
            anchors.fill: parent
            anchors.bottom: bar.top
            spacing: bar.height * 0.4
            anchors {
                left: background.left
                right: background.right
                margins: bar.height * 0.6
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
            }
            width: height * 0.83
            height: bar.height * 1.2
        }

        GCText {
            id: score
            font.pointSize: 20
            color: "#4B6319"
            font.bold: true
            anchors.bottom: time.top
            anchors.right: parent.right
            anchors {
                bottomMargin: bar.height * 0.09
                rightMargin: bar.height * 1.8
            }
            Layout.alignment: Qt.AlignCenter
        }

        GCText {
            id: time
            font.pixelSize: 23
            font.bold: true
            color: '#4B6319'
            anchors.bottom: start_stop_buttons.top
            anchors.right: parent.right
            anchors {
                bottomMargin: bar.height * 0.3
                rightMargin: bar.height * 1.3
            }
            text: "--"
            Layout.alignment: Qt.AlignCenter
        }

        Flow{
            id: start_stop_buttons
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors {
                bottomMargin: bar.height * 0.4
                rightMargin: bar.height * 1.5
            }

            Button {
                id: start_button
                text: qsTr("START")
                style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: bar.height * 0.9
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
                        Activity.resetvalue()
                        Activity.canAnswer()
                        start_button.text = qsTr("START")
                        time.text = qsTr(" Your Timer Started...")
                        startTime = new Date().getTime()
                        startButtonClicked = true
                    }
                }
            }

            Button {
                id: stop_button
                text: qsTr("FINISH")
                style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: bar.height * 0.9
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
                        start_button.text = qsTr("START AGAIN")
                        Activity.verifyAnswer()
                        Activity.cannotAnswer()
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
            content: Component {
                Column {
                    id: column
                    spacing: 5
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height
                    property alias normalMode: normalMode
                    property alias schoolMode: schoolMode

                    GCDialogCheckBox {
                        id: normalMode
                        width: column.width - 50
                        text: qsTr("Normal mode")
                        checked: (items.mode2 == "normalMode") ? true : false
                        onCheckedChanged: {
                            if(normalMode.checked) {
                                items.mode2 = "normalMode"
                            }
                        }
                    }
                    GCDialogCheckBox {
                        id: schoolMode
                        width: normalMode.width
                        text: qsTr("School mode")
                        checked: (items.mode2 == "schoolMode") ? true : false
                        onCheckedChanged: {
                            if(schoolMode.checked) {
                                items.mode2 = "schoolMode"
                            }
                        }
                    }
                }
            }
            onLoadData: {
                if(dataToSave && dataToSave["mode2"])
                items.mode = dataToSave["mode2"]
                if(dataToSave && dataToSave["displayUpdateDialogAtStart"])
                items.displayUpdateDialogAtStart = (dataToSave["displayUpdateDialogAtStart"] == "true") ? true : false
            }
            onSaveData: {
                dataToSave["mode2"] = items.mode2
                dataToSave["displayUpdateDialogAtStart"] = items.displayUpdateDialogAtStart ? "true" : "false"
            }
            onClose: home()
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

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
