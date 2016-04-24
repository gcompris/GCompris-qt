/* GCompris - Observe.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
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
import "PhotoHunter.js" as Activity

Image {
    id: card

    sourceSize.width: background.vert ? undefined : (background.width - 30) / 2
    sourceSize.height: background.vert ?
                           (background.height - background.barHeight - 40) /2 :
                           background.height - background.barHeight - 30

    property GCAudio audioEffects: activity.audioEffects
    property alias repeater: repeater
    property alias circleRepeater: circleRepeater
    property int good: 0
    property bool show: false

    Image {
        id: wrong
        source: Activity.url + "wrong.svg"
        width: 70
        height: 70
        opacity: 0
    }

    NumberAnimation {
        id: wrongAnim;
        target: wrong;
        property: "opacity";
        from: 0; to: 1;
        duration: 400
    }

    NumberAnimation {
        id: wrongAnim2;
        target: wrong;
        property: "opacity";
        from: 1; to: 0;
        duration: 400
    }

    MouseArea {
        id: big
        anchors.fill: parent
        onClicked: {
            audioEffects.play('qrc:/gcompris/src/core/resource/sounds/brick.wav')
            wrongAnim.start()
            wrong.x = mouseX - wrong.width/2
            wrong.y = mouseY - wrong.height/2
            wrongAnim2.start()
        }
    }

    Repeater {
        id: repeater

        model: items.model

        Image {
            id: photo
            property alias particleLoader: particleLoader
            property alias differenceAnimation: differenceAnimation
            property double widthScale
            property double heightScale

            width: card.width / 10 * widthScale
            height: card.height / 10 * heightScale

            opacity: 1

            x: modelData[0] * card.width / 1200
            y: modelData[1] * card.height / 1700

            NumberAnimation {
                id: differenceAnimation;
                target: photo;
                property: "opacity";
                from: 0; to: 1;
                duration: 500
            }


            // Create a particle only for the strawberry
            Loader {
                id: particleLoader
                anchors.fill: parent
                active: false
                sourceComponent: particle
            }

            Component {
                id: particle
                ParticleSystemStarLoader {
                    id: particles
                    clip: false
                }
            }

            function showParticles(item,index) {
                item.repeater.itemAt(index).particleLoader.active = active
                item.repeater.itemAt(index).particleLoader.item.burst(40)
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    //only if the difference is not yet spotted
                    if (img2.repeater.itemAt(index).opacity === 0) {
                        // play good sound
                        audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav')

                        //activate the particle loader
                        photo.showParticles(img1,index)
                        photo.showParticles(img2,index)

                        // show the actual difference on the second image
                        img2.repeater.itemAt(index).differenceAnimation.start()

                        // scale animation for the blue circle
                        img1.circleRepeater.itemAt(index).scaleAnim.start()
                        img2.circleRepeater.itemAt(index).scaleAnim.start()

                        // set opacity of circle differences to 1
                        img1.circleRepeater.itemAt(index).opacity = 1
                        img2.circleRepeater.itemAt(index).opacity = 1

                        // all good; check if all the differences have been spotted
                        good++
                        background.checkAnswer()
                    }
                }
            }
        }
    }

    Repeater {
        id: circleRepeater

        model: card.repeater.model

        Rectangle {
            id: circle
            color: "transparent"
            radius: width * 0.5
            border.color: card.show ? "blue" : "red"
            border.width: 3
            opacity: 0
            x: card.repeater.itemAt(index).x - width/12
            y: card.repeater.itemAt(index).y - height/12
            width: card.repeater.itemAt(index).width * 1.2
            height: card.repeater.itemAt(index).height * 1.2

            property alias scaleAnim: scaleAnim

            NumberAnimation {
                id: scaleAnim;
                target: circle;
                property: "scale";
                from: 0; to: circle.scale;
                duration: 700
            }
        }
    }
}
