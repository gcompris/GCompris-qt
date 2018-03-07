/* GCompris - Solar_system.qml
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *    Aman Kumar Gupta <gupta2140@gmail.com>
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
import "solar_system.js" as Activity

ActivityBase {
    id: activity

    onStart: {
        focus = true;
    }
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/solar_system/resource/background.jpg"

        property bool horizontalLayout: background.width > background.height

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
            property alias containerModel: containerModel
            property alias mainQuizScreen: mainQuizScreen
            property alias dialogActivityConfig: dialogActivityConfig
            property alias restartAssessmentMessage: restartAssessmentMessage
            property bool assessmentMode: false
            property bool solarSystemVisible: true
            property bool quizScreenVisible: false
            property alias hintDialog: hintDialog
        }

        onStart: {
            dialogActivityConfig.getInitialConfiguration()
            Activity.start(items)
        }

        onStop: {
            dialogActivityConfig.saveDatainConfiguration()
            Activity.stop()
        }

        IntroMessage {
            id: message
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 10

            readonly property string commonInstruction: qsTr("Mode: <font color=\"#3bb0de\">%1</font><br>There are two modes in the activity which you can switch from the configuration window:<br><b>1. Normal mode</b> - In this mode you can play and learn about the Solar System.<br><b>2. Assessment mode</b> - In this mode you can test your knowledge about the Solar System.").arg(items.assessmentMode ? "Assessment" : "Normal")

            readonly property var normalModeInstructions: [
                commonInstruction,
                qsTr("Click on the Sun or any planet to reveal questions. Each question will have 4 options, out of which one is correct."),
                qsTr("After a planet is clicked, the Closeness meter at the bottom-right corner of the screen represents the degree of correctness of your selected answer. The least correct answer is represented by 1%. Try again until you reach a 100% closeness by following the closeness meter, or hint which indicates the correct answer.")
            ]

            readonly property var assessmentModeInstructions: [
                commonInstruction,
                qsTr("There are 20 questions initially with 4 options each. The progress bar at the bottom right of the screen shows your percentage score."),
                qsTr("If your answer is correct, your score will increase.<br>If your answer is wrong, your score decreases and one more question will be asked in the end along with the incorrectly answered question.<br>There can be a maximum of 25 questions after which no more question will be added."),
                qsTr("You should score above 90% to pass the assessment and become a Solar System expert!")
            ]

            intro: items.assessmentMode ? assessmentModeInstructions : normalModeInstructions

            onIntroChanged: index = 0
        }

        ListModel {
            id: containerModel
        }

        property int itemWidth: horizontalLayout ? background.width / 9 : (background.height - bar.height) / 9

        //Arrangement of all the planets in the solar system
        GridView {
            id: planetView
            y: horizontalLayout ? (parent.height - bar.height) / 2 - cellHeight/2 : 0
            x: horizontalLayout ? 0 : parent.width / 2 - cellHeight / 2
            layoutDirection: Qt.LeftToRight
            verticalLayoutDirection: GridView.BottomToTop
            width: horizontalLayout ? parent.width : cellWidth
            height: horizontalLayout ? cellHeight : parent.height - bar.height
            clip: false
            interactive: false
            visible: items.solarSystemVisible
            cellWidth: background.itemWidth
            cellHeight: cellWidth
            model: containerModel
            delegate: PlanetInSolarModel {
                planetImageSource: clipImg
                planetName: bodyName
            }
        }

        QuizScreen {
            id: mainQuizScreen
            visible: items.quizScreenVisible
        }

        Rectangle {
            id: restartAssessmentMessage
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.margins: 10 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 4 * ApplicationInfo.ratio
            visible: false
            GCText {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                fontSizeMode: mediumSize
                text: qsTr("Your final score is: <font color=\"#3bb0de\">%1%</font>.<br>You should score above 90% to become a Solar System expert!<br>Retry to test your skills more or train in normal mode to explore more about the Solar System.").arg(items.mainQuizScreen.progressBar.value)
            }

            //To prevent clicking on options under it
            MouseArea {
                anchors.fill: parent
            }

            onVisibleChanged: scaleAnimation.start()

            NumberAnimation {
                id: scaleAnimation
                target: restartAssessmentMessage
                properties: "scale, opacity"
                from: 0
                to: 1
                duration: 1500
                easing.type: Easing.OutBounce
            }
        }

        //Hint dialog while playing the quiz
        DialogBackground {
            id: hintDialog
            visible: false

            property var hint1
            property var hint2

            title: qsTr("Hint")
            content: "%1<br>%2".arg(hint1).arg(hint2)
            onClose: {
                solarSystemImageHint.visible = false
                home()
            }

            button0Text: "View solar system"

            onButton0Hit: solarSystemImageHint.visible = true

            Rectangle {
                id: solarSystemImageHint
                radius: 30
                border.width: 5
                border.color: "black"
                width: parent.width
                height: parent.height
                visible: false

                onVisibleChanged: {
                    if(visible) {
                        hintCloseAnimation.stop()
                        hintAppearAnimation.start()
                    }
                    else {
                        solarSystemImageHint.x = 0
                        solarSystemImageHint.y = 0
                    }
                }

                Image {
                    id: solarSystemImage
                    source: "qrc:/gcompris/src/activities/solar_system/resource/hint_solar_model.png"
                    sourceSize.width: parent.width - 6 * ApplicationInfo.ratio
                    fillMode: Image.PreserveAspectCrop
                    anchors.centerIn: parent
                }

                NumberAnimation {
                    id: hintAppearAnimation
                    target: solarSystemImageHint
                    property: horizontalLayout ? "x" : "y"
                    from: horizontalLayout ? -width : -height
                    to: 0
                    duration: 1200
                    easing.type: Easing.OutBack
                }

                GCButtonCancel {
                    id: cancelButton
                    onClose: hintCloseAnimation.start()
                }

                SequentialAnimation {
                    id: hintCloseAnimation

                    NumberAnimation {
                        target: solarSystemImageHint
                        property: horizontalLayout ? "x" : "y"
                        to: horizontalLayout ? -width : -height
                        duration: 1200
                        easing.type: Easing.InSine
                    }

                    onStopped: solarSystemImageHint.visible = false
                }
            }
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height

                    property alias assessmentModeBox: assessmentModeBox
                    property bool initialCheckStatus

                    GCDialogCheckBox {
                        id: assessmentModeBox
                        width: dialogActivityConfig.width
                        text: qsTr("Assessment mode")
                        checked: items.assessmentMode
                    }
                }
            }

            onLoadData: {
                if(dataToSave && dataToSave["assessmentMode"])
                    items.assessmentMode = dataToSave["assessmentMode"] === "true" ? true : false
                Activity.numberOfLevel = items.assessmentMode ? 1 : 2

            }

            onSaveData: {
                dialogActivityConfig.configItem.initialCheckStatus = items.assessmentMode
                if(dialogActivityConfig.configItem.assessmentModeBox.checked != items.assessmentMode) {
                    items.assessmentMode = !items.assessmentMode
                    dataToSave["assessmentMode"] = items.assessmentMode ? "true" : "false"
                    Activity.numberOfLevel = items.assessmentMode ? 1 : 2
                }
            }

            onClose: {
                if(items.assessmentMode != dialogActivityConfig.configItem.initialCheckStatus) {
                    if(items.assessmentMode)
                        Activity.startAssessmentMode()
                    else {
                        Activity.showSolarModel()
                    }
                }
                home()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: restartAssessmentMessage.visible ? withConfigWithRestart :
                     (items.assessmentMode|| items.solarSystemVisible) ? withConfig :
                     Activity.indexOfSelectedPlanet == 0 ? withoutConfigWithoutHint :
                     withoutConfigWithHint

            property BarEnumContent withConfig: BarEnumContent { value: help | home | config }
            property BarEnumContent withoutConfigWithHint: BarEnumContent { value: help | home | level | hint }
            property BarEnumContent withoutConfigWithoutHint: BarEnumContent { value: help | home | level }
            property BarEnumContent withConfigWithRestart: BarEnumContent { value: help | home | config | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: {
                if(items.solarSystemVisible || items.assessmentMode)
                    activity.home()
                else
                    Activity.showSolarModel()
            }
            onHintClicked: {
                displayDialog(hintDialog)
            }
            onConfigClicked: {
                dialogActivityConfig.active = true
                displayDialog(dialogActivityConfig)
            }
            onReloadClicked: Activity.startAssessmentMode()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
