/* GCompris - Solar_system.qml
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
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
                qsTr("After a planet is clicked, the Closeness meter at the bottom-right corner of the screen represents the degree of correctness of your selected answer. Try again until you reach a 100% closeness by following the closeness meter, which indicates the correct answer.")
            ]
        }

        ListModel {
            id: containerModel
        }

        property int itemWidth: horizontalLayout ? background.width / 9 : (background.height - bar.height) / 9

        GridView{
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
                nameOfPlanet: bodyName
            }
        }

        QuizScreen {
            id: mainQuizScreen
            visible: items.quizScreenVisible
        }

        Rectangle {
            id: hintBoard
            radius: 30
            border.width: 5
            border.color: "black"
            width: parent.width
            height: parent.height
            visible: false
            z: 3

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

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height

                    GCDialogCheckBox {
                        id: assessmentModeBox
                        width: dialogActivityConfig.width
                        text: qsTr("No closeness meter and no hint")
                        checked: background.assessmentMode
                        onCheckedChanged: {
                                background.assessmentMode = checked
                        }
                    }
                }
            }

            onLoadData: {
                if(dataToSave && dataToSave["assessmentMode"])
                    background.assessmentMode = dataToSave["assessmentMode"] === "true" ? true : false
            }

            onSaveData: {
                dataToSave["assessmentMode"] = background.assessmentMode ? "true" : "false"
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
            content: items.solarSystemVisible ? withConfig : background.assessmentMode ? withoutConfigWithoutHint : withoutConfigWithHint
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
                hintBoard.visible = true
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
