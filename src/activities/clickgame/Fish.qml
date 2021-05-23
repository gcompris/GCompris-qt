/* GCompris - Fish.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import QtQuick.Particles 2.0
import "clickgame.js" as Activity
import "../../core"
import GCompris 1.0

AnimatedSprite {
    id: fish
    property Item activity
    property Item background
    property Item bar
    property real targetX // The x target of the fish
    property int duration: 5000
    frameRate: 2
    interpolate: true

    Component.onCompleted: {
        targetX = background.width - fish.width
        x = targetX
    }

    transform: Rotation {
        id: rotate; origin.x: width / 2; origin.y: 0; axis { x: 0; y: 1; z: 0 } angle: 0
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
        var minY = Activity.items.score.y + Activity.items.score.height
        var maxY = bar.y - fish.height
        if( (x > background.width - fish.width && rotate.angle == 0) ||
            (x == targetX && rotate.angle == 0) ) {
            rotateLeftAnimation.start()
            targetX = 0
            x = targetX
            var barHeight = ApplicationSettings.isBarHidden ? bar.height / 2 : bar.height
            y = Activity.currentLevel > 0
                    ? (Math.random() * (maxY - minY + 1)) + minY
                    : y
        } else if(x == 0 && rotate.angle == 180) {
            rotateRightAnimation.start()
            targetX = background.width - fish.width
            x = targetX
       }
    }
    Behavior on x { PropertyAnimation { duration: fish.duration } }
    Behavior on y { PropertyAnimation { duration: fish.duration } }
    Behavior on opacity { PropertyAnimation { duration: 500 } }

    MouseArea {
        anchors.fill: parent
        onClicked: {
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
