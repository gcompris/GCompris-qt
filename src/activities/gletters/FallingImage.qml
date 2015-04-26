/* GCompris - Word.qml
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
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

    width: image.width
    height: image.height

    /// index into text.split("") where next typed match should occur
    property int unmatchedIndex: 0;
    property string text
    property alias image: image.source;
    property bool wonState: false

    signal won

    onWon: {
        wonState = true
        particle.burst(30)
        dropShadow.opacity = 0
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

    Image {
        id: image
        // FIXME, the size should be passed from the caller
        sourceSize.height: 106 * ApplicationInfo.ratio

        ParticleSystemStarLoader {
            id: particle
            clip: false
        }
    }

    DropShadow {
        id: dropShadow
        anchors.fill: image
        cached: false
        horizontalOffset: 1
        verticalOffset: 1
        radius: 3.0
        samples: 16
        color: "#422a2a2a"
        source: image
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
