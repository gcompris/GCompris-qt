/*
  Copyed in GCompris from Touch'n'learn

    Touch'n'learn - Fun and easy mobile lessons for kids
    Copyright (C) 2010, 2011 by Alessandro Portale
    http://touchandlearn.sourceforge.net

    This file is part of Touch'n'learn

    Touch'n'learn is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Touch'n'learn is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Touch'n'learn; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
*/

import QtQuick 2.2
import QtQuick.Particles 2.0
import GCompris 1.0

Item {
    id: button

    property string textLabel
    property bool isCorrectAnswer: false

    property color normalStateColor: "#fff"
    property color correctStateColor: "#ffa"
    property color wrongStateColor: "#f66"
    property bool blockClicks: false

    property int wrongAnswerShakeAmplitudeCalc: width * 0.2
    property int wrongAnswerShakeAmplitudeMin: 45
    property int wrongAnswerShakeAmplitude: wrongAnswerShakeAmplitudeCalc < wrongAnswerShakeAmplitudeMin ? wrongAnswerShakeAmplitudeMin : wrongAnswerShakeAmplitudeCalc

    signal correctlyPressed
    signal incorrectlyPressed

    Rectangle {
        id: rect
        anchors.fill: parent
        color: normalStateColor
        opacity: 0.5
    }
    ParticleSystem {
        id: particles
        anchors.fill: parent
        Emitter {
            id: clickedEmitter
            anchors.fill: parent
            emitRate: 20
            lifeSpan: 800
            lifeSpanVariation: 400
            sizeVariation: 12
            size: 24 * ApplicationInfo.ratio
            system: particles
            velocity: PointDirection {xVariation: 100; yVariation: 100;}
            acceleration: PointDirection {xVariation: 50; yVariation: 50;}
            velocityFromMovement: 50
            enabled: false
        }
        ImageParticle {
            source: "qrc:/gcompris/src/core/resource/star.png"
            sizeTable: "qrc:/gcompris/src/core/resource/sizeTable.png"
            anchors.fill: parent
            color: "white"
            blueVariation: 0.5
            greenVariation: 0.5
            redVariation: 0.5
            clip: true
            smooth: false
            autoRotation: true
        }
    }
    Image {
        source: "qrc:/gcompris/src/core/resource/button.svgz"
        sourceSize { height: parent.height; width: parent.width }
        width: sourceSize.width
        height: sourceSize.height
        smooth: false
    }
    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        // We need to manually horizonally center the text, because in wrongAnswerAnimation,
        // the x of the text is changed, which would not work if we use an anchor layout.
        property int horizontallyCenteredX: (button.width - width) >> 1;
        x: horizontallyCenteredX;
        font.pixelSize: parent.height * 0.33
        text: textLabel
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            if (!blockClicks) {
                if (isCorrectAnswer)
                    correctAnswerAnimation.start();
                else
                    wrongAnswerAnimation.start();
            }
        }
    }

    SequentialAnimation {
        id: correctAnswerAnimation
        ScriptAction {
            script: {
                if (typeof(feedback) === "object")
                    feedback.playCorrectSound();
                blockClicks = true;
                if (typeof(particles) === "object")
                    clickedEmitter.burst(40);
            }
        }
        PropertyAction {
            target: rect
            property: "color"
            value: correctStateColor
        }
        PropertyAnimation {
            target: rect
            property: "color"
            to: normalStateColor
            duration: 700
        }
        PauseAnimation {
            duration: 300 // Wait for particles to finish
        }
        ScriptAction {
            script: {
                blockClicks = false;
                correctlyPressed();
            }
        }
    }

    SequentialAnimation {
        id: wrongAnswerAnimation
        ParallelAnimation {
            SequentialAnimation {
                PropertyAction {
                    target: rect
                    property: "color"
                    value: wrongStateColor
                }
                ScriptAction {
                    script: {
                        if (typeof(feedback) === "object")
                            feedback.playIncorrectSound();
                    }
                }
                PropertyAnimation {
                    target: rect
                    property: "color"
                    to: normalStateColor
                    duration: 600
                }
            }
            SequentialAnimation {
                PropertyAnimation {
                    target: label
                    property: "x"
                    to: label.horizontallyCenteredX - wrongAnswerShakeAmplitude
                    easing.type: Easing.InCubic
                    duration: 120
                }
                PropertyAnimation {
                    target: label
                    property: "x"
                    to: label.horizontallyCenteredX + wrongAnswerShakeAmplitude
                    easing.type: Easing.InOutCubic
                    duration: 220
                }
                PropertyAnimation {
                    target: label
                    property: "x"
                    to: label.horizontallyCenteredX
                    easing { type: Easing.OutBack; overshoot: 3 }
                    duration: 180
                }
            }
        }
        PropertyAnimation {
            target: rect
            property: "color"
            to: normalStateColor
            duration: 450
        }
        ScriptAction {
            script: {
                incorrectlyPressed();
            }
        }
    }
}
