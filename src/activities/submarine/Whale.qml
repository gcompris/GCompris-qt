/* GCompris - Whale.qml
 *
 * Copyright (C) 2017 RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import QtQuick.Particles 2.0
import Box2D 2.0
import QtGraphicalEffects 1.0
import GCompris 1.0

Image {
    id: whale
    source: isHit ? url + "whale-hit.svg" : url + "whale.svg"

    width: submarineImage.width * 1.2
    sourceSize.width: whale.width
    fillMode: Image.PreserveAspectFit

    property bool isHit: false

    function hit() {
        isHit = true
    }

    function reset() {
        isHit = false
        x = rightLimit
    }

    property bool movingLeft: true
    property real leftLimit
    property real rightLimit

    transform: Rotation {
        id: rotate;
        origin.x: whale.width / 2;
        origin.y: 0;
        axis { x: 0; y: 1; z: 0 } angle: 0
    }

    SequentialAnimation {
        id: rotateLeftAnimation
        loops: 1
        PropertyAnimation {
            target: rotate
            properties: "angle"
            from: 0
            to: 180
            duration: 500
        }
    }

    SequentialAnimation {
        id: rotateRightAnimation
        loops: 1
        PropertyAnimation {
            target: rotate
            properties: "angle"
            from: 180
            to: 0
            duration: 500
        }
    }

    onXChanged: {
        if (x <= leftLimit) {
            rotateLeftAnimation.start()
            whale.movingLeft = false
        } else if (x >= rightLimit) {
            rotateRightAnimation.start()
            whale.movingLeft = true
        }
    }

    Loader {
        id: bubbleEffect
        anchors.fill: parent
        active: ApplicationInfo.hasShader
        sourceComponent: ParticleSystem {
            anchors.fill: parent
            Emitter {
                x: parent.x
                y: parent.y + parent.height / 2
                width: 1
                height: 1
                emitRate: 0.5
                lifeSpan: 1000
                lifeSpanVariation: 2500
                acceleration: PointDirection {
                    x: -10
                    xVariation: 10
                    y: -20
                    yVariation: 10
                }
                velocity: PointDirection {
                    x: 20
                    xVariation: 10
                    y: -20
                    yVariation: 10
                }
                size: 12
                sizeVariation: 8
            }

            ImageParticle {
                source: "qrc:/gcompris/src/activities/clickgame/resource/bubble.png"
            }
        }
    }

    Body {
        target: whale
        bodyType: Body.Dynamic
        sleepingAllowed: true
        fixedRotation: true
        linearDamping: 0
        linearVelocity: isHit ? Qt.point(0,0) : Qt.point( (whale.movingLeft ? -1 : 1) , 0)

        fixtures: Box {
            width: whale.width * 0.7
            height: whale.height * 0.8
            y: whale.height * 0.1
            categories: items.whaleCategory
            collidesWith: whale.visible ? items.submarineCategory : Fixture.None
            density: 1
            friction: 0
            restitution: 0
        }
    }
}
