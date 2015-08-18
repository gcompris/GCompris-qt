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
import GCompris 1.0
import QtGraphicalEffects 1.0

import "../../core"
import "lang.js" as Activity
import "quiz.js" as QuizActivity

Item {
    id: quiz

    property alias background: background
    property alias bonus: bonus
    property alias wordImage: wordImage
    property alias imageFrame: imageFrame
    property alias wordListModel: wordListModel
    property alias wordListView: wordListView
    property alias parser: parser
    property variant goodWord
    property int goodWordIndex

    function init(items_, loadedItems_, wordList_, mode_) {
        loadedItems_.forceActiveFocus()
        QuizActivity.init(items_, loadedItems_, wordList_, mode_);
    }

    function playWord() {
        if (!activity.audioVoices.append(ApplicationInfo.getAudioFilePath(goodWord.voice)))
            voiceError();
    }

    onGoodWordChanged: playWord()

    Image {
        id: background
        source: "qrc:/gcompris/src/activities/lang/resource/imageid-bg.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        height: parent.height

        property bool horizontalLayout: background.width > background.height
        property bool keyNavigation: false


        Keys.onEscapePressed: {
            if(Activity.currentMiniGame == -1) {
                home()
            }
            else {
                Activity.launchMenuScreen()
            }
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

        JsonParser {
            id: parser

            onError: console.error("Lang: Error parsing json: " + msg);
        }

        ListModel {
            id: wordListModel
        }

        Grid {
            id: gridId
            columns: horizontalLayout ? 2 : 1
            spacing: 10 * ApplicationInfo.ratio
            anchors.fill: parent
            anchors.margins: 10 * ApplicationInfo.ratio

            Item {
                width: background.horizontalLayout
                       ? background.width * 0.40
                       : background.width - gridId.anchors.margins * 2
                height: background.horizontalLayout
                        ? background.height - bar.height
                        : (background.height - bar.height) * 0.4

                Image {
                    id: imageFrame
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    source: "qrc:/gcompris/src/activities/lang/resource/imageid_frame.svg"
                    sourceSize.width: background.horizontalLayout ? parent.width * 0.7 : parent.height * 1.2
                    z: 11
                    visible: QuizActivity.mode ==3 ? false : true

                    Image {
                        id: wordImage
                        sourceSize.width: parent.width * 0.6

                        anchors {
                            centerIn: parent
                            margins: 0.05 + parent.width
                        }
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
                            onClicked: {
                                if(Activity.currentMiniGame != 0)
                                    Activity.loadedItems.playWord()
                            }
                        }
                    }
                }
            }


            ListView {
                id: wordListView
                width: background.horizontalLayout
                       ? background.width * 0.55
                       : background.width - gridId.anchors.margins * 2
                height: background.horizontalLayout
                        ? background.height - bar.height
                        : (background.height - bar.height) * 0.60
                spacing: 10 * ApplicationInfo.ratio
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
                model: wordListModel

                highlight:  Rectangle {
                    width: wordListView.width
                    height: wordListView.buttonHeight
                    color: "lightsteelblue"
                    radius: 5
                    visible: background.keyNavigation
                    y: wordListView.currentItem.y
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
                    anchors.right: parent.right
                    anchors.left: parent.left

                    Image {
                        id: wordImageQuiz
                        width: wordListView.width * 0.4
                        height: wordListView.buttonHeight
                        source: image
                        z: 7
                        fillMode: Image.PreserveAspectFit
                        anchors.leftMargin: 10* ApplicationInfo.ratio
                        visible:  (QuizActivity.mode==1) ? true : false  // to hide images after first mini game
                    }

                    AnswerButton {
                        id: wordRectangle
                        width: parent.width * 0.6
                        height: wordListView.buttonHeight
                        textLabel: word

                        anchors.left: wordImageQuiz.left
                        anchors.leftMargin: 20* ApplicationInfo.ratio
                        anchors.right: parent.right

                        isCorrectAnswer: word === QuizActivity.quizItems.goodWord.translatedTxt
                        onIncorrectlyPressed: {
                            QuizActivity.badWordSelected(goodWordIndex);
                            QuizActivity.nextSubLevelQuiz();
                        }
                        onCorrectlyPressed: {
                            ++Activity.currentProgress[Activity.currentLevel]
                            QuizActivity.nextSubLevelQuiz();
                        }
                    }
                }
            }
        }


        Bonus {
            id: bonus
            onWin: Activity.nextMiniGame()
        }

    }
}
