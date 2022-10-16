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
    sourceSize.width: Math.max(parent.width, parent.height)
    visible: false

    GCText {
        id: heading
        text: qsTr("Exploring Morse Code")
        fontSize: largeSize
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.DemiBold
        anchors.centerIn: parent.Center
        color: "#2a2a2a"
        width: parent.width
        wrapMode: Text.WordWrap
    }

    Image {
        id: introChar
        source: "qrc:/gcompris/src/activities/morse_code/morse_code.svg"
        sourceSize.width: parent.width * 0.25
        sourceSize.height: parent.height * 0.4
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignTop
        anchors {
            top: heading.bottom
            topMargin: 10 * ApplicationInfo.ratio
            left: parent.left
            leftMargin:  10 * ApplicationInfo.ratio
        }
    }

    GCText {
        id: bodyText
        text: qsTr('Morse code was developed by Samuel Morse. It is a method of transmitting text information as a series of on-off tones, lights, or clicks.') + "\n" +
              qsTr('Each Morse code symbol represents either a text character (letter or numeral) or a prosign and is represented by a unique sequence of dots and dashes. ' +
                   'The duration of a dash is three times the duration of a dot.' +
                   ' To increase the speed of the communication, the code was designed so that the most common letters have the shorter sequences of dots and dashes.' + "\n" +
                    'For example, the most common letter in English, the letter "E", has the shortest code, a single dot.')
        fontSize: smallSize
        fontSizeMode: Text.Fit
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignJustify
        verticalAlignment: Text.AlignJustify
        wrapMode: Text.WordWrap
        anchors {
            top: heading.bottom
            topMargin: 5 * ApplicationInfo.ratio
            right: parent.right
            rightMargin: 5 * ApplicationInfo.ratio
            left: introChar.right
            leftMargin: 5 * ApplicationInfo.ratio
            bottom: introChar.bottom

        }
        color: "#2a2a2a"
    }
    Item { // Just a margin
        id: margin
        width: 1
        height: 15 * ApplicationInfo.ratio
        anchors {
            top: bodyText.bottom
            left: introChar.right
            right: parent.right
            leftMargin: 5 * ApplicationInfo.ratio
            rightMargin: 5 * ApplicationInfo.ratio
        }
    }

    GCText {
        id: bottomText
        text: qsTr("When you are ready, click on Tux and we will converse in Morse code.")
        fontSize: regularSize
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        width: parent.width * 0.75
        color: "#2a2a2a"
        horizontalAlignment: Text.AlignJustify
        wrapMode: Text.WordWrap
        anchors {
            top: margin.bottom
            topMargin: 10 * ApplicationInfo.ratio
            left: introChar.left
            leftMargin: 10 * ApplicationInfo.ratio
        }
    }

    Image {
        id: introTux
        source: "qrc:/gcompris/src/activities/braille_alphabets/resource/tux_braille.svg"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: parent.width * 0.2
        height: parent.height * 0.2
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 5 * ApplicationInfo.ratio
            bottomMargin: 5 * ApplicationInfo.ratio
        }
        Behavior on scale { PropertyAnimation { duration: 100} }

        MouseArea {
            id: tuxClick
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
}
