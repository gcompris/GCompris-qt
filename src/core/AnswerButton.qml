/*
  Copyed in GCompris from Touch'n'learn

    Touch'n'learn - Fun and easy mobile lessons for kids
    Copyright (C) 2010, 2011 by Alessandro Portale <alessandro@casaportale.de>
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

import QtQuick 2.6
import GCompris 1.0

Item {
    id: button

    property string textLabel
    property bool isCorrectAnswer: false

    property color normalStateColor: "#fff"
    property color correctStateColor: "#09f"
    property color wrongStateColor: "#f66"
    property bool blockClicks: false

    property int wrongAnswerShakeAmplitudeCalc: width * 0.2
    property int wrongAnswerShakeAmplitudeMin: 45
    property int wrongAnswerShakeAmplitude: wrongAnswerShakeAmplitudeCalc < wrongAnswerShakeAmplitudeMin ? wrongAnswerShakeAmplitudeMin : wrongAnswerShakeAmplitudeCalc

    // If you want the sound effects just pass the audioEffects
    property GCAudio audioEffects

    signal correctlyPressed
    signal incorrectlyPressed

    signal pressed
    onPressed: {
        if (!blockClicks) {
            if (isCorrectAnswer) {
                if(audioEffects)
                    audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
                correctAnswerAnimation.start();
            } else {
                if(audioEffects)
                    audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                wrongAnswerAnimation.start();
            }
        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: normalStateColor
        opacity: 0.5
    }
    ParticleSystemStarLoader {
        id: particles
    }
    Image {
        source: "qrc:/gcompris/src/core/resource/button.svg"
        sourceSize { height: parent.height; width: parent.width }
        width: sourceSize.width
        height: sourceSize.height
        smooth: false
    }
    GCText {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        // We need to manually horizonally center the text, because in wrongAnswerAnimation,
        // the x of the text is changed, which would not work if we use an anchor layout.
        property int horizontallyCenteredX: (button.width - contentWidth) >> 1;
        width: button.width
        x: horizontallyCenteredX;
        fontSizeMode: Text.Fit
        font.bold: true
        text: textLabel
        color: "#373737"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: button.pressed()
    }

    SequentialAnimation {
        id: correctAnswerAnimation
        ScriptAction {
            script: {
                if (typeof(feedback) === "object")
                    feedback.playCorrectSound();
                blockClicks = true;
                if (typeof(particles) === "object")
                    particles.burst(40);
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
