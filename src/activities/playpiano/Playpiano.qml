/* GCompris - playpiano.qml
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
import QtQuick 2.1
import QtQuick.Controls 1.0

import "../../core"
import "playpiano.js" as Activity
import "melodies.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCAudio audioEffects: activity.audioEffects
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property int currentType: 1

        /*Column {
            spacing: 2
            anchors.fill: parent
            GCText {
                text: qsTr("Click the piano keys...")
            }
            MultipleStaff {
                id: staff
                width: 500
                height: 300
                nbStaves: 1
                clef: "bass"
            }
            Piano {
                id: piano
                width: 500
                height: 300
                onNoteClicked: {
                    print(note);
                    staff.addNote(note, currentType, piano.useSharpNotation ? "sharp" : "flat")
                    var noteToPlay = 'qrc:/gcompris/src/activities/playpiano/resource/'+'bass'+'_pitches/'+currentType+'/'+note+'.wav';
                    items.audioEffects.play(noteToPlay);
                }
            }
            Image {
                source: "qrc:/gcompris/src/activities/playpiano/resource/play.svg"
                sourceSize.width: 75
                MouseArea{
                    anchors.fill: parent
                    onClicked: staff.play()
                }
            }
        }*/

        Grid {
            columns: 2
            anchors.fill: parent
            MultipleStaff {
                id: staff1
                width: 300
                height: 200
                nbStaves: 1
                clef: "bass"
                nbMaxNotesPerStaff: 6
                noteIsColored: true
            }
            MultipleStaff {
                id: staff2
                width: 400
                height: 300
                nbStaves: 2
                clef: "treble"
                nbMaxNotesPerStaff: 10
                noteIsColored: true
                isMetronomeDisplayed: true
            }
            Piano {
                id: piano
                width: 500
                height: 300
                onNoteClicked: {
                    onlyNote.value = note;
                    staff2.addNote(note, currentType, piano.useSharpNotation ? "sharp" : "flat", false)
                    var noteToPlay = 'qrc:/gcompris/src/activities/playpiano/resource/'+'bass'+'_pitches/'+currentType+'/'+note+'.wav';
                    print(noteToPlay);
                    items.audioEffects.play(noteToPlay);
                }
            }
            Note {
                id: onlyNote
                value: "1"
                type: currentType
                width: 40
                height: 40
            }

            Row {
                Image {
                    source: "qrc:/gcompris/src/activities/playpiano/resource/whole-note.svg"
                    sourceSize.width: 50
                    MouseArea{
                        anchors.fill: parent
                        onClicked: currentType = onlyNote.wholeNote
                    }
                }
                Image {
                    source: "qrc:/gcompris/src/activities/playpiano/resource/half-note.svg"
                    sourceSize.width: 50
                    MouseArea{
                        anchors.fill: parent
                        onClicked: currentType = onlyNote.halfNote
                    }
                }
                Image {
                    source: "qrc:/gcompris/src/activities/playpiano/resource/quarter-note.svg"
                    sourceSize.width: 50
                    MouseArea{
                        anchors.fill: parent
                        onClicked: currentType = onlyNote.quarterNote
                    }
                }
                Image {
                    source: "qrc:/gcompris/src/activities/playpiano/resource/eighth-note.svg"
                    sourceSize.width: 50
                    MouseArea{
                        anchors.fill: parent
                        onClicked: currentType = onlyNote.eighthNote
                    }
                }
                Image {
                    source: "qrc:/gcompris/src/activities/playpiano/resource/play.svg"
                    sourceSize.width: 75
                    MouseArea{
                        anchors.fill: parent
                        onClicked: staff2.play()
                    }
                }
                Image {
                    source: "qrc:/gcompris/src/activities/playpiano/resource/edit-clear.svg"
                    sourceSize.width: 75
                    MouseArea{
                        anchors.fill: parent
                        onClicked: staff2.eraseAllNotes()
                    }
                }

                Image {
                    source: "qrc:/gcompris/src/activities/playpiano/resource/open.svg"
                    sourceSize.width: 50
                    MouseArea{
                        anchors.fill: parent
                        onClicked: loadMelody()
                    }
                }
            }

            GCDialogCheckBox {
                id: button
                onClicked: piano.useSharpNotation = !piano.useSharpNotation
            }
            
            GCText {
                text: qsTr("Change accidental style")
            }
            Image {
                source: piano.useSharpNotation ? "qrc:/gcompris/src/activities/playpiano/resource/blacksharp.svg" : "qrc:/gcompris/src/activities/playpiano/resource/blackflat.svg"
            }
        }
        function loadMelody() {
            var data = Dataset.get();
            var selectedMusic = data.filter(function(item) { return item.title === 'Frère jacques'; });
            staff2.loadFromData(selectedMusic[0]["melody"]);
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
