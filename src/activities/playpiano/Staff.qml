/* GCompris - playpiano.qml
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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

Item {
    id: staff
    property int verticalDistanceBetweenLines: 20 // todo width/nbLines * smth
    
    property string clef

    width: 400
    // Stave
    property int nbLines: 5

    property bool lastPartition: false

    property alias showMetronome: metronome.visible
    property alias notes: notes

    property int nbMaxNotesPerStaff

    Image {
        id: clefImage
        source: clef ? "qrc:/gcompris/src/activities/playpiano/resource/"+clef+"Clef.svg" : ""
        sourceSize.width: (nbLines-2)*verticalDistanceBetweenLines
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
        height: (nbLines-1) * verticalDistanceBetweenLines+5
        color: "black"
        x: staff.width
        y: 0
    }
    // end of partition line
    Rectangle {
        width: 5
        border.width: 5
        height: (nbLines-1) * verticalDistanceBetweenLines+5
        visible: lastPartition
        color: "black"
        x: staff.width-10
        y: 0
    }

    ListModel {
        id: notes
    }

    Rectangle {
        id: metronome
        width: 5
        border.width: 10
        height: (nbLines-1) * verticalDistanceBetweenLines+5
        visible: lastPartition
        color: "red"
        x: clefImage.width-width/2
        y: 0
        Behavior on x {
            SmoothedAnimation {
                id: metronomeAnimation
                duration: -1
            }
        }
    }

    property var mDuration
    function initMetronome() {
        var duration = 0;
        for(var v = 0 ; v < notes.count ; ++ v) {
            duration += notes.get(v).mDuration;
        }
        metronomeAnimation.velocity = 1;
        mDuration = duration;
        metronome.x = staff.width;
        print("duration " + duration)
    }

    function playNote(noteId) {
        metronomeAnimation.velocity = staff.width * 1000 / (notes.get(noteId).mDuration * notes.count);
        print("velocity " + metronomeAnimation.velocity)
    }

    function eraseAllNotes() {
        notes.clear();
    }

    property int noteWidth: 60
    Row {
        id: notesRow
        x: clefImage.width-noteWidth/2
        Repeater {
            model: notes
            Note {
                value: mValue
                type: mType
                blackType: mBlackType
                width: noteWidth
                //(nbLines-3)*verticalDistanceBetweenLines == bottom line
                y: {
                    if(mValue > 0) {
                        return (nbLines-3)*verticalDistanceBetweenLines - (parseInt(mValue)-1)*verticalDistanceBetweenLines/2
                    }
                    else if(mValue >= -2)
                        return (nbLines-3)*verticalDistanceBetweenLines - (Math.abs(parseInt(mValue))-1)*verticalDistanceBetweenLines/2
                    else
                        return (nbLines-3)*verticalDistanceBetweenLines - (Math.abs(parseInt(mValue)))*verticalDistanceBetweenLines/2
                }
            }
        }
        spacing: (staff.width-10-clefImage.width)/nbMaxNotesPerStaff-noteWidth
    }
}
