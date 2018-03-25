/* GCompris - Card.qml
 *
 * Copyright (C) 2016 Akshat Tandon  <akshat.tandon@research.iiit.ac.in>
 *
 * Authors:
 *   Akshat Tandon    <akshat.tandon@research.iiit.ac.in>
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

Item {
    id: cardItem
    height: wordPic.height + cardImage.height - 30 * ApplicationInfo.ratio
    property bool mouseActive: true

    Image {
        id: wordPic
        sourceSize.width: cardItem.width - 6
        sourceSize.height: cardItem.width - 5
        fillMode: Image.PreserveAspectFit
        source: imgurl
        z: -5
    }

    Image {
        id: tick
        source: "qrc:/gcompris/src/core/resource/apply.svg"
        sourceSize.width: cardImage.width / 3
        sourceSize.height: cardImage.width / 3
        visible: false

        anchors {
            leftMargin: cardItem.right - 0.01
            bottomMargin: parent.top - 10
        }
    }
    Image {
        id: cardImage
        anchors.top: wordPic.bottom
        anchors.topMargin: -30 * ApplicationInfo.ratio
        sourceSize.width: cardItem.width - 10
        fillMode: Image.PreserveAspectFit
        source: Activity.resUrl2 + "cloud.svg"
        z: (state == 'marked') ? 1 : -1

        GCText {
            id: textItem
            z: 11
            // textFound is the rich text with letter found, spelling is the text in the dataset
            text:"<font color=\"#2a2a2a\">" + (selected ? textFound : spelling) + "</font>"
            property string textFound: spelling
            textFormat: Text.RichText
            font.pointSize: NaN  // need to clear font.pointSize explicitly
            font.pixelSize: spelling.length > 5 ? (spelling.length > 7 ? cardImage.width * 0.19 : cardImage.width * 0.25): cardImage.width * 0.30
            font.bold: true
            style: Text.Outline
            width: cardImage.width
            height: cardImage.height
            wrapMode: spelling.indexOf(' ') === -1 ? Text.WrapAnywhere : Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            styleColor: "white"
        }

        states:
            State {
                name: "marked"; when: selected && mouseActive
                PropertyChanges {
                    target: tick
                    visible: true
                }
            }

        SequentialAnimation {
            id: successAnimation
            running: selected
            loops: 2
            NumberAnimation {
                target: cardImage
                easing.type: Easing.InOutQuad
                property: "rotation"
                to: 20; duration: 500
            }
            NumberAnimation {
                target: cardImage
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

        SequentialAnimation {
            id: failureAnimation
            NumberAnimation {
                target: cardImage
                property: "opacity"
                to: 1; duration: 400
            }
        }

        NumberAnimation {
            id: rotationStop
            running: !selected
            target: cardImage
            property: "rotation"
            to: 0
            duration: 500
            easing.type: Easing.Linear
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
        if(mouseActive && !successAnimation.running) {
            if (Activity.checkWord(index)) {
                successAnimation.restart();
                if(selected)
                    playWord();
            }
            else {
                failureAnimation.restart()
            }
        }
    }
}
