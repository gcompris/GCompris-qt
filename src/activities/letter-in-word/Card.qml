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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.1
import GCompris 1.0
import QtGraphicalEffects 1.0
import "../../core"
import "letter-in-word.js" as Activity

Item {
    id: cardItem
    //width: cardImage.width
    height: wordPic.height + cardImage.height - 30 * ApplicationInfo.ratio
    property bool mouseActive: true

    Image {
        id: wordPic
        sourceSize.width: cardItem.width -6
        sourceSize.height: cardItem.width -5
        fillMode: Image.PreserveAspectFit
        source: imgurl
        z: -5
        //visible: index % 2 != 0 ? false : true
    }

    Image {
        id: cardImage
        anchors.top: wordPic.bottom
        anchors.topMargin: -30 * ApplicationInfo.ratio
        sourceSize.width: cardItem.width - 10
        fillMode: Image.PreserveAspectFit
        source: Activity.resUrl2 + "cloud.svg"
        z: (state == 'scaled') ? 1 : -1
        //visible: index % 2 != 0 ? false : true

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

        ParticleSystemStarLoader {
            id: particle
            clip: false
        }

        states:
            State {
                name: "scaled"; when: mouseArea.containsMouse && mouseActive
                PropertyChanges {
                    target: cardItem
                    scale: /*carriageImage.scale * */ 1.2
                    z: 2
                }
            }

        transitions: Transition {
            NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
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
                target: colorCardImage
                property: "opacity"
                to: 1; duration: 400
            }
            NumberAnimation {
                target: colorCardImage
                property: "opacity"
                to: 0; duration: 200
            }
        }

        NumberAnimation {
            id: rotationStop
            running: !selected
            target: cardImage
            property: "rotation"
            to: 0
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

    Colorize {
        id: colorCardImage
        z: 5
        anchors.fill: cardImage
        source: cardImage
        hue: 0.0
        saturation: 1
        opacity: 0
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
                particle.burst(30);
                textItem.textFound = spelling.replace(RegExp(Activity.currentLetter, "g"), "<font color=\"#00FF00\">"+Activity.currentLetter+"</font>");
                playWord();
            }
            else {
                failureAnimation.restart()
            }
        }
    }
}
