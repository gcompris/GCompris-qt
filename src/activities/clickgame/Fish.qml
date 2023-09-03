/* GCompris - Fish.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (animation refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Particles 2.12
import "clickgame.js" as Activity
import "../../core"
import GCompris 1.0

AnimatedSprite {
    id: fish
    property Item activity
    property Item background
    property Item bar
    property int duration: 5000
    property int minY: Activity.items.score.y + Activity.items.score.height
    property int maxY: bar.y - fish.height
    property int minX: fish.width * -1.2
    property int maxX: background.width + fish.width * 0.2
    property real xSpeed: 10
    property real ySpeed: 1
    frameRate: 2
    interpolate: true

    signal animTrigger

    Component.onCompleted: {
        background.animTrigger.connect(animTrigger)
    }

    transform: Rotation {
        id: rotate; origin.x: width / 2; origin.y: 0; axis { x: 0; y: 1; z: 0 } angle: 0
    }

    onAnimTrigger: {
        if(x >= maxX) {
            rotate.angle = 180;
            fish.xSpeed *= -1;
            x = maxX
        } else if(x <= minX) {
            rotate.angle = 0;
            fish.xSpeed *= -1;
            x = minX
        }
        if(y >= maxY) {
            ySpeed *= -1;
            y = maxY;
        }else if(y <= minY) {
            ySpeed *= -1;
            y = minY;
        }
        if(Activity.items.currentLevel > 0) {
            fish.y += fish.ySpeed;
        }
        fish.x += fish.xSpeed
    }

    Behavior on opacity { PropertyAnimation { duration: 500 } }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            background.animTrigger.disconnect(animTrigger)
            parent.opacity = 0
            enabled = false
            activity.audioEffects.play("qrc:/gcompris/src/activities/clickgame/resource/drip.wav")
            Activity.fishKilled()
            particles.burst(40);
        }
    }

    Loader {
        id: bubbleEffect
        anchors.fill: parent
        active: ApplicationInfo.hasShader
        sourceComponent: ParticleSystem {
            anchors.fill: parent
            Emitter {
                x: parent.x + parent.width * 0.8
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
                    x: -20
                    xVariation: 10
                    y: -20
                    yVariation: 10
                }
                size: 16
                sizeVariation: 8
            }

            ImageParticle {
                source: "qrc:/gcompris/src/activities/clickgame/resource/bubble.svg"
            }
        }
    }

    ParticleSystemStarLoader {
        id: particles
        clip: false
    }
}
