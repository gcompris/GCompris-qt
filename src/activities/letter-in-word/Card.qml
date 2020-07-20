/* GCompris - Card.qml
 *
 * Copyright (C) 2016 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *               2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *   Timothée Giet <animtim@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0
import QtGraphicalEffects 1.0
import "../../core"
import "letter-in-word.js" as Activity

Rectangle {
    id: cardItem
    property bool mouseActive: true
    color: "#01FFFFFF"  //setting the base as not totally transparent rectangle avoids the bug of randomly overlapping images

    Image {
        id: wordPic
        width: cardItem.width * 0.8
        height: width
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        source: imgurl
    }

    Rectangle {
        id: cardBg
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: wordPic.width
        height: wordPic.height * 0.5
        radius: 10 * ApplicationInfo.ratio
        color: "#E0FFFFFF"

        GCText {
            id: textItem
            text: spelling
            font.pointSize: NaN  // need to clear font.pointSize explicitly
            fontSizeMode: Text.Fit
            minimumPixelSize: 10
            font.pixelSize: cardBg.width * 0.30
            font.bold: true
            style: Text.Outline
            width: cardBg.width
            height: cardBg.height
            wrapMode: spelling.indexOf(' ') === -1 ? Text.WrapAnywhere : Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            styleColor: "white"
        }

        SequentialAnimation {
            id: successAnimation
            running: selected
            loops: 2
            NumberAnimation {
                target: cardBg
                easing.type: Easing.InOutQuad
                property: "rotation"
                to: 20; duration: 500
            }
            NumberAnimation {
                target: cardBg
                easing.type: Easing.InOutQuad
                property: "rotation"; to: -20
                duration: 500
            }
            onRunningChanged: {
                if(!running && selected) {
                    rotationStop.restart()
                }
            }
        }

        NumberAnimation {
            id: rotationStop
            running: !selected
            target: cardBg
            property: "rotation"
            to: 0
            duration: 500
            easing.type: Easing.Linear
        }
    }

    Image {
        id: tick
        source: "qrc:/gcompris/src/core/resource/apply.svg"
        sourceSize.width: cardBg.width / 3
        sourceSize.height: cardBg.width / 3
        visible: selected

        anchors {
            leftMargin: cardItem.right - 0.01
            bottomMargin: parent.top - 10
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: ApplicationInfo.isMobile ? false : true
        onClicked: {
            select();
        }
    }

    function playWord() {
        var locale = ApplicationInfo.getVoicesLocale(items.locale)
        activity.audioVoices.append(
             ApplicationInfo.getAudioFilePathForLocale(voice, locale))
    }

    function select() {
        if(mouseActive) {
            if (Activity.checkWord(index)) {
                successAnimation.restart();
                if(selected)
                    playWord();
            }
        }
    }
}
