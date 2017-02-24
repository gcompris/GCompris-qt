/* GCompris - FirstScreen.qml
 *
 * Copyright (C) 2016 Souradeep Barua <sourad97@gmail.com>
 *
 * Authors:
 *   Souradeep Barua <sourad97@gmail.com>
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
import "../../core"


Image {
    id: firstScreen
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: "qrc:/gcompris/src/activities/morse_code/resource/intro_bg.svg"
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
        source: "qrc:/gcompris/src/activities/morse_code/resource/Samuel_Morse.svg"
        sourceSize.width: parent.width * 0.25
        sourceSize.height: parent.height * 0.5
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
        id: body_text1
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
        wrapMode:  Text.WordWrap
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
        id:margin
        width: 1
        height: 15 * ApplicationInfo.ratio
        anchors {
            top: body_text1.bottom
            left: introChar.right
            right: parent.right
            leftMargin: 5 * ApplicationInfo.ratio
            rightMargin: 5 * ApplicationInfo.ratio
        }
    }

    GCText {
        id: bottom_text
        text: qsTr("When you are ready, click on me and we will converse in Morse code.")
        fontSize: regularSize
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        width: parent.width * 0.75
        color: "#2a2a2a"
        horizontalAlignment: Text.AlignJustify
        wrapMode:  Text.WordWrap
        anchors {
            top: margin.bottom
            topMargin: 50 * ApplicationInfo.ratio
            left: introChar.left
            leftMargin: 10 * ApplicationInfo.ratio
        }
    }

    Image {
        id: introTux
        source: "qrc:/gcompris/src/activities/morse_code/resource/tux.svg"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: parent.width * 0.2
        height: parent.height * 0.3
        anchors {
            top: bottom_text.top
            left: bottom_text.right
            right: parent.right
            rightMargin: 5 * ApplicationInfo.ratio
            leftMargin: 5 * ApplicationInfo.ratio
        }
        Behavior on scale { PropertyAnimation { duration: 100} }

        MouseArea {
            id: tux_click
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                firstScreen.visible  = false
                keyboard.populateMorse()
                textInput.text=''
            }
            onEntered: introTux.scale = 1.1
            onExited: introTux.scale = 1
        }
    }
}
