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

    width: wordText.width
    height: wordText.height

    /// index into text.split("") where next typed match should occur
    property int unmatchedIndex: 0;
    property alias text: wordText.text;
    property bool wonState: false

    signal won

    onWon: {
        wonState = true
        particle.emitter.burst(30)
        dropShadow.opacity = 0
        fadeout.restart();
    }

    Component.onCompleted: {
        // make sure our word is completely visible
        if (x + width > parent.width)
            x = parent.width - width;
    }

    onUnmatchedIndexChanged: {
        if (unmatchedIndex <= 0)
            highlightedWordText.text = "";
        else if (wordText.text.length > 0 && wordText.text.length >= unmatchedIndex) {
            highlightedWordText.text = wordText.text.substring(0, unmatchedIndex);
            /* Need to add the ZERO WIDTH JOINER to force joined char in Arabic and
             * Hangul: http://en.wikipedia.org/wiki/Zero-width_joiner
             *
             * FIXME: this works only on desktop systems, on android this
             * shifts the typed word a few pixels down. */
            if (!ApplicationInfo.isMobile)
                highlightedWordText.text += "\u200C";
        }
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

    GCText {
        id: wordText

        text: ""
        font.pointSize: 35
        font.bold: true
        color: "navy"
        style: Text.Outline
        styleColor: "white"

        ParticleSystemStar {
            id: particle
            clip: false
        }

        GCText {
            id: highlightedWordText

            anchors.fill: parent

            text: ""
            font.pointSize: parent.font.pointSize
            font.bold: parent.font.pointSize
            color: "red"
            style: Text.Outline
            styleColor: "white"
        }
    }

    DropShadow {
        id: dropShadow
        anchors.fill: wordText
        cached: true
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 16
        color: "#80000000"
        source: wordText
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
