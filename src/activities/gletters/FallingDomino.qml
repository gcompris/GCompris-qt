/* GCompris - Word.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
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
import QtQuick 2.0
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "gletters.js" as Activity

Item {
    id: word

    width: domino.width
    height: domino.height

    /// index into text.split("") where next typed match should occur
    property int unmatchedIndex: 0;
    property string text
    property variant dominoValues
    property bool wonState: false

    signal won

    onWon: {
        wonState = true
        particle.emitter.burst(30)
        fadeout.restart();
    }

    Component.onCompleted: {
        // make sure our word is completely visible
        if (x + width > parent.width)
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

    function checkMatch(c)
    {
        // We are in the ending animation
        if (wonState)
            return

        var chars = text.split("");
        if (chars[unmatchedIndex] == c) {
            unmatchedIndex++;
            return true;
        } else {
            unmatchedIndex = 0;
            return false;
        }
    }

    function startMoving(dur)
    {
        down.duration = dur;
        down.restart();
    }

    function isCompleted()
    {
        return (unmatchedIndex === text.length);
    }

    Domino {
        id: domino
        width: 120 * ApplicationInfo.ratio
        height: width / 2
        visible: dominoValues.length != 0
        value1: dominoValues[0]
        value2: dominoValues[1]
        isClickable: false

        ParticleSystemStar {
            id: particle
            clip: false
        }
    }

    NumberAnimation {
        id: down
        target: word
        property: "y"
        to: parent.height
        duration: 10000

        onStopped: {
            Activity.audioCrashPlay();
            Activity.deleteWord(word);
        }
    }
}
