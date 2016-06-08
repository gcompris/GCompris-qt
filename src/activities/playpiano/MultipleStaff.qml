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
    id: multipleStaff

    property int nbStaves
    property string clef
    property int distanceBetweenStaff: 20

    property int currentStaff: 0

    property int nbMaxNotesPerStaff: 6

    Column {
        Repeater {
            id: staves
            model: nbStaves
            Staff {
                id: staff
                clef: multipleStaff.clef
                height: (multipleStaff.height-distanceBetweenStaff*(nbStaves-1))/nbStaves
                width: multipleStaff.width
                y: index * (height+distanceBetweenStaff)
                lastPartition: index == nbStaves-1
                nbMaxNotesPerStaff: multipleStaff.nbMaxNotesPerStaff
            }
        }
    }

    function addNote(newValue_, newType_, newBlackType_) {
        if(staves.itemAt(currentStaff).notes.count > nbMaxNotesPerStaff) {
            if(currentStaff+1 >= nbStaves) {
                print("no more place!")
                return
            }
            else
                currentStaff++
        }

        staves.itemAt(currentStaff).notes.append({"mValue": newValue_, "mType": newType_,
                                                  "mBlackType": newBlackType_, "mDuration": 2000/newType_});
    }

    function play() {
        musicTimer.currentPlayedStaff = 0;
        musicTimer.currentNote = 0;
        musicTimer.interval = 1000;
        for(var v = 1 ; v < currentStaff ; ++ v)
            staves.itemAt(v).showMetronome = false;
        staves.itemAt(0).showMetronome = true;

        musicTimer.start();
    }

    function eraseAllNotes() {
        for(var v = 0 ; v <= currentStaff ; ++ v)
            staves.itemAt(v).eraseAllNotes();
        currentStaff = 0;
    }

    property var whiteNotes: ["C", "D", "E", "F", "G", "A", "B", "2C", "2D", "2E", "2F"]
    property var blackNotesSharp: ["C#", "D#", "F#", "G#", "A#", "2C#"]
    property var blackNotesFlat: ["DB", "EB", "GB", "AB", "BB"]

    function loadFromData(data) {
        eraseAllNotes()
        var melody = data.split(" ");
        multipleStaff.clef = melody[0];
        for(var i = 1 ; i < melody.length ; ++ i) {
            var noteLength = melody[i].length;
            var type = parseInt(melody[i][noteLength-1]);
            var noteStr = melody[i].substr(0, noteLength-1).toUpperCase();

            print(type + " - " + noteStr)
            if(whiteNotes.indexOf(noteStr) != -1)
                addNote(""+(whiteNotes.indexOf(noteStr)+1), type, "");
            else if (blackNotesSharp.indexOf(melody[i][0]) != -1) {
                addNote(""+(-1*blackNotesSharp.indexOf(noteStr)-1), type, "sharp");
            }
            else {
                addNote(""+(-1*blackNotesFlat.indexOf(noteStr)-1), type, "flat");
            }

            print(melody[i]);
        }
    }

    Timer {
        id: musicTimer
        property int currentPlayedStaff: 0
        property int currentNote: 0
        onRunningChanged: {
            if(!running && staves.itemAt(currentPlayedStaff).notes.get(currentNote) !== undefined) {
                var currentType = staves.itemAt(currentPlayedStaff).notes.get(currentNote).mType
                var note = staves.itemAt(currentPlayedStaff).notes.get(currentNote).mValue

                // TODO some notes does not play if they are played in the rcc directly...
                var noteToPlay = 'qrc:/gcompris/src/activities/playpiano/resource/'+multipleStaff.clef+'_pitches/'+currentType+'/'+note+'.wav';
                //var noteToPlay = 'C:/Users/Johnny/Desktop/work/gcompris/src/activities/playpiano/resource/'+multipleStaff.clef+'_pitches/'+currentType+'/'+note+'.wav';
                items.audioEffects.play(noteToPlay);

                if(currentNote == 0) {
                    staves.itemAt(currentPlayedStaff).initMetronome();
                }
                musicTimer.interval = staves.itemAt(currentPlayedStaff).notes.get(currentNote).mDuration;
                currentNote ++;
                if(currentNote > nbMaxNotesPerStaff) {
                    currentNote = 0;
                    currentPlayedStaff ++;
                    if(currentPlayedStaff < nbStaves && currentNote < staves.itemAt(currentPlayedStaff).notes.count) {
                        print("play next staff");
                        staves.itemAt(currentPlayedStaff).showMetronome = true;
                        if(currentPlayedStaff>0)
                            staves.itemAt(currentPlayedStaff-1).showMetronome = false;
                        staves.itemAt(currentPlayedStaff).playNote(currentNote);
                        musicTimer.start();
                    }
                }
                else if(staves.itemAt(currentPlayedStaff).notes.get(currentNote) !== undefined) {
                    print("will play next " + JSON.stringify(staves.itemAt(currentPlayedStaff).notes.get(currentNote)));
                    staves.itemAt(currentPlayedStaff).playNote(currentNote);
                    musicTimer.start();
                }
            }
        }
    }
}
