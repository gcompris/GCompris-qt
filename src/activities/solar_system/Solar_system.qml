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
        property bool assessmentMode: false

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
            property bool solarSystemVisible
            property bool quizScreenVisible
            property alias dialogActivityConfig: dialogActivityConfig
            property bool assessmentMode: assessmentMode
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
            z: 100
            intro: [
                qsTr("Click on the Sun or any planet to reveal questions. Each question will have 4 options, out of which one is correct."),
                qsTr("After a planet is clicked, the Closeness meter at the bottom-right corner of the screen represents the degree of correctness of your selected answer. The least correct answer is represented by 1%. Try again until you reach a 100% closeness by following the closeness meter, which indicates the correct answer.")
            ]
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
            visible: false
            opacity: items.quizScreenVisible
            onOpacityChanged: {
                if(items.quizScreenVisible)
                    quizScreenAppearAnimation.start()
                else
                    quizScreenDisappearAnimation.start()
            }

            SequentialAnimation {
                id: quizScreenAppearAnimation

                PropertyAnimation {
                    target: mainQuizScreen
                    property: "visible"
                    to: true
                    duration: 0
                }

                NumberAnimation {
                    target: mainQuizScreen
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }

            SequentialAnimation {
                id: quizScreenDisappearAnimation

                NumberAnimation {
                    target: mainQuizScreen
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }

                PropertyAnimation {
                    target: mainQuizScreen
                    property: "visible"
                    to: false
                    duration: 0
                }
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
            onClose: home()
            Rectangle {
                id: button
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height/1.5
                implicitWidth: Math.max(200, parent.width/6)
                implicitHeight: 50 * ApplicationInfo.ratio
                border.width: 2
                border.color: "#373737"
                radius: 10
                gradient: Gradient {
                    GradientStop { position: 0 ; color: mouseArea.pressed ? "#C03ACAFF" : "#23373737" }
                    GradientStop { position: 1 ; color: mouseArea.pressed ? "#803ACAFF" : "#13373737" }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: hintBoard.visible = true
                }

                GCText {
                    anchors.fill: parent
                    text: "Visit Solar System"
                    fontSizeMode: Text.Fit
                    fontSize: smallSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: hintBoard
                radius: 30
                border.width: 5
                border.color: "black"
                width: parent.width
                height: parent.height
                visible: false

                onVisibleChanged: hintAppearAnimation.start()

                Image {
                    id: hintSolarModel
                    source: "qrc:/gcompris/src/activities/solar_system/resource/hint_solar_model.png"
                    sourceSize.width: parent.width - 6 * ApplicationInfo.ratio
                    fillMode: Image.PreserveAspectCrop
                    anchors.centerIn: parent
                }

                NumberAnimation {
                    id: hintAppearAnimation
                    target: hintBoard
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
                        target: hintBoard
                        property: horizontalLayout ? "x" : "y"
                        to: horizontalLayout ? -width : -height
                        duration: 1200
                        easing.type: Easing.InSine
                    }

                    PropertyAnimation {
                        id: switchDescriptionPanelInvisible
                        target: hintBoard
                        property: "visible"
                        to: false
                    }
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

                    GCDialogCheckBox {
                        id: assessmentModeBox
                        width: dialogActivityConfig.width
                        text: qsTr("No closeness meter and no hint")
                        checked: background.assessmentMode
                    }
                }
            }

            onLoadData: {
                if(dataToSave && dataToSave["assessmentMode"])
                    background.assessmentMode = dataToSave["assessmentMode"] === "true" ? true : false
                Activity.numberOfLevel = background.assessmentMode ? 1 : 2
            }

            onSaveData: {
                if(dialogActivityConfig.configItem.assessmentModeBox.checked != background.assessmentMode) {
                    background.assessmentMode = !background.assessmentMode
                    dataToSave["assessmentMode"] = background.assessmentMode ? "true" : "false"
                    Activity.numberOfLevel = background.assessmentMode ? 1 : 2
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
            z: 2
            content: items.solarSystemVisible ? withConfig : background.assessmentMode || Activity.indexOfSelectedPlanet ===0 ? withoutConfigWithoutHint : withoutConfigWithHint
            property BarEnumContent withConfig: BarEnumContent { value: help | home | config }
            property BarEnumContent withoutConfigWithoutHint: BarEnumContent { value: help | home | level }
            property BarEnumContent withoutConfigWithHint: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: {
                if(items.solarSystemVisible)
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
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
