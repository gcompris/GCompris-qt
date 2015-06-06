/* GCompris - Quiz.qml
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
 *
 *
 * Authors:
 *   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
 *   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port of lang)
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
import "qrc:/gcompris/src/core/core.js" as Core

Item{
    id: quiz
    opacity: displayed ? 1 : 0

    property bool displayed: index == 0 ? false : true

    // The opacity of quiz, set to 0 to disable
    property int index: 1

    //    QtObject {
    //        id: quizItems
    //        property Item main: activity.main
    property alias background: background
    property alias bar: bar
    property alias bonus: bonus
    property alias score: score
    property alias wordImage: wordImage
    property alias imageFrame: imageFrame
    property alias wordListModel: wordListModel
    property alias wordImageModel: wordImageModel
    property alias parser: parser
    property variant goodWord
    property int goodWordIndex

    function playWord() {
        if (!activity.audioVoices.append(ApplicationInfo.getAudioFilePath(goodWord.voice)))
            voiceError();
    }
    onGoodWordChanged: playWord()

    //    }

    Image {
        id: background
        source: "qrc:/gcompris/src/activities/lang/resource/imageid-bg.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width

        property bool horizontalLayout: background.width > background.height
        property bool keyNavigation: false

        //    Keys.onRightPressed: {
        //        keyNavigation = true
        //        wordListView.incrementCurrentIndex()
        //    }
        //    Keys.onLeftPressed:  {
        //        keyNavigation = true
        //        wordListView.decrementCurrentIndex()
        //    }
        //    Keys.onDownPressed:  {
        //        keyNavigation = true
        //        wordListView.incrementCurrentIndex()
        //    }
        //    Keys.onUpPressed:  {
        //        keyNavigation = true
        //        wordListView.decrementCurrentIndex()
        //    }
        //    Keys.onSpacePressed:  {
        //        keyNavigation = true
        //        wordListView.currentItem.pressed()
        //    }
        //    Keys.onEnterPressed:  {
        //        keyNavigation = true
        //        wordListView.currentItem.pressed()
        //    }
        //    Keys.onReturnPressed:  {
        //        keyNavigation = true
        //        wordListView.currentItem.pressed()
        //    }

        JsonParser {
            id: parser

            onError: console.error("Lang: Error parsing json: " + msg);
        }

        ListModel {
            id: wordListModel
        }

        ListModel {
            id: wordImageModel
        }

        Grid {
            id: gridId
            columns: horizontalLayout ? 3 : 1
            spacing: 2 * ApplicationInfo.ratio
            anchors.fill: parent
            anchors.margins: 2 * ApplicationInfo.ratio

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
                    sourceSize.width: background.horizontalLayout ? parent.width * 0.6 : parent.height * 1.2
                    z: 11

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
                    }
                }
            }

            ListView{
                id: wordImageView
                width: background.horizontalLayout
                       ? background.width * 0.30
                       : background.width - gridId.anchors.margins * 2
                height: background.horizontalLayout
                        ? background.height - bar.height
                        : (background.height - bar.height) * 0.40
                spacing: 10 * ApplicationInfo.ratio
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
                model: wordImageModel

                property int buttonHeight: height / wordListModel.count * 0.9

                delegate: Image{
                    id: wordImageQuiz
                    width: wordImageView.width/2
                    height: wordImageView.buttonHeight
                    source: image
                }
            }

            ListView {
                id: wordListView
                width: background.horizontalLayout
                       ? background.width * 0.30
                       : background.width - gridId.anchors.margins * 2
                height: background.horizontalLayout
                        ? background.height - bar.height
                        : (background.height - bar.height) * 0.40
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

                delegate: AnswerButton {
                    id: wordRectangle

                    width: wordListView.width
                    height: wordListView.buttonHeight

                    textLabel: word
                    isCorrectAnswer: word === Activity.quizItems.goodWord.translatedTxt
                    onIncorrectlyPressed: Activity.badWordSelected(Activity.quizItems.goodWordIndex);
                    onCorrectlyPressed: Activity.nextSubLevelQuiz();
                }
            }
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            sourceSize.width: 80 * ApplicationInfo.ratio

            z: 12
            anchors {
                top: parent.top
                left: parent.left
                margins: 10 * ApplicationInfo.ratio
            }
            onClicked: items.playWord()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar

            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            onWin: Activity.nextLevel()
        }

        Score {
            id: score

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.top: undefined
        }

    }
}
