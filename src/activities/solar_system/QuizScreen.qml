/* GCompris - QuizScreen.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12

import "../../core"
import "solar_system.js" as Activity

Item {
    id: mainQuizScreen
    width: parent.width
    height: parent.height

    property alias score: score
    property alias optionListModel: optionListModel
    property alias optionListView: optionListView
    property alias restartAssessmentMessage: restartAssessmentMessage
    property alias blockAnswerButtons: optionListView.blockAnswerButtons
    property alias closenessMeter: closenessMeter
    property string planetRealImage
    property string question
    property string closenessMeterValue
    property int numberOfCorrectAnswers: 0

    Rectangle {
        id: questionArea
        anchors.right: score.left
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10 * ApplicationInfo.ratio
        height: questionText.height + 10 * ApplicationInfo.ratio
        color: 'white'
        radius: 10
        border.width: 3
        opacity: 0.8
        border.color: "black"
        GCText {
            id: questionText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent.Center
            color: "black"
            width: parent.width
            wrapMode: Text.Wrap
            text: mainQuizScreen.question
        }
    }

    // Model of options for a question
    ListModel {
        id: optionListModel
    }

    // This grid has image of the planet in its first column/row (row in case of vertical screen) and the options on the 2nd column/row
    Grid {
        id: imageAndOptionGrid
        columns: (background.horizontalLayout && !items.assessmentMode && items.currentLevel != 1) ? 2 : 1
        spacing: 10 * ApplicationInfo.ratio
        anchors.top: (questionArea.y + questionArea.height) > (score.y + score.height) ? questionArea.bottom : score.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        // An item to hold image of the planet
        Item {
            width: background.horizontalLayout ? background.width * 0.40
                                               : background.width - imageAndOptionGrid.anchors.margins * 2
            height: background.horizontalLayout ? background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio
                                                : (background.height - bar.height - questionArea.height - 10 * ApplicationInfo.ratio) * 0.37

            visible: !items.assessmentMode && (items.currentLevel != 1)

            Image {
                id: planetImageMain
                sourceSize.width: Math.min(parent.width, parent.height) * 0.9
                anchors.centerIn: parent
                source: mainQuizScreen.planetRealImage
                fillMode: Image.PreserveAspectCrop
            }
        }

        // An item to hold the list view of options
        Item {
            width: ( items.assessmentMode || items.currentLevel == 1 ) ? mainQuizScreen.width
                                                                    : background.horizontalLayout ? background.width * 0.55
                                                                                                  : background.width - imageAndOptionGrid.anchors.margins * 2
            height: background.horizontalLayout ? itemHeightHorizontal
                                                : itemHeightVertical

            readonly property real itemHeightHorizontal: background.height - bar.height - closenessMeter.height - questionArea.height - 10 * ApplicationInfo.ratio
            readonly property real itemHeightVertical: (items.bcurrentLevel != 1 && !items.assessmentMode) ? itemHeightHorizontal * 0.39
                                                                                                       : itemHeightHorizontal * 0.8

            ListView {
                id: optionListView
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: background.horizontalLayout ? background.width * 0.40
                                                   : background.width - imageAndOptionGrid.anchors.margins * 2
                height: background.horizontalLayout ? background.height - bar.height - closenessMeter.height * 1.5 - questionArea.height - 50 * ApplicationInfo.ratio
                                                    : parent.itemHeightVertical
                spacing: background.horizontalLayout ? 10 * ApplicationInfo.ratio : 7.5 * ApplicationInfo.ratio
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
                model: optionListModel
                currentIndex: -1

                readonly property real buttonHeight: (height - 3 * spacing) / 4

                add: Transition {
                    NumberAnimation { properties: "y"; from: parent.y; duration: 500 }
                    onRunningChanged: {
                        optionListView.blockAnswerButtons = running
                    }
                }

                property bool blockAnswerButtons: false

                highlight: Rectangle {
                    scale: 1.2
                    color:  "#2881C3"
                    visible: background.keyboardMode
                    radius: 10 * ApplicationInfo.ratio
                    Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                    Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
                }

                delegate: AnswerButton {
                    id: optionButton
                    width: optionListView.width
                    height: optionListView.buttonHeight
                    textLabel: optionValue
                    blockAllButtonClicks: optionListView.blockAnswerButtons

                    isCorrectAnswer: closeness === 100

                    onPressed: optionListView.blockAnswerButtons = true
                    onIncorrectlyPressed: {
                        if(!items.assessmentMode) {
                            closenessMeter.stopAnimations()
                            closenessMeterIncorrectAnswerAnimation.start()
                            mainQuizScreen.closenessMeterValue = closeness
                        }
                        else {
                            optionListView.blockAnswerButtons = false
                            Activity.appendAndAddQuestion()
                        }
                    }
                    onCorrectlyPressed: {
                        if(!items.assessmentMode) {
                            closenessMeter.stopAnimations()
                            particles.burst(30)
                            closenessMeterCorrectAnswerAnimation.start()
                            mainQuizScreen.closenessMeterValue = closeness
                        }
                        else {
                            Activity.assessmentModeQuestions.shift()
                            mainQuizScreen.numberOfCorrectAnswers++
                            Activity.nextSubLevel(true)
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: closenessMeter
        x: ((background.width - items.bar.barZoom * items.bar.fullButton * 5.6) < (width + 10 * ApplicationInfo.ratio) && background.horizontalLayout) ? background.width - width - 42 * ApplicationInfo.ratio : background.width - width - 10 * ApplicationInfo.ratio
        y: (background.width - items.bar.barZoom * items.bar.fullButton * 5.6) < (width + 10 * ApplicationInfo.ratio) ? background.height - bar.height - height - 10 * ApplicationInfo.ratio : background.height - height  - 10 * ApplicationInfo.ratio
        height: 40 * ApplicationInfo.ratio
        width: 150 * ApplicationInfo.ratio
        radius: width * 0.06
        border.width: 2
        border.color: "black"
        opacity: 0.78
        visible: !items.assessmentMode
        Item {
            width: parent.width - 3 * ApplicationInfo.ratio
            height: parent.height
            anchors.centerIn: parent

            GCText {
                id: closenessText
                color: "black"
                anchors.fill: parent
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Accuracy: %1%").arg(closenessMeterValue)
            }
        }

        SequentialAnimation {
            id: closenessMeterIncorrectAnswerAnimation
            onStarted: optionListView.blockAnswerButtons = true
            NumberAnimation { target: closenessMeter; property: "scale"; to: 1.1; duration: 450 }
            NumberAnimation { target: closenessMeter; property: "scale"; to: 1.0; duration: 450 }
            onStopped: optionListView.blockAnswerButtons = false
        }

        SequentialAnimation {
            id: closenessMeterCorrectAnswerAnimation
            onStarted: optionListView.blockAnswerButtons = true
            NumberAnimation { target: closenessMeter; property: "scale"; to: 1.1; duration: 450 }
            NumberAnimation { target: closenessMeter; property: "scale"; to: 1.0; duration: 450 }
            NumberAnimation { target: closenessMeter; property: "scale"; to: 1.1; duration: 450 }
            NumberAnimation { target: closenessMeter; property: "scale"; to: 1.0; duration: 450 }
            ScriptAction { script: { Activity.nextSubLevel() } }
        }

        ParticleSystemStarLoader {
            id: particles
            clip: false
        }

        function stopAnimations() {
            optionListView.blockAnswerButtons = false
            closenessMeterCorrectAnswerAnimation.stop()
            closenessMeterIncorrectAnswerAnimation.stop()
        }
    }

    GCProgressBar {
        id: progressBar
        height: bar.height * 0.35
        width: parent.width * 0.35

        readonly property real percentage: (mainQuizScreen.numberOfCorrectAnswers / score.numberOfSubLevels) * 100
        message: qsTr("%1%").arg(value)

        value: Math.round(percentage * 10) / 10
        to: 100

        visible: items.assessmentMode
        y: parent.height - bar.height - height - 10 * ApplicationInfo.ratio
        x: parent.width - width * 1.1

        Rectangle {
            z: -1
            radius: 5 * ApplicationInfo.ratio
            anchors.centerIn: parent
            height: progressBar.height * 1.25
            width: parent.width
            color: "#80EEEEEE"
        }
    }

    Rectangle {
        id: restartAssessmentMessage
        width: parent.width
        height: parent.height - bar.height * 1.25
        anchors.top: parent.top
        anchors.margins: 10 * ApplicationInfo.ratio
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 4 * ApplicationInfo.ratio
        visible: items.assessmentMode && (score.currentSubLevel >= score.numberOfSubLevels)
        z: 4
        GCText {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            fontSizeMode: mediumSize
            text: qsTr("Your final score is: <font color=\"#3bb0de\">%1%</font>.<br><br>%2").arg(progressBar.value).arg(progressBar.value <= 90 ? qsTr("You should score above 90% to become a Solar System expert!<br>Retry to test your skills again or train in normal mode to learn more about the Solar System.") : qsTr("Great! You can replay the assessment to test your knowledge on more questions."))
        }

        // To prevent clicking on options under it
        MouseArea {
            anchors.fill: parent
        }

        onVisibleChanged: scaleAnimation.start()

        NumberAnimation {
            id: scaleAnimation
            target: restartAssessmentMessage
            properties: "scale"
            from: 0
            to: 1
            duration: 1500
            easing.type: Easing.OutBounce
        }
    }

    Score {
        id: score
        anchors.bottom: undefined
        anchors.right: parent.right
        anchors.rightMargin: 10 * ApplicationInfo.ratio
        anchors.top: parent.top
        z: 0
    }
}
