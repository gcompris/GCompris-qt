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
import GCompris 1.0
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
        anchors.centerIn: parent.Center
        color: "#2a2a2a"
        width: parent.width
        height: parent.height * 0.10
        wrapMode: Text.WordWrap
    }

    Image {
        id: introChar
        source: "qrc:/gcompris/src/activities/morse_code/resource/morseButton.svg"
        sourceSize.height: Math.min(parent.height * 0.25, parent.width * 0.25)
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            leftMargin: 5 * ApplicationInfo.ratio
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
        z: 1
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
            topMargin: 5 * ApplicationInfo.ratio
            right: parent.right
            rightMargin: 5 * ApplicationInfo.ratio
            left: introChar.right
            leftMargin: 5 * ApplicationInfo.ratio
        }
        color: "#2a2a2a"
        width: parent.width - introChar.width - 15 * ApplicationInfo.ratio
        height: parent.height * 0.4
        wrapMode: Text.WordWrap
    }

    GCText {
        id: bottomText
        z: 2
        text: qsTr("When you are ready, click on Tux and we will converse in Morse code.")
        fontSize: regularSize
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignRight
        color: "#2a2a2a"
        wrapMode:  Text.WordWrap
        anchors {
            top: bodyText.bottom
            topMargin: 10 * ApplicationInfo.ratio
            left: parent.left
            leftMargin: 10 * ApplicationInfo.ratio
        }
        height: parent.height * 0.25
        width: parent.width * 0.5
    }

    Image {
        id: introTux
        z: 3
        source: "qrc:/gcompris/src/activities/braille_alphabets/resource/tux_braille.svg"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: Math.min(parent.width * 0.2, parent.height * 0.2)
        anchors.centerIn: bgTux
        Behavior on scale { PropertyAnimation { duration: 100 } }

        MouseArea {
            id: tux_click
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                firstScreen.visible = false
                keyboard.populateMorse()
                textInput.text = ''
            }
            onEntered: introTux.scale = 1.1
            onExited: introTux.scale = 1
        }
    }

    Rectangle {
        id: bgTux
        z: 0
        color: "#94c1d2"
        width: introTux.width * 1.5
        height: introTux.height * 1.1
        radius: bgTux.width * 0.5
        anchors {
            top: bodyText.bottom
            topMargin: 10 * ApplicationInfo.ratio
            left: bottomText.right
            leftMargin: 10 * ApplicationInfo.ratio
        }
    }
}
