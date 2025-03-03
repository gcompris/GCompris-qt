/* GCompris - Word.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Effects
import core 1.0

import "../../core"
import "gletters.js" as Activity

Item {
    id: word

    width: image.width
    height: image.height

    /// index into text.split("") where next typed match should occur
    property int unmatchedIndex: 0;
    property string text
    property alias image: image.source;
    property bool wonState: false
    required property double imageSize

    signal won

    onWon: {
        wonState = true
        particle.burst(30)
        dropShadow.shadowOpacity = 0
        fadeout.restart();
    }

    Component.onCompleted: {
        // make sure our word is completely visible
        if (x + width >= parent.width)
            x = parent.width - width;
    }

    PropertyAnimation {
        id: fadeout
        target: word;
        property: "opacity"
        to: 0
        duration: 1000
        onStopped: Activity.deleteWord(word);
    }

    function checkMatch(c): bool
    {
        // We are in the ending animation
        if (wonState)
            return

        var chars = text.split("");
        if (chars[unmatchedIndex] === c) {
            unmatchedIndex++;
            return true;
        } else {
            unmatchedIndex = 0;
            return false;
        }
    }

    function startMoving(dur: int)
    {
        down.duration = dur;
        down.restart();
    }

    function isCompleted(): bool
    {
        return (unmatchedIndex === text.length);
    }

    Image {
        id: image
        sourceSize.height: word.imageSize

        ParticleSystemStarLoader {
            id: particle
            clip: false
        }
    }

    MultiEffect {
        id: dropShadow
        anchors.fill: image
        source: image
        shadowEnabled: true
        shadowBlur: 1.0
        blurMax: 6
        shadowHorizontalOffset: 1
        shadowVerticalOffset: 1
        shadowOpacity: 0.3
    }

    NumberAnimation {
        id: down
        target: word
        property: "y"
        to: parent.height
        duration: 10000

        onStopped: {
            Activity.audioCrashPlay();
            Activity.appendRandomWord(word.text)
            Activity.deleteWord(word);
        }
    }
}
