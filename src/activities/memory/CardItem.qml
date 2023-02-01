/* gcompris - CardItem.qml
 *
 * SPDX-FileCopyrightText: 2014 JB BUTET <ashashiwa@gmail.com>
 * SPDX-FileCopyrightText: 2023 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "memory.js" as Activity

Flipable {
    id: card

    property var pairData
    property bool isBack: true
    property bool isShown: false
    property bool isFound: false

    property bool tuxTurn

    property GCAudio audioVoices
    property GCSfx audioEffects

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        timer.stop();
        animationTimer.stop();
    }

    onIsFoundChanged: {
        opacity = 0
        timer.start()
    }

    Timer {
        id: timer
        interval: 100
        running: false
        repeat: false
        onTriggered: particles.burst(50)
    }

    ParticleSystemStarLoader {
        id: particles
        clip: false
    }

    Timer {
        id: animationTimer
        interval: 1500
        running: false
        repeat: false
        onTriggered: selectionReady()
    }

    back: Image {
        source: card.pairData.emptyCard
        width: parent.width
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        anchors.fill: parent
        Image {
            id: contentImage
            source: card.pairData.image
            width: parent.paintedWidth * 0.9
            height: parent.paintedHeight * 0.9
            sourceSize.width: width
            sourceSize.height: height
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }
        GCText {
            anchors.centerIn: parent
            width: parent.paintedWidth * 0.9
            height: parent.paintedHeight * 0.9
            fontSizeMode: Text.Fit
            fontSize: 64
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#202020"
            font.bold: true
            text: card.pairData.text
        }
        // repeater for memory-enumerate
        Repeater {
            model: card.pairData.repeaterModel
            Image {
                source: modelData.itemSource
                x: contentImage.x + contentImage.width * modelData.itemX
                y: contentImage.y + contentImage.height * modelData.itemY
                width: contentImage.width * modelData.itemSize
                height: width
                sourceSize.width: width
                rotation: modelData.itemRotation
            }
        }
    }

    // Warning front and back property are reversed. Could not find
    // a way to display back at start time without this trick
    front: Image {
        fillMode: Image.PreserveAspectFit
        source: card.pairData.back
        sourceSize.width: parent.width
        anchors.centerIn: parent
        anchors.fill: parent
    }

    transform: Rotation {
        id: rotation
        origin.x: card.width / 2
        origin.y: card.height / 2
        axis.x: 0; axis.y: 1; axis.z: 0
        angle: 0
    }

    transitions: Transition {
        SequentialAnimation {
            NumberAnimation { target: rotation; property: "angle"; duration: 750 }
            ScriptAction { script: {
                if(card.pairData.sound && !card.isBack)
                    audioVoices.play(card.pairData.sound)
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: card.isBack && !card.isFound && !card.tuxTurn && items.selectionCount < 2
        onClicked: selected()
    }

    function selected() {
        card.isBack = false
        card.isShown = true
        items.selectionCount++
        animationTimer.start()
        audioEffects.play(Activity.url + "card_flip.wav")
    }

    function selectionReady() {
        var pairs = Activity.addPlayQueue(card)
        var win = Activity.reverseCardsIfNeeded()
        if(tuxTurn && win || tuxTurn && !pairs)
            Activity.tuxPlay()
    }

    Behavior on opacity { NumberAnimation { duration: 1000 } }

    states: [
        State {
            name: "front"
            PropertyChanges { target: rotation; angle: 180 }
            when: !card.isBack
        }
    ]
}
