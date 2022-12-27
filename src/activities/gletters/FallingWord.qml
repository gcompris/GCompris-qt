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
    property string mode

    signal won

    onWon: {
        wonState = true
        particle.burst(30)
        dropShadow.opacity = 0
        fadeout.restart();
    }

    Component.onCompleted: {
        // make sure our word is completely visible
        if (x + width >= parent.width)
            x = parent.width - width;
    }

    onUnmatchedIndexChanged: {
        if (unmatchedIndex <= 0)
            highlightedWordText.text = "";
        else if (wordText.text.length > 0 && wordText.text.length >= unmatchedIndex) {
            highlightedWordText.text = wordText.text.substring(0, unmatchedIndex);
            /* Need to add the ZERO WIDTH JOINER to force joined char in Arabic and
             * Hangul: https://en.wikipedia.org/wiki/Zero-width_joiner
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
        if (chars[unmatchedIndex] === c) {
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
        fontSize: 35
        font.bold: true
        color: "navy"
        style: Text.Outline
        styleColor: "white"

        ParticleSystemStarLoader {
            id: particle
            clip: false
        }

        GCText {
            id: highlightedWordText
            anchors.fill: parent
            text: ""
            fontSize: parent.fontSize
            font.bold: parent.font.bold
            color: "red"
            style: Text.Outline
            styleColor: "white"
        }
    }

    DropShadow {
        id: dropShadow
        anchors.fill: wordText
        cached: false
        horizontalOffset: 1
        verticalOffset: 1
        radius: 3.0
        samples: 16
        color: "#422a2a2a"
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
            Activity.appendRandomWord(word.text)
            Activity.deleteWord(word);
        }
    }
}
