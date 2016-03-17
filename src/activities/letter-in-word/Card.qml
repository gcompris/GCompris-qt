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

    Image{
        id: wordPic
        sourceSize.width: cardItem.width -6
        sourceSize.height: cardItem.width -5
        fillMode: Image.PreserveAspectFit
        source: imgurl
        z:-5
        //visible: index % 2 != 0 ? false : true
    }


    Image {
        id: cardImage
        anchors.top:wordPic.bottom
        anchors.topMargin: -30 * ApplicationInfo.ratio
        sourceSize.width: cardItem.width - 10
        fillMode: Image.PreserveAspectFit
        source:  Activity.resUrl2 + "cloud.svg"
        z: (state == 'scaled') ? 1 : -1
        //visible: index % 2 != 0 ? false : true

        Row {
            anchors.verticalCenter: cardImage.verticalCenter
            anchors.horizontalCenter: cardImage.horizontalCenter

            Repeater {
                model: components
                GCText {
                    id: textbox
                    z: 11
                    text: textdata
                    font.pointSize: NaN  // need to clear font.pointSize explicitly
                    font.pixelSize: spelling.length > 5 ? (spelling.length > 7 ? cardImage.width * 0.19 : cardImage.width * 0.25): cardImage.width * 0.30
                    font.bold: true
                    style: Text.Outline
                    styleColor: "#2a2a2a"
                    color: selected && textdata.length == 1 && textdata == Activity.currentLetter ? "green" : "white"

                }

            }

        }

        ParticleSystemStarLoader {
            id: particle
            clip: false
        }

        states: State {
            name: "scaled"; when: mouseArea.containsMouse
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
            loops: Animation.Infinite
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
            if (Activity.checkWord(index)) {
                successAnimation.restart();
                particle.burst(30)
                components.clear();
                var tempword;
                var j = 0;
                for(var i = 0; i < spelling.length; i++) {
                    if(spelling.charAt(i) == Activity.currentLetter) {
                        tempword = spelling.substring(j, i);
                        if(i != j) {
                            components.append({"textdata": tempword})
                        }
                        components.append({"textdata": Activity.currentLetter});

                        j = i + 1;
                    }
                }
                if(j < spelling.length) {
                    tempword = spelling.substring(j, spelling.length);
                    components.append({"textdata": tempword})

                }

            } else {
                failureAnimation.restart()
            }
        }
    }



}
