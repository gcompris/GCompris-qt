/* GCompris - Quiz.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"
import "lang.js" as Activity
import "quiz.js" as QuizActivity

Item {
    id: quiz
    opacity: 0

    property Item bonus
    property alias activityBackground: activityBackground
    property alias score: score
    property alias wordImage: wordImage
    property alias imageFrame: imageFrame
    property alias wordListModel: wordListModel
    property alias wordListView: wordListView
    property alias parser: parser
    property var goodWord
    property bool horizontalLayout: activityBackground.width >= activityBackground.height
    property bool buttonsBlocked: false

    function init(loadedItems_, wordList_, mode_) {
        opacity = 1
        loadedItems_.forceActiveFocus()
        return QuizActivity.init(loadedItems_, wordList_, mode_)
    }

    function restoreFocus() {
        activityBackground.forceActiveFocus();
    }

    onGoodWordChanged: Activity.playWord(goodWord.voice)

    Behavior on opacity { PropertyAnimation { duration: 200 } }

    Item {
        id: activityBackground
        anchors.fill: parent

        property bool keyNavigation: false

        Keys.onPressed: (event)=> {
            var acceptEvent = true;
            if(event.key === Qt.Key_Escape || event.key === Qt.Key_Back) {
                event.accepted = true
                quiz.bonus.haltBonus()
                imageReview.start()
            } else if(quiz.buttonsBlocked) {
                return;
            } else if(event.key === Qt.Key_Right){
                keyNavigation = true
                wordListView.incrementCurrentIndex()
            } else if(event.key === Qt.Key_Left){
                keyNavigation = true
                wordListView.decrementCurrentIndex()
            } else if(event.key === Qt.Key_Down){
                keyNavigation = true
                wordListView.incrementCurrentIndex()
            } else if(event.key === Qt.Key_Up){
                keyNavigation = true
                wordListView.decrementCurrentIndex()
            } else if(event.key === Qt.Key_Space){
                keyNavigation = true
                wordListView.currentItem.children[1].pressed()
            } else if(event.key === Qt.Key_Enter ||
                    event.key === Qt.Key_Return ||
                    event.key === Qt.Key_Space){
                keyNavigation = true
                wordListView.currentItem.children[1].pressed()
            } else if(event === Qt.Key_Tab){
                repeatItem.clicked()
            } else {
                acceptEvent = false
            }
            event.accepted = acceptEvent
        }

        JsonParser {
            id: parser

            onError: (msg) => console.error("Lang: Error parsing json: " + msg);
        }

        ListModel {
            id: wordListModel
        }

        Grid {
            id: gridId
            columns: quiz.horizontalLayout ? 2 : 1
            spacing: GCStyle.baseMargins
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2

            Item {
                id: imageContainer
                width: quiz.horizontalLayout ?
                    gridId.width - wordListView.width - gridId.spacing : wordListView.width
                height: quiz.horizontalLayout ?
                    wordListView.height : gridId.height - wordListView.height - gridId.spacing

                Rectangle {
                    id: imageFrame
                    anchors.centerIn: parent
                    color: "#E0E0F7"
                    border.color: GCStyle.darkBorder
                    border.width: GCStyle.thinnestBorder
                    width: quiz.horizontalLayout ?
                            Math.min(parent.width, parent.height - repeatItem.height * 2 - gridId.spacing * 2) :
                            Math.min(parent.height, parent.width - repeatItem.height * 2 - gridId.spacing * 2)
                    height: width
                    radius: GCStyle.baseMargins
                    z: 11
                    visible: QuizActivity.mode !== 3

                    Image {
                        id: wordImage
                        // Images are not svg
                        width: parent.width - 2 * GCStyle.baseMargins
                        height: width
                        anchors.centerIn: parent

                        property string nextSource
                        function changeSource(nextSource_: string) {
                            nextSource = nextSource_
                            animImage.start()
                        }

                        SequentialAnimation {
                            id: animImage
                            PropertyAnimation {
                                target: wordImage
                                property: "opacity"
                                to: 0
                                duration: 100
                            }
                            PropertyAction {
                                target: wordImage
                                property: "source"
                                value: wordImage.nextSource
                            }
                            PropertyAnimation {
                                target: wordImage
                                property: "opacity"
                                to: 1
                                duration: 100
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Activity.playWord(goodWord.voice)
                        }
                    }
                }
            }

            ListView {
                id: wordListView
                width: quiz.horizontalLayout ? gridId.width * 0.55 : gridId.width
                height: quiz.horizontalLayout ? gridId.height : gridId.height * 0.6
                spacing: GCStyle.tinyMargins
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
                model: wordListModel

                highlight:  Rectangle {
                    width: (QuizActivity.mode == 1) ?
                        wordListView.width - wordListView.buttonHeight - wordListView.spacing :
                        wordListView.width
                    height: wordListView.buttonHeight
                    color: "#AAFFFFFF"
                    visible: activityBackground.keyNavigation
                    y: wordListView.currentItem ? wordListView.currentItem.y : 0
                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                }
                highlightFollowsCurrentItem: false
                focus: true
                keyNavigationWraps: true

                property int buttonHeight: height / wordListModel.count - spacing

                delegate: Item {
                    id: wordListViewDelegate
                    width: wordListView.width
                    height: wordListView.buttonHeight

                    Image {
                        id: wordImageQuiz
                        width: height
                        height: wordListView.buttonHeight
                        source: image
                        z: 7
                        fillMode: Image.PreserveAspectFit
                        anchors.right: parent.right
                        visible: (QuizActivity.mode == 1) ? true : false  // hide images after first mini game
                    }

                    AnswerButton {
                        id: wordRectangle
                        height: wordListView.buttonHeight
                        textLabel: translatedTxt
                        anchors.right: wordImageQuiz.visible ? wordImageQuiz.left : parent.right
                        anchors.rightMargin: wordImageQuiz.visible ? GCStyle.tinyMargins : 0
                        anchors.left: parent.left
                        blockAllButtonClicks: quiz.buttonsBlocked
                        onPressed: {
                            quiz.buttonsBlocked = true
                            if(isCorrectAnswer) {
                                goodAnswerEffect.play()
                                score.currentSubLevel++
                                score.playWinAnimation()
                            } else {
                                badAnswerEffect.play()
                            }
                        }
                        isCorrectAnswer: translatedTxt === quiz.goodWord.translatedTxt
                        onIncorrectlyPressed: {
                            // push the error to have it asked again
                            QuizActivity.remainingWords.unshift(quiz.goodWord);
                            QuizActivity.nextSubLevelQuiz();
                        }
                        onCorrectlyPressed: {
                            QuizActivity.nextSubLevelQuiz();
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

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            width: GCStyle.bigButtonHeight
            z: 12
            anchors {
                top: parent.top
                left: parent.left
                margins: GCStyle.baseMargins
            }
            onClicked: Activity.playWord(goodWord.voice)
            Behavior on opacity { PropertyAnimation { duration: 200 } }
        }

        Score {
            id: score
            anchors.margins: 2 * GCStyle.baseMargins
        }
    }
}
