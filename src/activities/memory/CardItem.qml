/* gcompris - CardItem.qml
 *
 * Copyright (C) 2014 JB BUTET <ashashiwa@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
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
import "memory.js" as Activity

Flipable {
    id: card

    property variant pairData
    property bool isBack: true
    property bool isShown: false
    property bool isFound: false

    property bool tuxTurn

    property GCAudio audioVoices
    property GCAudio audioEffects

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
        interval: items.tuxTurn ? 1500 : 750
        running: false
        repeat: false
        onTriggered: selectionReady()
    }

    back: Image {
        source: card.pairData.emptyCard
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        Image {
            source: card.pairData.image
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }
        GCText {
            anchors.centerIn: parent
            fontSize: largeSize
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
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: card.pairData.back
        anchors.centerIn: parent
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

    states : [
        State {
            name: "front"
            PropertyChanges { target: rotation; angle: 180 }
            when: !card.isBack
        }
    ]
}
