/* GCompris - FallingDomino.qml
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
import QtQuick
import core 1.0

import "../../core"
import "gletters.js" as Activity

Item {
    id: word

    width: domino.width
    height: domino.height

    /// index into text.split("") where next typed match should occur
    property int unmatchedIndex: 0;
    property string text
    property list<int> dominoValues
    property bool wonState: false
    property string mode: "dot"

    signal won

    onWon: {
        wonState = true
        particle.burst(30)
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

    function checkMatch(c: string): bool
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

    Domino {
        id: domino
        width: 120 * ApplicationInfo.ratio
        mode: word.mode
        visible: word.dominoValues.length != 0
        value1: word.dominoValues[0]
        value2: word.dominoValues[1]
        isClickable: false

        ParticleSystemStarLoader {
            id: particle
            clip: false
        }
    }

    NumberAnimation {
        id: down
        target: word
        property: "y"
        to: word.parent.height
        duration: 10000

        onStopped: {
            Activity.audioCrashPlay();
            Activity.appendRandomWord(word.text)
            Activity.deleteWord(word);
        }
    }
}
