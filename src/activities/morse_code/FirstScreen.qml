/* GCompris - FirstScreen.qml
 *
 * SPDX-FileCopyrightText: 2016 SOURADEEP BARUA <sourad97@gmail.com>
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   SOURADEEP BARUA <sourad97@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import "../../core"

Image {
    id: firstScreen
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: "qrc:/gcompris/src/activities/braille_alphabets/resource/intro_bg.svg"
    sourceSize.width: width
    sourceSize.height: height

    GCText {
        id: heading
        text: qsTr("Exploring Morse Code")
        fontSize: largeSize
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.DemiBold
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: GCStyle.baseMargins
        color: GCStyle.darkerText
        width: parent.width
        height: (parent.height - bar.height - 4 * GCStyle.baseMargins) * 0.1
        wrapMode: Text.WordWrap
    }

    Image {
        id: introChar
        source: "qrc:/gcompris/src/activities/morse_code/resource/morseButton.svg"
        sourceSize.height: Math.min(parent.height * 0.25, parent.width * 0.25)
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            leftMargin: GCStyle.baseMargins
            verticalCenter: bodyText.verticalCenter
        }
        Behavior on scale { PropertyAnimation { duration: 100 } }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: firstScreen.visible
            enabled: firstScreen.visible
            onClicked: {
                morseMap.visible = true
                displayDialog(morseMap)
            }
            onEntered: introChar.scale = 1.1
            onExited: introChar.scale = 1
        }
    }

    GCText {
        id: bodyText
        text: qsTr('Morse code was developed by Samuel Morse. It is a method of transmitting text information as a series of on-off tones, lights, or clicks.') + "\n" +
              qsTr('Each Morse code symbol represents either a text character (letter or numeral) or a prosign and is represented by a unique sequence of dots and dashes. ' +
                   'The duration of a dash is three times the duration of a dot.' +
                   ' To increase the speed of the communication, the code was designed so that the most common letters have the shorter sequences of dots and dashes.' + "\n" +
                    'For example, the most common letter in English, the letter "E", has the shortest code, a single dot.')
        fontSize: regularSize
        fontSizeMode: Text.Fit
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignJustify
        anchors {
            top: heading.bottom
            right: parent.right
            left: introChar.right
            margins: GCStyle.baseMargins
        }
        color: GCStyle.darkerText
        height: heading.height * 4
        wrapMode: Text.WordWrap
    }

    GCText {
        id: bottomText
        text: qsTr("When you are ready, click on Tux and we will converse in Morse code.")
        fontSize: regularSize
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: GCStyle.darkerText
        wrapMode:  Text.WordWrap
        anchors {
            top: bodyText.bottom
            left: parent.left
            margins: GCStyle.baseMargins
        }
        height: heading.height * 4
        width: (parent.width * 0.5) - GCStyle.baseMargins
    }

    Item {
        id: tuxArea
        anchors {
            left: bottomText.right
            right: parent.right
            top: bodyText.bottom
            bottom: parent.bottom
            margins: GCStyle.baseMargins
            bottomMargin: bar.height + GCStyle.baseMargins * 3
        }

        Rectangle {
            id: bgTux
            color: "#94c1d2"
            height: Math.min(parent.width, parent.height)
            width: height
            radius: height * 0.5
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                id: tux_click
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    firstScreen.visible  = false
                    keyboard.populateMorse()
                    textInput.text = ''
                }
                onEntered: introTux.scale = 1.1
                onExited: introTux.scale = 1
            }
        }

        Image {
            id: introTux
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/tux_braille.svg"
            fillMode: Image.PreserveAspectFit
            sourceSize.height: bgTux.height * 0.8
            anchors.centerIn: bgTux
            Behavior on scale { PropertyAnimation { duration: 100 } }
        }
    }
}
