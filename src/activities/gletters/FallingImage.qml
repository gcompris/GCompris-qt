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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
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
    property string imageText
    property alias image: image.source;
    property bool wonState: false
    property int mode: 1;
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

        var chars = imageText.split("");
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
        return (unmatchedIndex === imageText.length);
    }

    function getImageText(imageText) {
        if (mode == 1) {
            return imageText;
        } else if (mode == 2) {
            if (imageText == "1")
                return "I";
            else if (imageText == "2")
                return "II";

            else if (imageText == "3")
                return "III";

            else if (imageText == "4")
                return "IV";

            else if (imageText == "5")
                return "V";

            else if (imageText == "6")
                return "VI";

            else if (imageText == "7")
                return "VII";

            else if (imageText == "8")
                return "VIII";

            else if (imageText == "9")
                return "IX";
        }
    }

    Image {
        id: image
        // FIXME, the size should be passed from the caller
        sourceSize.height: 106 * ApplicationInfo.ratio

        GCText {
            id: numberText
            visible: ((mode == 1 || mode == 2) ? true : false)
            y: 0
            fontSize: 30

            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            anchors.margins: ApplicationInfo.ratio * 5
            text: getImageText(imageText)
        }

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
            Activity.appendRandomWord(word.imageText)
            Activity.deleteWord(word);
        }
    }
}
