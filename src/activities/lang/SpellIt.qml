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
import QtQuick 2.12
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

    Item {
        id: background
        anchors.fill: parent

        property bool horizontalLayout: background.width >= background.height

        JsonParser {
            id: parser
            onError: console.error("Lang: Error parsing json: " + msg);
        }

        Rectangle {
            id: hintTextbg
            width: imageFrame.width
            height: 42 * ApplicationInfo.ratio
            color: "#AAFFFFFF"
            radius: 16
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 4 * ApplicationInfo.ratio
            }


            GCText {
                id: hintText
                text: ""
                fontSizeMode: Text.Fit
                fontSize: mediumSize
                font.weight: Font.DemiBold
                width: parent.width - 8
                height: parent.height - 8
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#373737"
                anchors.centerIn: parent

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

        Item {
            id: imageFrame
            width: (parent.width - 72 * ApplicationInfo.ratio) * 0.8
            height: bar.y - hintTextbg.height - answerbg.height - 4 * anchors.margins
//             height: (parent.height - hintTextbg.height - answerbg.height - bar.height * 1.1) * 0.8
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: hintTextbg.bottom
                margins: 10 * ApplicationInfo.ratio
            }
            z: 11

            Rectangle {
                id: imageBg
                color: "#E0E0F7"
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height)
                height: width
                radius: width * 0.1
                border.color: "#373737"
                border.width: ApplicationInfo.ratio
            }

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
            width: imageFrame.width + 8
            height: 96 * ApplicationInfo.ratio
            color: "#AAFFFFFF"
            radius: 16
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: imageFrame.bottom
                margins: 10 * ApplicationInfo.ratio
            }
            z: 20

            TextInput {
                id: answer
                width: parent.width - 4
                height: parent.height - 4
                color: "#373737"
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
                wrapMode: TextInput.Wrap
                onAccepted: {
                    okMouseArea.clicked(toString(okMouseArea))
                }
            }
        }

        Image {
            id: ok
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: Math.min(answerbg.x, 100 * ApplicationInfo.ratio) - 2 * anchors.leftMargin
            fillMode: Image.PreserveAspectFit
            anchors {
                verticalCenter: answerbg.verticalCenter
                left: answerbg.right
                leftMargin: 10 * ApplicationInfo.ratio

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
        sourceSize.width: Math.min(hintTextbg.x, 84 * ApplicationInfo.ratio) - 2 * anchors.margins
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
