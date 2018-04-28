/* GCompris - NoteNames.qml
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
import GCompris 1.0

import "../../core"
import "../piano_composition"
import "note_names.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"

        property bool keyboardMode: false
        property bool horizontalLayout: background.width > background.height ? true : false

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
            property alias staff: staff
            property alias bar: bar
            property alias bonus: bonus
            property alias gridRepeater: gridRepeater
            property alias bottomNotesRepeater: bottomNotesRepeater
            property alias okButton: okButton
            property alias score: score
            property string staffLength: "long"
            readonly property string clef: items.bar.level > 10 ? "bass" : "treble"
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle {
            id: instructionBox
            radius: 10
            width: background.width / 1.7
            height: horizontalLayout ? background.height / 5 : background.height / 5
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.8
            border.width: 6
            color: "white"
            border.color: "#87A6DD"

            GCText {
                id: instructionText
                visible: !staffText.visible
                color: "black"
                z: 3
                anchors.fill: parent
                anchors.rightMargin: parent.width * 0.1
                anchors.leftMargin: parent.width * 0.1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                text: [2, 3, 4, 12, 13, 14].indexOf(bar.level) !== -1 ?
                    qsTr("Click on the note name to match the pitch. Then click OK to check.") :
                    [5, 6, 7, 15, 16, 17].indexOf(bar.level) !== -1 ?
                        qsTr("Now there are sharp notes. These pitches are raised a half step.") :
                        // [8, 9, 10, 18, 19, 20]
                        qsTr("Now there are flat notes. These pitches are lowered a half step.")
            }

            GCText {
                id: staffText
                visible: bar.level == 1 || bar.level == 11
                height: background.height / 5
                width: background.width / 1.5
                z: 3
                color: "black"
                fontSizeMode: Text.Fit
                anchors.fill: parent
                anchors.rightMargin: parent.width * 0.1
                anchors.leftMargin: parent.width * 0.1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                text: bar.level == 1 ? qsTr("These are the eight basic notes in treble clef. They form the C Major Scale.") :
                                       qsTr("These are the eight basic notes in bass clef. They also form the C Major Scale. Notice that the note positions are different than in treble clef.")
            }
        }

        Rectangle {
            id: playScale
            width: horizontalLayout ? parent.width * 0.3 : parent.width * 0.35
            height: 30 * ApplicationInfo.ratio
            color: "#d8ffffff"
            border.color: "#2a2a2a"
            border.width: 3
            radius: 8
            z: 5
            anchors.top: instructionBox.bottom
            anchors.topMargin: 15
            anchors.left: background.left
            anchors.leftMargin: background.width * 0.15
            visible: bar.level == 1 || bar.level == 11

            GCText {
                id: playScaleText
                anchors.centerIn: parent
                text: qsTr("Play scale")
                fontSizeMode: Text.Fit
                wrapMode: Text.Wrap
            }

            MouseArea {
                id: playScaleArea
                anchors.fill: parent
                onClicked: {
//                      items.staff.eraseAllNotes()
//                     for(var i = 0; i < Activity.bottomNotes.length; i++) {
//                         var noteToPlay = 'qrc:/gcompris/src/activities/piano_composition/resource/' + items.clef + '_pitches/' + '1' + '/' + Activity.bottomNotes[i].note + '.wav';
//                         items.staff.addNote(noteToPlay, 4, "", true);
//                         items.audioEffects.append(noteToPlay)
//                     }
                    staff.play()
                }
            }
            states: [
                State {
                    name: "notclicked"
                    PropertyChanges {
                        target: playScale
                        scale: 1.0
                    }
                },
                State {
                    name: "clicked"
                    when: playScaleArea.pressed
                    PropertyChanges {
                        target: playScale
                        scale: 0.9
                    }
                },
                State {
                    name: "hover"
                    when: playScaleArea.containsMouse
                    PropertyChanges {
                        target: playScale
                        scale: 1.1
                    }
                }
            ]
            Behavior on scale { NumberAnimation { duration: 70 } }
        }

        Rectangle {
            id: playButton
            width: horizontalLayout ? parent.width * 0.3 : parent.width * 0.35
            height: 30 * ApplicationInfo.ratio
            color: "#d8ffffff"
            border.color: "#2a2a2a"
            border.width: 3
            radius: 8
            z: 5
            anchors.top: instructionBox.bottom
            anchors.topMargin: 15
            anchors.leftMargin: 30
            anchors.left: playScale.right
            visible: bar.level == 1 || bar.level == 11

            GCText {
                id: playButtonText
                anchors.centerIn: parent
                text: qsTr("Start levels")
                fontSizeMode: Text.Fit
                wrapMode: Text.Wrap
            }

            MouseArea {
                id: playButtonArea
                anchors.fill: parent
                onClicked: {
                     Activity.nextLevel()
                }
            }
            states: [
                State {
                    name: "notclicked"
                    PropertyChanges {
                        target: playButton
                        scale: 1.0
                    }
                },
                State {
                    name: "clicked"
                    when: playButtonArea.pressed
                    PropertyChanges {
                        target: playButton
                        scale: 0.9
                    }
                },
                State {
                    name: "hover"
                    when: playButtonArea.containsMouse
                    PropertyChanges {
                        target: playButton
                        scale: 1.1
                    }
                }
            ]
            Behavior on scale { NumberAnimation { duration: 70 } }
        }

        MultipleStaff {
            id: staff
            nbStaves: 1
            clef: bar.level <= 10 ? "treble" : "bass"
            height: background.height / 4
            width: bar.level == 1 || bar.level == 11 ? background.width * 0.8 : background.width / 2
            anchors {
                bottom: parent.bottom
                bottomMargin: bar.level != 11 ? parent.height * 0.35 : parent.height * 0.25
                horizontalCenter: bar.level == 1 || bar.level == 11 ? parent.horizontalCenter : undefined
                left: parent.left
                leftMargin: horizontalLayout ? parent.width * 0.1 : parent.width * 0.05
            }
            nbMaxNotesPerStaff: bar.level == 1 || bar.level == 11 ? 8 : 1
            firstNoteX: bar.level == 1 || bar.level == 11 ? width / 5 : width / 2
        }

        Grid {
            id: bottomNotesGrid
            rows: 1
            spacing: horizontalLayout ? background.width * 0.03 : background.width * 0.01
            anchors.bottom: background.bottom
            anchors.bottomMargin: background.height * 0.01
            anchors.horizontalCenter: parent.horizontalCenter
            height: staff.height
            visible: (bar.level == 1 || bar.level == 11) ? true : false

            property int itemWidth:  horizontalLayout ? background.width * 0.05 : background.width * 0.1
            property int itemHeight: itemWidth

            Repeater {
                id: bottomNotesRepeater
                model: Activity.bottomNotes

                Rectangle {
                id: notes
                color: dummyNote.noteColorMap[Activity.bottomNotes[index].note]
                width: bottomNotesGrid.itemWidth
                height: bottomNotesGrid.itemHeight
                radius: width / 5
                border.color: "black"

                GCText {
                    id: bottomNotesText
                    text: parseInt(Activity.bottomNotes[0].note) > 0 ? dummyNote.whiteNoteName[Activity.bottomNotes[index].note] : dummyNote.blackNoteName[Activity.bottomNotes[index].note]
                    anchors.centerIn: parent
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    id: buttonClick
                    anchors.fill: parent
                    onClicked: {
                        select()
                    }
                }

                function select() {
                    grid.currentIndex = index
                    var noteToPlay = 'qrc:/gcompris/src/activities/piano_composition/resource/' + items.clef + '_pitches/' + '1' + '/' + Activity.bottomNotes[index].note + '.wav'
                    items.audioEffects.play(noteToPlay)
                }
              }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Keys.onPressed: {
            if(event.key === Qt.Key_Space) {
                grid.currentItem.select()
            }
        }
        Keys.onReleased: {
            keyboardMode = true
            event.accepted = false
        }
        Keys.onEnterPressed: {
            grid.currentItem.select();
            Activity.checkAnswer(okButton.currentAnswer);
        }
        Keys.onReturnPressed: {
            grid.currentItem.select();
            Activity.checkAnswer(okButton.currentAnswer);
            }
        Keys.onRightPressed: grid.moveCurrentIndexRight();
        Keys.onLeftPressed: grid.moveCurrentIndexLeft();
        Keys.onDownPressed: grid.moveCurrentIndexDown();
        Keys.onUpPressed: grid.moveCurrentIndexUp();

        ListModel {
            id: gridRepeater
        }

        GridView {
            id: grid
            visible: instructionText.visible
            anchors {
                left: staff.right
                right: background.right
                leftMargin: 15 * ApplicationInfo.ratio
                top: instructionBox.bottom
                topMargin: horizontalLayout ? 15 * ApplicationInfo.ratio : 15 * ApplicationInfo.ratio
                bottom: background.bottom
            }
            keyNavigationWraps: true
            interactive: false
            model: gridRepeater
            cellWidth: itemWidth + 10
            cellHeight: itemHeight + 10
            height: staff.height


            property int itemWidth: 60
            property int itemHeight: itemWidth

            delegate: Rectangle {
                id: highlightRectangle
                width: grid.itemWidth * 1.15
                height: grid.itemHeight * 1.15
                radius: width / 5
                color: index === grid.currentIndex ? "red" : "transparent"
                border.color: index === grid.currentIndex ? "white" : "transparent"

                Rectangle {
                    id: noteRectangle
                    color: staff.noteIsColored ? dummyNote.noteColorMap[note] : "white"
                    width: grid.itemWidth
                    height: grid.itemHeight
                    radius: width / 5
                    border.color: "black"
                    anchors.centerIn: parent
                    visible: true

                    GCText {
                        id: noteText
                        text: parseInt(note) > 0 ? dummyNote.whiteNoteName[note] : dummyNote.blackNoteName[note]
                        anchors.centerIn: parent
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                    }
                    MouseArea {
                        id: buttonClick
                        anchors.fill: parent
                        onClicked: select()
                    }
                }
                    function select() {
                        grid.currentIndex = index
                        var noteToPlay = 'qrc:/gcompris/src/activities/piano_composition/resource/' + items.clef + '_pitches/' + '1' + '/' + note + '.wav'
                        items.audioEffects.play(noteToPlay);
                        okButton.currentAnswer = note
                    }
                }
            }

        // Never visible, only used to access the note names, colors
        Note {
            id: dummyNote
            visible: false
            value: "1"
            blackType: [8, 9, 10, 18, 19, 20].indexOf(bar.level) === -1 ? "sharp" : "flat"
        }

        Image {
            id: okButton
            visible: instructionText.visible
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: Math.min(parent.width,parent.height) * 0.15
            height: Math.min(parent.width,parent.height) * 0.15
            anchors {
                left: parent.left
                bottom: parent.bottom
                topMargin: horizontalLayout ? 0.1 * parent.height : 0.01 * parent.height
                bottomMargin: parent.height * 0.2
                leftMargin: 20
            }
            property string currentAnswer: ""
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(okButton.currentAnswer !== "")
                        Activity.checkAnswer(okButton.currentAnswer);
                    okButton.currentAnswer = ""
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: (bar.level == 1 || bar.level == 11) ?  (help | home | level ) : (help | home | level | reload) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.reloadLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: parent.height * 0.2
            }
            visible: bar.level !== 1 && bar.level !== 11
        }
    }
}
