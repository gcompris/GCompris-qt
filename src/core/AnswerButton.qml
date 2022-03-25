/*
  Copied in GCompris from Touch'n'learn
    Touch'n'learn - Fun and easy mobile lessons for kids
    SPDX-FileCopyrightText: 2010, 2011 Alessandro Portale <alessandro@casaportale.de>
    http://touchandlearn.sourceforge.net / https://github.com/aportale/qtouchandlearn/blob/master/src/qml/touchandlearn/AnswerButton.qml
    This file is part of Touch'n'learn

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0

/**
 * A QML component to display an answer button.
 *
 * AnswerButton consists of a text (@ref textLabel)
 * and animations on pressed.
 * Mostly used to present more than one option to select from
 * consisting of both good and bad answers.
 *
 * @inherit QtQuick.Item
 */
Item {
    id: button

    /**
     * type:string
     * Text to display on the button.
     *
     * @sa label.text
     */
    property string textLabel

    /**
     * type:boolean
     *
     * Set to true when this element contains good answer.
     */
    property bool isCorrectAnswer: false

    /**
     * type:color
     *
     * Color of the container in normal state.
     */
    property color normalStateColor: "#fff"

    /**
     * type:color
     *
     * Color of the container on good answer selection.
     */
    property color correctStateColor: "#09f"

    /**
     * type:color
     *
     * Color of the container on bad answer selection.
     */
    property color wrongStateColor: "#f66"

    /**
     * type: bool
     *
     * Set the external conditions to this variable during which the clicks on button are to be blocked.
     */
    property bool blockAllButtonClicks: false

    /**
     * type:bool
     *
     * This variable holds the overall events during which the clicks on button will be blocked.
     */
    readonly property bool blockClicks: correctAnswerAnimation.running || wrongAnswerAnimation.running || blockAllButtonClicks

    /**
     * type:int
     *
     * Amplitude of the shake animation on wrong answer selection.
     */
    property int wrongAnswerShakeAmplitudeCalc: width * 0.2

    /**
     * type:int
     *
     * Minimum amplitude of the shake animation on wrong answer selection.
     */
    property int wrongAnswerShakeAmplitudeMin: 45

    /**
     * type:int
     *
     * Amplitude of the shake animation on wrong answer.
     * Selects min. from wrongAnswerShakeAmplitudeMin && wrongAnswerShakeAmplitudeCalc.
     */
    property int wrongAnswerShakeAmplitude: wrongAnswerShakeAmplitudeCalc < wrongAnswerShakeAmplitudeMin ? wrongAnswerShakeAmplitudeMin : wrongAnswerShakeAmplitudeCalc

    // If you want the sound effects just pass the audioEffects
    property GCSfx audioEffects

    /**
     * Emitted after button is pressed as a good answer.
     *
     * Triggered at the end of correctAnswerAnimation.
     */
    signal correctlyPressed

    /**
     * Emitted after button is pressed as a bad answer.
     *
     * Triggered at the end of wrongAnswerAnimation.
     */
    signal incorrectlyPressed

    /**
     * Emitted when answer button is clicked.
     */
    signal pressed
    onPressed: {
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
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 0
        horizontalAlignment: Text.AlignHCenter
        width: button.width
        fontSizeMode: Text.Fit
        font.bold: true
        text: textLabel
        color: "#373737"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !blockClicks
        onPressed: button.pressed()
    }

    SequentialAnimation {
        id: correctAnswerAnimation
        onStopped: correctlyPressed()
        ScriptAction {
            script: {
                if (typeof(feedback) === "object")
                    feedback.playCorrectSound();
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
    }

    SequentialAnimation {
        id: wrongAnswerAnimation
        onStopped: incorrectlyPressed()
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
                    property: "anchors.horizontalCenterOffset"
                    to: -wrongAnswerShakeAmplitude
                    easing.type: Easing.InCubic
                    duration: 120
                }
                PropertyAnimation {
                    target: label
                    property: "anchors.horizontalCenterOffset"
                    to: wrongAnswerShakeAmplitude
                    easing.type: Easing.InOutCubic
                    duration: 220
                }
                PropertyAnimation {
                    target: label
                    property: "anchors.horizontalCenterOffset"
                    to: 0
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
    }
}
