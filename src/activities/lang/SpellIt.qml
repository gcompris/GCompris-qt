/* GCompris - Spell_it.qml
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
import "quiz.js" as QuizActivity
import "spell_it.js" as SpellActivity
import "qrc:/gcompris/src/core/core.js" as Core


Item {
    id: spellIt
    opacity: displayed ? 1 : 0

    property bool displayed: index == 0 ? false : true

    // The opacity of spell it, set to 0 to disable
    property int index: 1

    property alias background: background
    property alias wordImage: wordImage
    property alias imageFrame: imageFrame
    property alias hintTextbg: hintTextbg
    property alias hintText:  hintText
    property alias parser: parser
    property alias answerbg: answerbg
    property alias answer: answer
    property alias ok: ok
    property alias okMouseArea: okMouseArea
    property alias bonus: bonus
    property variant goodWord
    property int goodWordIndex


    function init(items_, loadedItems_, wordList_, mode_) {
        SpellActivity.init(items_, loadedItems_, wordList_, mode_);
    }

    function playWord() {
        if(!activity.audioVoices.fileExists(ApplicationInfo.getAudioFilePath(goodWord.voice))) {
            console.log("file does not exist so don't display the repeatItem")
            voiceError();
        }
        else {
            activity.audioVoices.clearQueue()
            if (!activity.audioVoices.append(ApplicationInfo.getAudioFilePath(goodWord.voice)))
                voiceError();
        }
    }
    onGoodWordChanged: playWord()

    Image {
        id: background
        source: "qrc:/gcompris/src/activities/lang/resource/imageid-bg.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        height: parent.height

        property bool horizontalLayout: background.width > background.height


        JsonParser {
            id: parser
            onError: console.error("Lang: Error parsing json: " + msg);
        }

        Rectangle {
            id: hintTextbg
            x: hintText.x -4
            y: hintText.y -4
            width: imageFrame.width
            height: hintText.height +4
            color: "#5090ff"
            border.color: "#000000"
            border.width: 2
            radius: 16
            anchors.bottom: imageFrame.top
            anchors.left: imageFrame.left
            anchors.bottomMargin: 5


            GCText {
                id: hintText
                text: ""
                fontSize: largeSize
                font.weight: Font.DemiBold
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                wrapMode: Text.WordWrap

                property string nextHint
                function changeHint(nextHint_) {
                    nextHint = nextHint_
                    animHint.start()
                }

                SequentialAnimation {
                    id: animHint
                    PropertyAnimation {
                        target: hintText
                        property: "opacity"
                        to: 0
                        duration: 100
                    }
                    PropertyAction {
                        target: hintText
                        property: "text"
                        value: ""+ hintText.nextHint
                    }
                    PropertyAnimation {
                        target: hintText
                        property: "opacity"
                        to: 1
                        duration: 100
                    }
                }

            }
        }

        Image {
            id: imageFrame
            width:  background.width * 0.55
            height: background.horizontalLayout
                    ? (background.height - Activity.items.bar.height - Activity.items.keyboard.height)* 0.7
                    : (background.height - Activity.items.bar.height) * 0.4

            anchors {
                horizontalCenter: background.horizontalCenter
                top: background.top
                topMargin: (background.height - Activity.items.bar.height - Activity.items.keyboard.height) * 0.15
            }
            source: "qrc:/gcompris/src/activities/lang/resource/imageid_frame.svg"
            sourceSize.width: background.horizontalLayout ? parent.width * 0.9 : parent.height * 1.2
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

        Rectangle {
            id: answerbg
            x: answer.x -4
            y: answer.y -4
            width: imageFrame.width
            height: answer.height +4
            color: "#5090ff"
            border.color: "#000000"
            border.width: 2
            radius: 16
            anchors {
                top: imageFrame.bottom
                left: imageFrame.left
                topMargin: 20* ApplicationInfo.ratio
            }

            TextInput {
                id: answer
                width: hintTextbg.width
                height: hintTextbg.height
                color: "white"
                cursorVisible: true
                focus: true
                visible: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.pointSize: hintText.fontSize

                onAccepted: {
                    answer.forceActiveFocus()
                    okMouseArea.clicked(okMouseArea)
                }
            }
        }

        Image {
            id: ok
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: answerbg.width * 1.2
            height: answerbg.height
            fillMode: Image.PreserveAspectFit
            anchors {
                top: imageFrame.bottom
                topMargin: 10* ApplicationInfo.ratio
                left: imageFrame.right
                leftMargin: 10* ApplicationInfo.ratio
                right: parent.right
            }
            MouseArea {
                id: okMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: ok.scale = 1.1
                onClicked: {
                    var check = SpellActivity.checkAnswer(answer.text)
                    if (check)
                        ++Activity.currentProgress[Activity.currentLevel]
                }
                onExited: ok.scale = 1
            }
        }


        //        VirtualKeyboard {
        //            id: keyboard
        //            x: 0

        //            anchors.bottom: parent.bottom
        //            anchors.horizontalCenter: parent.horizontalCenter
        //            width: parent.width

        //            onKeypress: answer.insert(answer.length,text)

        //            onError: console.log("VirtualKeyboard error: " + msg);
        //        }

        Bonus {
            id: bonus
            onWin: Activity.nextMiniGame()
        }

    }
}
