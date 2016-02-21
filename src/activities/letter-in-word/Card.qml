/* GCompris - Card.qml
 *
 * Copyright (C) 2014 Holger Kaelberer  <holger.k@elberer.de>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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


        Image{
            id: wordPic
            anchors.bottom: cardImage.top
            sourceSize.width: cardItem.width
            fillMode: Image.PreserveAspectFit
            source: imgurl
            z:-5
        }

        Image {
            id: cardImage
            sourceSize.width: cardItem.width
            fillMode: Image.PreserveAspectFit
            source:  Activity.url + "cloud.svg"
            z: (state == 'scaled') ? 1 : -1


            GCText {
                id: text
                anchors.horizontalCenter:parent.horizontalCenter

                anchors.verticalCenter: parent.verticalCenter

                z: 11

                text: spelling
                font.pointSize: NaN  // need to clear font.pointSize explicitly
                font.pixelSize: parent.width * 0.30
                font.bold: true
                style: Text.Outline
                styleColor: "#2a2a2a"
                color: "white"
            }

            DropShadow {
                anchors.fill: text
                cached: false
                horizontalOffset: 1
                verticalOffset: 1
                radius: 3
                samples: 16
                color: "#422a2a2a"
                source: text
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
                    z: 2}
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
                    duration: 500 }

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
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: ApplicationInfo.isMobile ? false : true

                onClicked: {

                    if (Activity.checkWord(index)) {

                            successAnimation.restart();
                            particle.burst(30)


                    } else {
                        failureAnimation.restart()
                    }
                }
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
}
