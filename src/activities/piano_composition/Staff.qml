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

    width: 400
    height: 100
    // Stave
    readonly property int nbLines: 5

    property bool lastPartition: false

    property bool isMetronomeDisplayed: false
    property bool showMetronome: false

    property alias notes: notes

    property int firstNoteX: defaultFirstNoteX
    property int defaultFirstNoteX: clefImage.width
    property int nbMaxNotesPerStaff
    property bool noteIsColored
    property alias notesRepeater: notesRepeater

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
    // end of partition line
    Rectangle {
        width: 5
        border.width: 5
        height: (nbLines - 1) * verticalDistanceBetweenLines + 5
        visible: lastPartition
        color: "black"
        x: staff.width - 10
        y: 0
    }

    ListModel {
        id: notes
    }

    Rectangle {
        id: metronome
        width: 5
        border.width: 10
        height: (nbLines - 1) * verticalDistanceBetweenLines + 5
        visible: isMetronomeDisplayed && showMetronome
        color: "red"
        x: firstNoteX - width/2
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

    function addNote(noteName, noteType, blackType, highlightWhenPlayed) {
        var duration
        if(noteType == "Whole")
            duration = 2000 / 1
        else if(noteType == "Half")
            duration = 3000 / 2
        else if(noteType == "Quarter")
            duration = 4000 / 4
        else
            duration = 6500 / 8

        notes.append({"noteName_": noteName, "noteType_": noteType, "mDuration": duration,
                      "highlightWhenPlayed": highlightWhenPlayed});
    }

    function playNote(noteId) {
        metronomeAnimation.velocity = staff.width * 1000 / (notes.get(noteId).mDuration * notes.count);
        print("velocity " + metronomeAnimation.velocity)
    }

    function eraseAllNotes() {
        notes.clear();
    }

    property int noteWidth: (staff.width - 10 - clefImage.width) / 10
    Row {
        id: notesRow
        x: firstNoteX - noteWidth/2
        Repeater {
            id: notesRepeater
            model: notes
            Note {
                noteName: noteName_
                noteType: noteType_
                highlightWhenPlayed: highlightWhenPlayed
                noteIsColored: staff.noteIsColored
                width: (notes.count == 1 && items.staffLength === "long") ? Math.min(items.background.width,items.background.height) * 0.1 : noteWidth
                height: staff.height

                noteDetails: Activity.getNoteDetails(noteName)
                rotation: {
                    if(noteDetails.positonOnStaff < 0 && noteType === "Whole")
                        return 0
                    else if(noteDetails.positonOnStaff > 6 && noteType === "Whole")
                        return 180
                    else
                        return noteDetails.rotation
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        print(items.staffLength)
                        print(items.background.width,items.background.height)
                    }
                }

                function play() {
//                     if(highlightWhenPlayed) {
                        highlightTimer.start();
//                     }
                }

                y: {
                    var shift =  -verticalDistanceBetweenLines / 2
                    var relativePosition = noteDetails.positonOnStaff
                    var imageY = (nbLines - 3) * verticalDistanceBetweenLines

                    if(rotation === 180) {
                        return imageY - (4 - relativePosition) * verticalDistanceBetweenLines + shift
                    }

                    return imageY - (6 - relativePosition) * verticalDistanceBetweenLines + shift
                }
            }
        }
    }
}
