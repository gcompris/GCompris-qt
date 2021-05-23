/* gcompris - CardItem.qml
 *
 * SPDX-FileCopyrightText: 2014 JB BUTET <ashashiwa@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
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
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        anchors.fill: parent
        Image {
            id: contentImage
            source: card.pairData.image
            width: parent.paintedWidth * 0.9
            height: parent.paintedHeight * 0.9
            sourceSize.width: contentImage.width
            sourceSize.height: contentImage.height
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
            color: "black"
            font.bold: true
            style: Text.Outline
            styleColor: "white"
            text: card.pairData.text
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
        NumberAnimation { target: rotation; property: "angle"; duration: 750 }
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

        if (card.pairData.sound) {
            audioVoices.play(card.pairData.sound)
        }
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
