/* GCompris - Staff.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "piano_composition.js" as Activity

Item {
    id: staff

    property Item main: activity.main

    property int verticalDistanceBetweenLines: height / nbLines // todo width/nbLines * smth
    
    property string clef
    readonly property real clefImageWidth: clefImage.width

    width: 400
    height: 100
    // Stave
    readonly property int nbLines: 5

    property bool lastPartition: false

    property bool isMetronomeDisplayed: false
    property bool showMetronome: false

    Image {
        id: clefImage
        source: clef ? "qrc:/gcompris/src/activities/piano_composition/resource/" + clef + "Clef.svg" : ""
        sourceSize.width: (nbLines - 2) * verticalDistanceBetweenLines
    }

    Repeater {
        model: nbLines
        Rectangle {
            width: staff.width
            height: 5
            border.width: 5
            color: "black"
            x: 0
            y: index * verticalDistanceBetweenLines
        }
    }

    Rectangle {
        width: 5
        border.width: 5
        height: (nbLines - 1) * verticalDistanceBetweenLines + 5
        color: "black"
        x: staff.width
        y: 0
    }

    // End of partition line
    Rectangle {
        width: 5
        border.width: 5
        height: (nbLines - 1) * verticalDistanceBetweenLines + 5
        visible: lastPartition
        color: "black"
        x: staff.width - 10
        y: 0
    }

    Rectangle {
        id: metronome
        width: 5
        border.width: 10
        height: (nbLines - 1) * verticalDistanceBetweenLines + 5
        visible: isMetronomeDisplayed && showMetronome
        color: "red"
        y: 0
        Behavior on x {
            SmoothedAnimation {
                id: metronomeAnimation
                duration: -1
           }
        }
    }

    //These functions can be adjusted when play_rhythm will be started.
    property var mDuration
    function initMetronome() {
        var staffDuration = 0;
        for(var v = 0 ; v < notes.count ; ++ v) {
            staffDuration += notes.get(v).mDuration;
        }
        metronomeAnimation.velocity = 1;
        mDuration = staffDuration;
        metronome.x = staff.width;
        print("total duration " + staffDuration)
        print("total distance " + metronome.x)
    }

    function playNote(noteId) {
        metronomeAnimation.velocity = staff.width * 1000 / (notes.get(noteId).mDuration * notes.count);
        print("velocity " + metronomeAnimation.velocity)
    }
}
