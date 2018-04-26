/* GCompris - question_and_answer.qml
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
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
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

import "../../core"
import "question_and_answer.js" as Activity
import "dataset.js" as Dataset

ActivityBase {
    id: activity
    property var dataset: Dataset
    onStart: focus = true
    onStop: {}
    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/algebra_by/resource/background.svg" //"qrc:/gcompris/src/activities/digital_electricity/resource/texture02.png"
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
            property alias menuScreen: menuScreen
            property alias menuModel: menuScreen.menuModel
            property alias startFinishButton: startFinishButton
            property string currentMode: "freeMode"
            property alias questionsGrid: questionsGrid
            property int noOfQuestions: 9
            property bool levelStarted: false
            property bool showAnswerStatus: false
            property var questions: []
            property var answers: []
        }

        onStart: { Activity.init(items, dataset) }
        onStop: { Activity.stop() }

        Rectangle {
            id: playArea
            width: background.width * 0.95
            height: background.height * 0.90 - bar.height
            border.color: "black"
            border.width: 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 30
            color: "#32000000"
            radius: 20
        }

        GridView {
            id: questionsGrid
            model: items.questions.length
            anchors.top: playArea.top
            anchors.left: playArea.left
            anchors.margins: 50
            width: playArea.width - 200
            height: playArea.height - 200
            cellHeight: height / 3
            cellWidth: background.width > background.height ? width / 3 : width / 2
            property int spacing: 60

            delegate:
                Item {
                GCText {
                    id: questionText
                    text: items.questions[index] + " = "
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    width: questionsGrid.cellWidth / 2.6
                    height: questionsGrid.cellHeight
                }
                TextField {
                    id: answerText
                    height: bar.height * 0.3
                    width: bar.height * 0.9
                    //anchors.margins: 30
                    anchors.left: questionText.right
                    //validator: IntValidator{bottom: 1; top: 200;}
                    activeFocusOnPress: true
                    readOnly: !items.levelStarted
                    onReadOnlyChanged: focus = false
                    horizontalAlignment: TextInput.AlignHCenter
                    onVisibleChanged: text = ""
                    font.pixelSize: 24
                    style: TextFieldStyle {
                        textColor: "black"
                        background: Rectangle {
                            radius: 5
                            color: "transparent"
                            implicitWidth: bar.height * 0.9
                            implicitHeight: 130/800*parent.width
                            border.color: "#333"
                            border.width: 2
                        }
                    }
                }
                Image {
                    id: question_image
                    width: 50
                    height: 50
                    anchors.left: answerText.right
                    anchors.top: questionText.top
                    visible: items.showAnswerStatus
                    fillMode: Image.PreserveAspectFit
                    source: (answerText.text).trim() === items.answers[index] ?
                             "qrc:/gcompris/src/activities/question_and_answer/resource/right.svg" :
                        "qrc:/gcompris/src/activities/photo_hunter/resource/wrong.svg"
                }
            }

        }

        MenuScreen {
            id: menuScreen
        }

        Button {
            id: startFinishButton
            property bool visibility: true
            style: GCButtonStyle { theme: "highContrast" }
            height: bar.height * 0.4
            visible: !menuScreen.visible && visibility
            text: items.levelStarted ? qsTr("Submit") : qsTr("Start")
            onClicked:  {
                if(items.levelStarted) {
                    items.showAnswerStatus = true
                    items.levelStarted = false
                    visibility = false
                }
                else {
                    items.levelStarted = true
                    items.showAnswerStatus = false
                }

                //items.levelStarted = !items.levelStarted
                //Activity.checkAnswer()
                console.log(items.answers)
            }
            anchors.top: playArea.bottom
            anchors.right: restartButton.left
            anchors.margins: 20
        }

        Button {
            id: restartButton
            style: GCButtonStyle { theme: "highContrast"}
            height: bar.height * 0.4
            visible: !menuScreen.visible
            text: qsTr("Restart")
            onClicked:  {
                Activity.nextLevel()
                Activity.previousLevel()
                console.log("   23  ".trim())
                items.showAnswerStatus = false
                startFinishButton.visibility = true
            }
            anchors.top: playArea.bottom
            anchors.right: playArea.right
            anchors.margins: 20
        }

        ExclusiveGroup {
            id: configOptions
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            content: Component {
                Column {
                    spacing: 10
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height

                    GCDialogCheckBox {
                        id: freeMode
                        width: parent.width - 50
                        text: qsTr("Free Mode")
                        checked: items.currentMode === "freeMode" ? true : false
                        //exclusiveGroup: configOptions
                        onCheckedChanged: {
                            if(checked) {
                                items.currentMode = "freeMode"
                                console.log("Free mode selected.")
                            }
                        }
                    }

                    GCDialogCheckBox {
                        id: adminMode
                        width: parent.width - 50
                        text: qsTr("Admin Mode")
                        checked: items.currentMode === "adminMode" ? true : false
                        //exclusiveGroup: configOptions
                        onCheckedChanged: {
                            if(checked) {
                                items.currentMode = "adminMode"
                                console.log("Admin mode selected")
                            }
                        }
                    }
                }
            }
            onClose: home()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            property BarEnumContent activityZoneContent: BarEnumContent { value: home | level }
            property BarEnumContent menuScreenContent: BarEnumContent { value: help | home | config }
            content: menuScreen.started ? menuScreenContent : activityZoneContent
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: {
                if(items.menuScreen.started)
                    activity.home()
                else {
                    Activity.launchMenuScreen()
                }
            }
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
