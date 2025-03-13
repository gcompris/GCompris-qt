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
import core 1.0

import "../../core"
import "lang.js" as Activity
import "spell_it.js" as SpellActivity

Item {
    id: spellIt
    opacity: 0

    property Item bonus
    property alias activityBackground: activityBackground
    property alias wordImage: wordImage
    property alias imageFrame: imageFrame
    property alias hintText:  hintTextPanel
    property alias parser: parser
    property alias answer: answer
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
        spellIt.bonus.haltBonus()
        imageReview.start()
    }
    Keys.onTabPressed: {
        repeatItem.clicked()
    }

    Item {
        id: activityBackground
        anchors.fill: parent
        anchors.margins: GCStyle.baseMargins

        property bool horizontalLayout: activityBackground.width >= activityBackground.height

        JsonParser {
            id: parser
            onError: (msg) => console.error("Lang: Error parsing json: " + msg);
        }

        GCTextPanel {
            id: hintTextPanel
            panelWidth: answerBg.width
            panelHeight: Math.min(GCStyle.bigButtonHeight,
                                  (bar.y - GCStyle.baseMargins * 4) * 0.33)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            color: "#aaffffff"
            border.width: 0
            textItem.color: GCStyle.darkText

            property string nextHint
            function changeHint(nextHint_: string) {
                nextHint = nextHint_
                animHint.start()
            }

            SequentialAnimation {
                id: animHint
                PropertyAnimation {
                    target: hintTextPanel
                    property: "opacity"
                    to: 0
                    duration: 100
                }
                ScriptAction {
                    script: hintTextPanel.textItem.text = ""+ hintText.nextHint
                }
                PropertyAnimation {
                    target: hintText
                    property: "opacity"
                    to: 1
                    duration: 100
                }
            }
        }

        Item {
            id: imageFrame
            width: answerBg.width
            height: bar.y - hintTextPanel.height - answerBg.height - 4 * GCStyle.baseMargins
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: hintTextPanel.bottom
                margins: GCStyle.baseMargins
            }
            z: 11

            Rectangle {
                id: imageBg
                color: "#E0E0F7"
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height)
                height: width
                radius: GCStyle.baseMargins
                border.color: GCStyle.darkBorder
                border.width: GCStyle.thinnestBorder
            }

            Image {
                id: wordImage
                // Images are not svg
                width: Math.min(parent.width, parent.height) - 2 * GCStyle.baseMargins
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
                    onClicked: {
                        Activity.playWord(goodWord.voice)
                    }
                }
            }
        }

        Rectangle {
            id: answerBg
            width: parent.width - (GCStyle.bigButtonHeight + GCStyle.baseMargins) * 2
            height: hintTextPanel.height
            color: "#AAFFFFFF"
            radius: GCStyle.halfMargins
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: imageFrame.bottom
                margins: GCStyle.baseMargins
            }
            z: 20

            TextInput {
                id: answer
                width: parent.width - 2 * GCStyle.baseMargins
                height: parent.height - 2 * GCStyle.baseMargins
                anchors.centerIn: parent
                color: GCStyle.darkText
                cursorVisible: true
                focus: false
                activeFocusOnPress: !ApplicationInfo.isMobile
                visible: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.pointSize: hintTextPanel.textItem.pointSize
                font.weight: Font.DemiBold
                font.family: GCSingletonFontLoader.fontName
                font.capitalization: ApplicationSettings.fontCapitalization
                font.letterSpacing: ApplicationSettings.fontLetterSpacing
                maximumLength: maximumLengthAnswer
                wrapMode: TextInput.Wrap
                onAccepted: {
                    okMouseArea.clicked(undefined) // The value is not used
                }
            }
        }

        Image {
            id: okButton
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: GCStyle.bigButtonHeight
            fillMode: Image.PreserveAspectFit
            anchors {
                verticalCenter: answerBg.verticalCenter
                right: parent.right
            }
            MouseArea {
                id: okMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: okButton.scale = 1.1
                onClicked: {
                    SpellActivity.checkAnswer(answer.text)
                }
                onExited: okButton.scale = 1
            }
        }
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
        anchors.bottom: undefined
        y: okButton.y + okButton.height + GCStyle.baseMargins * 3
    }

    VirtualKeyboard {
        id: keyboard
        parent: keyboardArea
        anchors.bottom: undefined
        anchors.horizontalCenter: undefined
        width: parent.width
        visible: ApplicationSettings.isVirtualKeyboard

        onKeypress: (text) => SpellActivity.processKeyPress(text)
        onError: (msg) => console.log("VirtualKeyboard error: " + msg);
    }

}
