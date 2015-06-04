/* GCompris - FirstScreen.qml
 *
 * Copyright (C) 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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
import "braille_alphabets.js" as Activity

Image {
    id: first_screen
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: Activity.url + "intro_bg.svg"
    sourceSize.width: parent.width
    
    GCText {
        id: heading
        text: qsTr("Braille : Unlocking the Code")
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
        source: Activity.url + "intro_braille_char.svg"
        sourceSize.width: parent.width * 0.25
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignTop
        anchors {
            top: heading.bottom
            topMargin: 30 * ApplicationInfo.ratio
            bottom: parent.bottom
            bottomMargin: 60 * ApplicationInfo.ratio
            left: parent.left
            leftMargin:  30 * ApplicationInfo.ratio
        }
    }
    
    GCText {
        id: body_text1
        text: qsTr('The Braille system is a method that is used by blind people to read and write.') + "\n" +
              qsTr('Each Braille character, or cell, is made up of six dot positions, arranged in ' +
                   'a rectangle containing two columns of three dots each. As seen on the left, each ' +
                   'dot is referenced by a number from 1 to 6.')
        fontSize: regularSize
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignJustify
        anchors {
            top: heading.bottom
            topMargin: 30 * ApplicationInfo.ratio
            right: parent.right
            rightMargin: 30 * ApplicationInfo.ratio
            left: introChar.right
            leftMargin: 30 * ApplicationInfo.ratio
        }
        color: "#2a2a2a"
        width: parent.width / 2
        wrapMode: Text.WordWrap
    }
    
    GCText {
        id: bottom_text
        text: qsTr("When you are ready, click on me and try reproducing Braille characters.")
        fontSize: regularSize
        font.weight: Font.Bold
        width: parent.width * 0.3
        color: "#2a2a2a"
        horizontalAlignment: Text.AlignJustify
        wrapMode:  Text.WordWrap
        anchors {
            top: body_text1.bottom
            topMargin: 30 * ApplicationInfo.ratio
            left: introChar.right
            leftMargin: 30 * ApplicationInfo.ratio
        }
    }
    
    Image {
        id: introTux
        source: Activity.url + "tux_braille.svg"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: parent.width * 0.2
        anchors {
            top: bottom_text.top
            right: parent.right
            rightMargin: 30 * ApplicationInfo.ratio
            left: bottom_text.right
            leftMargin: 30 * ApplicationInfo.ratio
        }
        Behavior on scale { PropertyAnimation { duration: 100} }
        
        MouseArea {
            id: tux_click
            anchors.fill: parent
            hoverEnabled: true
            onClicked: first_screen.visible  = false
            onEntered: introTux.scale = 1.1
            onExited: introTux.scale = 1
        }
    }
}
