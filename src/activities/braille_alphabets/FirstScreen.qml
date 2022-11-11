/* GCompris - FirstScreen.qml
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "braille_alphabets.js" as Activity

Image {
    id: first_screen
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: Activity.url + "intro_bg.svg"
    sourceSize.width: width
    sourceSize.height: height

    GCText {
        id: heading
        text: qsTr("Braille: Unlocking the Code")
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
        source: Activity.url + "intro_braille_char.svg"
        sourceSize.height: Math.min(parent.height * 0.25, parent.width * 0.25)
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            leftMargin: 5 * ApplicationInfo.ratio
            verticalCenter: body_text1.verticalCenter
        }
    }

    GCText {
        id: body_text1
        z: 1
        text: qsTr('The braille system is a method that is used by blind people to read and write.') + '\n    \n ' +
              qsTr('Each braille character, or cell, is made up of six dot positions, arranged in ' +
                   'a rectangle containing two columns of three dots each. As seen on the left, each ' +
                   'dot is referenced by a number from 1 to 6.')
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
        id: bottom_text
        z: 2
        text: qsTr("When you are ready, click on me and try reproducing braille characters.")
        fontSize: regularSize
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignRight
        color: "#2a2a2a"
        wrapMode:  Text.WordWrap
        anchors {
            top: body_text1.bottom
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
        source: Activity.url + "tux_braille.svg"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: Math.min(parent.width * 0.2, parent.height * 0.2)
        anchors.centerIn: bgTux
        Behavior on scale { PropertyAnimation { duration: 100 } }

        MouseArea {
            id: tux_click
            anchors.fill: parent
            hoverEnabled: true
            onClicked: first_screen.visible  = false
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
            top: body_text1.bottom
            topMargin: 10 * ApplicationInfo.ratio
            left: bottom_text.right
            leftMargin: 10 * ApplicationInfo.ratio
        }
    }
}
