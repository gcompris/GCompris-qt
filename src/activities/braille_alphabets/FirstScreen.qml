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
import core 1.0
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
        source: Activity.url + "braille_button.svg"
        sourceSize.height: Math.min(parent.height * 0.25, parent.width * 0.25)
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            leftMargin: GCStyle.baseMargins
            verticalCenter: body_text1.verticalCenter
        }
        Behavior on scale { PropertyAnimation { duration: 100 } }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: first_screen.visible
            enabled: first_screen.visible
            onClicked: {
                dialogMap.visible = true
                displayDialog(dialogMap)
            }
            onEntered: introChar.scale = 1.1
            onExited: introChar.scale = 1
        }
    }

    GCText {
        id: body_text1
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
            right: parent.right
            left: introChar.right
            margins: GCStyle.baseMargins
        }
        color: GCStyle.darkerText
        height: heading.height * 4
        wrapMode: Text.WordWrap
    }

    GCText {
        id: bottom_text
        text: qsTr("When you are ready, click on me and try reproducing braille characters.")
        fontSize: regularSize
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: GCStyle.darkerText
        wrapMode:  Text.WordWrap
        anchors {
            top: body_text1.bottom
            left: parent.left
            margins: GCStyle.baseMargins
        }
        height: heading.height * 4
        width: (parent.width * 0.5) - GCStyle.baseMargins
    }

    Item {
        id: tuxArea
        anchors {
            left: bottom_text.right
            right: parent.right
            top: body_text1.bottom
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
                onClicked: first_screen.visible  = false
                onEntered: introTux.scale = 1.1
                onExited: introTux.scale = 1
            }
        }

        Image {
            id: introTux
            source: Activity.url + "tux_braille.svg"
            fillMode: Image.PreserveAspectFit
            sourceSize.height: bgTux.height * 0.8
            anchors.centerIn: bgTux
            Behavior on scale { PropertyAnimation { duration: 100 } }
        }
    }
}
