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
import GCompris 1.0
import QtGraphicalEffects 1.0

import "../../core"
import "lang.js" as Activity
import "quiz.js" as QuizActivity

Item {
    id: quiz
    opacity: 0

    property alias background: background
    property alias bonus: bonus
    property alias score: score
    property alias wordImage: wordImage
    property alias imageFrame: imageFrame
    property alias wordListModel: wordListModel
    property alias wordListView: wordListView
    property alias parser: parser
    property var goodWord
    property bool horizontalLayout: background.width >= background.height
    property bool buttonsBlocked: false

    function init(loadedItems_, wordList_, mode_) {
        opacity = 1
        loadedItems_.forceActiveFocus()
        return QuizActivity.init(loadedItems_, wordList_, mode_)
    }

    function restoreFocus() {
        background.forceActiveFocus();
    }

    onGoodWordChanged: Activity.playWord(goodWord.voice)

    Behavior on opacity { PropertyAnimation { duration: 200 } }

    Item {
        id: background
        anchors.fill: parent

        property bool keyNavigation: false

        Keys.enabled: !quiz.buttonsBlocked

        Keys.onEscapePressed: {
            imageReview.start()
        }
        Keys.onRightPressed: {
            keyNavigation = true
            wordListView.incrementCurrentIndex()
        }
        Keys.onLeftPressed:  {
            keyNavigation = true
            wordListView.decrementCurrentIndex()
        }
        Keys.onDownPressed:  {
            keyNavigation = true
            wordListView.incrementCurrentIndex()
        }
        Keys.onUpPressed:  {
            keyNavigation = true
            wordListView.decrementCurrentIndex()
        }
        Keys.onSpacePressed:  {
            keyNavigation = true
            wordListView.currentItem.children[1].pressed()
        }
        Keys.onEnterPressed:  {
            keyNavigation = true
            wordListView.currentItem.children[1].pressed()
        }
        Keys.onReturnPressed:  {
            keyNavigation = true
            wordListView.currentItem.children[1].pressed()
        }
        Keys.onTabPressed: {
            repeatItem.clicked()
        }
        Keys.onReleased: {
            if (event.key === Qt.Key_Back) {
                event.accepted = true
                imageReview.start()
            }
        }

        JsonParser {
            id: parser

            onError: console.error("Lang: Error parsing json: " + msg);
        }

        ListModel {
            id: wordListModel
        }

        Grid {
            id: gridId
            columns: quiz.horizontalLayout ? 2 : 1
            spacing: 10 * ApplicationInfo.ratio
            anchors.fill: parent
            anchors.margins: spacing

            Item {
                id: imageContainer
                width: quiz.horizontalLayout
                       ? background.width  - wordListView.width - gridId.spacing * 3
                       : wordListView.width
                height: quiz.horizontalLayout
                        ? wordListView.height
                        : background.height - bar.height - wordListView.height - gridId.spacing * 3

                Rectangle {
                    id: imageFrame
                    anchors.centerIn: parent
                    color: "#E0E0F7"
                    border.color: "#373737"
                    border.width: ApplicationInfo.ratio
                    width: quiz.horizontalLayout ?
                            Math.min(parent.width * 0.6, parent.height - repeatItem.height * 2 - gridId.spacing * 2) :
                            Math.min(parent.height, parent.width - repeatItem.height * 2 - gridId.spacing * 2)
                    height: width
                    radius: width * 0.1
                    z: 11
                    visible: QuizActivity.mode !== 3

                    Image {
                        id: wordImage
                        // Images are not svg
                        width: parent.width * 0.9
                        height: width
                        anchors.centerIn: parent

                        property string nextSource
                        function changeSource(nextSource_) {
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
                width: quiz.horizontalLayout
                       ? background.width * 0.55
                       : background.width - gridId.anchors.margins * 2
                height: quiz.horizontalLayout
                        ? background.height - bar.height
                        : (background.height - bar.height) * 0.6
                spacing: 2 * ApplicationInfo.ratio
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
                model: wordListModel

                highlight:  Rectangle {
                    width: (QuizActivity.mode == 1) ? wordListView.width - wordListView.buttonHeight :
                                                        wordListView.width
                    height: wordListView.buttonHeight
                    color: "#AAFFFFFF"
                    radius: 5
                    visible: background.keyNavigation
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

                property int buttonHeight: height / wordListModel.count * 0.9

                delegate: Item {

                    id: wordListViewDelegate

                    width: wordListView.width
                    height: wordListView.buttonHeight

                    Image {
                        id: wordImageQuiz
                        width: height
                        height: wordListView.buttonHeight
                        mipmap: true
                        source: image
                        z: 7
                        fillMode: Image.PreserveAspectFit
                        anchors.right: parent.right
                        visible: (QuizActivity.mode == 1) ? true : false  // hide images after first mini game
                    }

                    AnswerButton {
                        id: wordRectangle
                        width: parent.width * 0.6
                        height: wordListView.buttonHeight
                        textLabel: translatedTxt
                        anchors.right: wordImageQuiz.visible ? wordImageQuiz.left : parent.right
                        anchors.left: parent.left
                        blockAllButtonClicks: quiz.buttonsBlocked
                        onPressed: quiz.buttonsBlocked = true
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

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            sourceSize.width: 64 * ApplicationInfo.ratio

            z: 12
            anchors {
                top: parent.top
                left: parent.left
                margins: 10 * ApplicationInfo.ratio
            }
            onClicked: Activity.playWord(goodWord.voice)
            Behavior on opacity { PropertyAnimation { duration: 200 } }
        }

        Score {
            id: score
            parent: quiz
        }

        Bonus {
            id: bonus
            onWin: imageReview.nextMiniGame()
        }
    }
}
