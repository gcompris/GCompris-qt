/* GCompris - QuizScreen.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

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

    GCTextPanel {
        id: questionArea
        panelWidth: parent.width - 3 * GCStyle.baseMargins - score.width
        panelHeight: Math.min(60 * ApplicationInfo.ratio, parent.height * 0.2)
        fixedHeight: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -(score.width + GCStyle.baseMargins) * 0.5
        anchors.top: parent.top
        anchors.topMargin: GCStyle.baseMargins
        textItem.text: mainQuizScreen.question
    }

    // Model of options for a question
    ListModel {
        id: optionListModel
    }

    // This grid has image of the planet in its first column/row (row in case of vertical screen) and the options on the 2nd column/row
    Grid {
        id: imageAndOptionGrid
        columns: (activityBackground.horizontalLayout && !items.assessmentMode && items.currentLevel != 1) ? 2 : 1
        spacing: GCStyle.baseMargins
        anchors.top: questionArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: closenessMeter.top
        anchors.margins: GCStyle.baseMargins


        // An item to hold image of the planet
        Item {
            id: planetImageArea
            width: activityBackground.horizontalLayout ?
                (parent.width - GCStyle.baseMargins) * 0.5 : parent.width
            height: activityBackground.horizontalLayout ?
                parent.height : (parent.height - GCStyle.baseMargins) * 0.5
            visible: !items.assessmentMode && (items.currentLevel != 1)

            Image {
                id: planetImageMain
                width: Math.min(parent.width, parent.height)
                anchors.centerIn: parent
                source: mainQuizScreen.planetRealImage
                fillMode: Image.PreserveAspectFit
            }
        }

        // An item to hold the list view of options
        Item {
            width: planetImageArea.visible ? planetImageArea.width : parent.width
            height: planetImageArea.visible ? planetImageArea.height : parent.height

            ListView {
                id: optionListView
                anchors.fill: parent
                spacing: GCStyle.halfMargins
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
                model: optionListModel
                currentIndex: -1
                highlightFollowsCurrentItem: false

                readonly property int buttonHeight: (height - 3 * spacing) * 0.25

                add: Transition {
                    NumberAnimation { properties: "y"; from: parent.y; duration: 500 }
                    onRunningChanged: {
                        optionListView.blockAnswerButtons = running
                    }
                }

                property bool blockAnswerButtons: false

                highlight: Rectangle {
                    color:  GCStyle.highlightColor
                    visible: activityBackground.keyboardMode
                    width: optionListView.width + GCStyle.halfMargins
                    height: optionListView.buttonHeight + GCStyle.halfMargins
                    x: -GCStyle.halfMargins * 0.5
                    y: optionListView.currentIndex * (optionListView.buttonHeight + optionListView.spacing) - GCStyle.halfMargins * 0.5
                    Behavior on x { NumberAnimation { duration: 100 } }
                    Behavior on y { NumberAnimation { duration: 100 } }
                }

                delegate: AnswerButton {
                    id: optionButton
                    width: optionListView.width
                    height: optionListView.buttonHeight
                    textLabel: optionValue
                    blockAllButtonClicks: optionListView.blockAnswerButtons

                    isCorrectAnswer: closeness === 100

                    onPressed: {
                        optionListView.blockAnswerButtons = true
                        if(isCorrectAnswer)
                            goodAnswerEffect.play()
                        else
                            badAnswerEffect.play()
                    }
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
                            Activity.currentSubLevel++
                            score.currentSubLevel = Activity.currentSubLevel
                            score.playWinAnimation()
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

    GCSoundEffect {
        id: goodAnswerEffect
        source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
    }

    GCSoundEffect {
        id: badAnswerEffect
        source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
    }

    Rectangle {
        id: closenessMeter
        width: 170 * ApplicationInfo.ratio
        height: 40 * ApplicationInfo.ratio
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: GCStyle.baseMargins
        anchors.bottomMargin: bar.height * 1.3
        radius: GCStyle.halfMargins
        color: GCStyle.lightTransparentBg
        visible: !items.assessmentMode

        GCText {
            id: closenessText
            color: GCStyle.darkText
            height: parent.height - GCStyle.baseMargins
            width: parent.width - 2 * GCStyle.baseMargins
            anchors.centerIn: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Accuracy: %1%").arg(closenessMeterValue)
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
        width: 160 * ApplicationInfo.ratio
        height: 30 * ApplicationInfo.ratio
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: GCStyle.baseMargins + GCStyle.halfMargins
        anchors.bottomMargin: bar.height * 1.3

        readonly property real percentage: (mainQuizScreen.numberOfCorrectAnswers / score.numberOfSubLevels) * 100
        message: qsTr("%1%").arg(value)

        value: Math.round(percentage * 10) / 10
        to: 100

        visible: items.assessmentMode

        Rectangle {
            z: -1
            radius: GCStyle.halfMargins
            anchors.fill: parent
            anchors.margins: -GCStyle.halfMargins
            width: parent.width
            color: GCStyle.lightTransparentBg
        }
    }

    Rectangle {
        id: restartAssessmentMessage
        width: parent.width - 2 * GCStyle.baseMargins
        height: parent.height - bar.height * 1.3
        anchors.top: parent.top
        anchors.margins: GCStyle.baseMargins
        anchors.horizontalCenter: parent.horizontalCenter
        radius: GCStyle.halfMargins
        color: GCStyle.lightBg
        visible: items.assessmentMode && items.restartAssessmentMessage
        z: 4
        GCText {
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
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
        anchors.top: parent.top
        anchors.margins: GCStyle.baseMargins
        z: 0
        isScoreCounter: items.assessmentMode ? false : true
    }
}
