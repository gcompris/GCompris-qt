/* GCompris - SpellIt.qml
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
import QtQuick 2.9
import GCompris 1.0
import QtGraphicalEffects 1.0

import "../../core"
import "lang.js" as Activity
import "spell_it.js" as SpellActivity

Item {
    id: spellIt
    opacity: 0

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
    property alias keyboard: keyboard
    property alias score: score
    property var goodWord
    property int goodWordIndex
    property int maximumLengthAnswer

    function init(loadedItems_, wordList_, mode_) {
        opacity = 1
        return SpellActivity.init(loadedItems_, wordList_, mode_);
    }

    function restoreFocus() {
        if(!ApplicationInfo.isMobile)
            answer.forceActiveFocus();
    }

    onGoodWordChanged: Activity.playWord(goodWord.voice)

    Behavior on opacity { PropertyAnimation { duration: 200 } }

    Keys.onEscapePressed: {
        imageReview.start()
    }
    Keys.onTabPressed: {
        repeatItem.clicked()
    }

    Image {
        id: background
        source: "qrc:/gcompris/src/activities/lang/resource/imageid-bg.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height
        width: parent.width
        height: parent.height

        property bool horizontalLayout: background.width >= background.height

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
            anchors.top: parent.top
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
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
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
            source: "qrc:/gcompris/src/activities/lang/resource/imageid_frame.svg"
            sourceSize.width: background.horizontalLayout ? parent.width * 0.9 : parent.height * 1.2
            width:  background.width * 0.55
            height: (background.height - hintTextbg.height - answerbg.height
                     - keyboard.height - bar.height) * 0.8

            anchors {
                horizontalCenter: background.horizontalCenter
                top: background.top
                topMargin: (background.height) * 0.15
            }
            z: 11

            Image {
                id: wordImage
                // Images are not svg
                width: Math.min(parent.width, parent.height) * 0.9
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
                    onClicked: {
                        Activity.playWord(goodWord.voice)
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
                focus: false
                activeFocusOnPress: !ApplicationInfo.isMobile
                visible: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.pointSize: hintText.pointSize
                font.weight: Font.DemiBold
                font.family: GCSingletonFontLoader.fontLoader.name
                font.capitalization: ApplicationSettings.fontCapitalization
                font.letterSpacing: ApplicationSettings.fontLetterSpacing
                maximumLength: maximumLengthAnswer
                onAccepted: {
                    okMouseArea.clicked(toString(okMouseArea))
                }
            }
        }

        Image {
            id: ok
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 70 * ApplicationInfo.ratio
            fillMode: Image.PreserveAspectFit
            anchors {
                top: imageFrame.bottom
                topMargin: 10
                right: imageFrame.left
                rightMargin: parent.width * 0.06

            }
            MouseArea {
                id: okMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: ok.scale = 1.1
                onClicked: {
                    SpellActivity.checkAnswer(answer.text)
                }
                onExited: ok.scale = 1
            }
        }

        Bonus {
            id: bonus
            onWin: imageReview.nextMiniGame()
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
        onClicked: Activity.playWord(goodWord.voice)
        Behavior on opacity { PropertyAnimation { duration: 200 } }
    }

    Score {
        id: score
    }

    VirtualKeyboard {
        id: keyboard
        parent: keyboardArea
        anchors.bottom: undefined
        anchors.horizontalCenter: undefined
        width: parent.width
        visible: ApplicationSettings.isVirtualKeyboard

        onKeypress: SpellActivity.processKeyPress(text)
        onError: console.log("VirtualKeyboard error: " + msg);
    }

}
