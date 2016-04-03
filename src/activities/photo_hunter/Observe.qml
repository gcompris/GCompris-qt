/* GCompris - photo_hunter.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
 *
 * Authors:
 *   <Marc Le Douarain> (GTK+ version)
 *   Stefan Toncu <stefan.toncu@cti.pub.ro> (Qt Quick port)
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
import "photo_hunter.js" as Activity

Image {
    id: card

    sourceSize.width: background.vert ? undefined : (background.width - 30) / 2
    sourceSize.height: background.vert ? (background.height - background.barHeight - 40) /2 :
                                         background.height - background.barHeight - 30

    property GCAudio audioEffects: activity.audioEffects
    property alias repeater: repeater
    property int good: 0

    Image {
        id: wrong
        source: Activity.url + "images/wrong.svg"
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
            property alias scaleAnim: scaleAnim
            property double widthScale
            property double heightScale

            source: Activity.url + "images/circle.svg"
            width: card.width / 10 * widthScale
            height: card.height / 10 * heightScale

            opacity: 1

            x: modelData[0] * card.width / 1200
            y: modelData[1] * card.height / 1700


            //instead of scale, there should be an animation for both width and height
            //-> so it will be able to draw an elipse if needed
            NumberAnimation {
                id: scaleAnim;
                target: photo;
                property: "scale";
                from: 0; to: photo.scale;
                duration: 700
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
                ParticleSystemStarLoader
                {
                    id: particles
                    clip: false
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    img1.repeater.itemAt(index).particleLoader.active = active
                    img1.repeater.itemAt(index).particleLoader.item.burst(40)
                    img2.repeater.itemAt(index).particleLoader.active = active
                    img2.repeater.itemAt(index).particleLoader.item.burst(40)
                    if (img1.repeater.itemAt(index).opacity === 0 &&
                            img2.repeater.itemAt(index).opacity === 0) {
                        audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav')
                        img1.repeater.itemAt(index).opacity = 1
                        img2.repeater.itemAt(index).opacity = 1
                        good++
                        background.checkAnswer()
                        img1.repeater.itemAt(index).scaleAnim.start()
                        img2.repeater.itemAt(index).scaleAnim.start()
                    }
                }
            }
        }
    }
}
