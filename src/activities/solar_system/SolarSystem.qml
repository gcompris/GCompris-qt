/* GCompris - SolarSystem.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *    Aman Kumar Gupta <gupta2140@gmail.com>
 *    Timothée Giet <animtim@gmail.com> (graphics, layout and keyboard controls)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "solar_system.js" as Activity

ActivityBase {
    id: activity

    onStart: {
        focus = true;
    }
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        property bool horizontalLayout: background.width >= background.height

        Image {
            id: stars
            fillMode: Image.PreserveAspectCrop
            source: "qrc:/gcompris/src/activities/solar_system/resource/background.svg"
            width: horizontalLayout ? parent.width * 2.5 : parent.height * 2.5
            height: stars.width
            sourceSize.width: stars.width
            sourceSize.height: stars.width

            transform: Rotation {
                origin.x: stars.width / 2; origin.y: stars.height / 2; angle: 0;
                    NumberAnimation on angle{
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 108000
                }
            }
        }

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bar: bar
            property alias bonus: bonus
            property alias planetsModel: planetsModel
            property alias mainQuizScreen: mainQuizScreen
            property alias dialogActivityConfig: dialogActivityConfig
            property string mode: "learning"
            property bool assessmentMode: mode === "assessment" ? true : false
            property bool solarSystemVisible: true
            property bool quizScreenVisible: false
            property string temperatureHint
            property string lengthOfYearHint
            property bool hintProvided: true
        }

        onStart: Activity.start(items)
        onStop: Activity.stop()

        property bool keyboardMode: false

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: message

        Keys.onPressed: {
            if(!mainQuizScreen.visible) {
                if(event.key === Qt.Key_Down) {
                    planetView.moveCurrentIndexDown();
                } else if(event.key === Qt.Key_Right) {
                    planetView.moveCurrentIndexRight();
                } else if(event.key === Qt.Key_Up) {
                    planetView.moveCurrentIndexUp();
                } else if(event.key === Qt.Key_Left) {
                    planetView.moveCurrentIndexLeft();
                } else if((event.key === Qt.Key_Enter || event.key === Qt.Key_Space || event.key === Qt.Key_Return) && planetView.currentIndex !== -1) {
                    Activity.showQuizScreen(planetView.currentIndex);
                }
            } else {
                if(mainQuizScreen.blockAnswerButtons) {
                    return;
                }
                if(event.key === Qt.Key_Down || event.key === Qt.Key_Right) {
                    if(mainQuizScreen.optionListView.currentIndex <
                        mainQuizScreen.optionListView.count - 1) {
                         mainQuizScreen.optionListView.currentIndex += 1;
                    } else {
                        mainQuizScreen.optionListView.currentIndex = 0;
                    }
                } else if(event.key === Qt.Key_Up || event.key === Qt.Key_Left) {
                    if(mainQuizScreen.optionListView.currentIndex > 0) {
                         mainQuizScreen.optionListView.currentIndex -= 1;
                    } else {
                        mainQuizScreen.optionListView.currentIndex =
                        mainQuizScreen.optionListView.count - 1;
                    }
                } else if((event.key === Qt.Key_Enter || event.key === Qt.Key_Space || event.key === Qt.Key_Return) && mainQuizScreen.optionListView.currentIndex !== -1) {
                    mainQuizScreen.optionListView.currentItem.pressed();
                }
            }
        }

        Keys.onTabPressed: {
            if(items.hintProvided) {
                if(items.assessmentMode)
                    solarSystemImageHint.visible = true;
                else
                    displayDialog(hintDialog);
            }
        }


        Keys.onEscapePressed: {
            mainQuizScreen.closenessMeter.stopAnimations();
            if(items.solarSystemVisible || (items.assessmentMode && !solarSystemImageHint.visible))
                activity.home();
            else if(solarSystemImageHint.visible)
                solarSystemImageHint.visible = false
            else
                Activity.showSolarModel();
        }

        Keys.onReleased: {
            keyboardMode = true
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

            readonly property string commonInstruction: qsTr("Mode: <font color=\"#3bb0de\">%1</font><br><br>There are two modes in the activity which you can switch from the configuration window:<br><b>1. Learning mode</b> - In this mode you can play and learn about the Solar System.<br><b>2. Assessment mode</b> - In this mode you can test your knowledge about the Solar System.").arg(items.assessmentMode ? qsTr("Assessment") : qsTr("Learning"))

            readonly property var learningModeInstructions: [
                commonInstruction,
                qsTr("Click on the Sun or any planet to reveal questions. Each question has 4 options, out of which one is correct."),
                qsTr("After a planet is clicked, the Closeness meter at the bottom-right corner of the screen represents the degree of correctness of your selected answer. The least correct answer is represented by 1%. Try again until you reach a 100% closeness by following the closeness meter. If the hint button is visible, you can click on it to get a hint to find the answer.")
            ]

            readonly property var assessmentModeInstructions: [
                commonInstruction,
                qsTr("There are 20 questions initially with 4 options each. The progress bar at the bottom right of the screen shows your percentage score."),
                qsTr("If your answer is correct, your score increases.<br>If your answer is wrong, your score decreases and one more question will be asked in the end along with the incorrectly answered question.<br>A maximum of 25 questions will be asked after which no more question will be added."),
                qsTr("You should score above 90% to pass the assessment and become a Solar System expert!")
            ]

            intro: items.assessmentMode ? assessmentModeInstructions : learningModeInstructions

            onIntroChanged: index = 0
        }

        ListModel {
            id: planetsModel
        }

        readonly property int itemWidth: horizontalLayout ? background.width * 0.11 : (background.height - bar.height * 1.5) * 0.11

        // Arrangement of all the planets in the solar system
        GridView {
            id: planetView
            layoutDirection: Qt.LeftToRight
            verticalLayoutDirection: GridView.BottomToTop
            clip: false
            interactive: false
            visible: items.solarSystemVisible
            cellWidth: background.itemWidth
            cellHeight: cellWidth
            model: planetsModel
            keyNavigationWraps: true
            currentIndex: -1
            highlight: Rectangle {
                scale: 1.2
                color:  "#80FFFFFF"
                visible: background.keyboardMode
                radius: 10 * ApplicationInfo.ratio
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }

            delegate: PlanetInSolarModel {
                planetImageSource: realImg
                planetName: bodyName
                planetSize: bodySize
            }
        }
        states: [
            State {
                name: "hGrid"
                when: background.horizontalLayout
                AnchorChanges {
                    target: planetView
                    anchors.horizontalCenter: background.horizontalCenter
                    anchors.verticalCenter: background.verticalCenter
                    anchors.top: undefined
                }
                PropertyChanges {
                    target: planetView
                    width: background.width
                    height: cellHeight

                }
                PropertyChanges {
                    target: stars
                    x: -stars.width * 0.48
                    y: -stars.height * 0.5 + background.height * 0.5
                }
            },
            State {
                name: "vGrid"
                when: !background.horizontalLayout
                AnchorChanges {
                    target: planetView
                    anchors.horizontalCenter: background.horizontalCenter
                    anchors.verticalCenter: undefined
                    anchors.top: background.top
                }
                PropertyChanges {
                    target: planetView
                    width: cellWidth
                    height: background.height - bar.height * 1.5
                }
                PropertyChanges {
                    target: stars
                    x: -stars.width * 0.5 + background.width * 0.5
                    y: -stars.height * 0.5 + background.height * 0.9
                }
            }
        ]

        QuizScreen {
            id: mainQuizScreen
            visible: items.quizScreenVisible
        }

        Rectangle {
            id: solarSystemImageHint
            radius: 30
            border.width: 5
            border.color: "black"
            width: parent.width
            height: parent.height
            visible: false
            z: 2000
            parent: items.assessmentMode ? background : hintDialog

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
                fillMode: Image.PreserveAspectCrop
                source: "qrc:/gcompris/src/activities/solar_system/resource/background.svg"
                width: horizontalLayout ? parent.width * 2.5 : parent.height * 2.5
                height: stars.width
                sourceSize.width: stars.width
                sourceSize.height: stars.width
                x: horizontalLayout ? -stars.width * 0.48 : -stars.width * 0.5 + parent.width * 0.5
                y: horizontalLayout ? -stars.height * 0.5 + parent.height * 0.5 : -stars.height * 0.5 + parent.height * 0.9
            }

            GridView {
                id: planetViewHint
                y: horizontalLayout ? (parent.height - bar.height) / 2 - cellHeight/2 : 0
                x: horizontalLayout ? 0 : parent.width / 2 - cellHeight / 2
                layoutDirection: Qt.LeftToRight
                verticalLayoutDirection: GridView.BottomToTop
                width: horizontalLayout ? parent.width : cellWidth
                height: horizontalLayout ? cellHeight : parent.height - bar.height
                clip: false
                interactive: false
                cellWidth: background.itemWidth
                cellHeight: cellWidth
                model: items.planetsModel

                delegate: PlanetInSolarModel {
                    hintMode: true
                    planetImageSource: realImg
                    planetName: bodyName
                    planetSize: bodySize
                }
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

        // Hint dialog while playing the quiz
        DialogBackground {
            id: hintDialog
            visible: false

            readonly property string hint1: qsTr("1. The <b>farther</b> a planet from the Sun, the <b>lower</b> is its temperature.<br><font color=\"#3bb0de\">%1</font>").arg(items.temperatureHint)
            readonly property string hint2: qsTr("2. The duration of a year on a planet <b>increases as we go away from the Sun</b>.<br><font color=\"#3bb0de\">%1</font>").arg(items.lengthOfYearHint)
            //: find an equivalent rhyme in your language where the first letter of each word corresponds to the first letter of the planet in proper sequence
            //~ try to make the rhyme as simple as possible
            readonly property string hint3: qsTr("3. Always remember this rhyme to learn the position of planets, examine the first letter in each word - <b>M</b>y <b>V</b>ery <b>E</b>xcellent <b>M</b>other <b>J</b>ust <b>S</b>erved <b>U</b>s <b>N</b>oodles.<br>")

            title: qsTr("Hint")
            content: "%1<br>%2<br>%3".arg(hint1).arg(hint2).arg(hint3)
            onClose: {
                solarSystemImageHint.visible = false
                home()
                activity.forceActiveFocus()
            }

            button0Text: qsTr("View the solar system")

            onButton0Hit: solarSystemImageHint.visible = true
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                if(items.assessmentMode) {
                    Activity.startAssessmentMode()
                }
                else {
                    Activity.showSolarModel()
                }
                home();
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
                Activity.numberOfLevel = items.assessmentMode ? 1 : 2
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: items.mainQuizScreen.restartAssessmentMessage.visible ? withConfigWithRestart :
                     items.solarSystemVisible ? withConfig :
                     items.assessmentMode ? withConfigWithHint :
                     Activity.indexOfSelectedPlanet == 0 ? withoutConfigWithoutHint :
                     items.hintProvided ? withoutConfigWithHint :
                     withoutConfigWithoutHint

            property BarEnumContent withConfig: BarEnumContent { value: help | home | activityConfig }
            property BarEnumContent withoutConfigWithHint: BarEnumContent { value: help | home | level | hint }
            property BarEnumContent withoutConfigWithoutHint: BarEnumContent { value: help | home | level }
            property BarEnumContent withConfigWithRestart: BarEnumContent { value: help | home | activityConfig | reload }
            property BarEnumContent withConfigWithHint: BarEnumContent { value: help | home | activityConfig | hint }

            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: {
                mainQuizScreen.closenessMeter.stopAnimations();
                if(items.solarSystemVisible || items.assessmentMode) {
                    home();
                }
                else
                    Activity.showSolarModel();
            }
            onHintClicked: {
                if(items.assessmentMode)
                    solarSystemImageHint.visible = true
                else
                    displayDialog(hintDialog)
            }
            onActivityConfigClicked: {
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
