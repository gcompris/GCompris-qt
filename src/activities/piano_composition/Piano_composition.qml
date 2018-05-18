/* GCompris - Piano_composition.qml
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
import QtQuick.Controls 1.0
import GCompris 1.0

import "../../core"
import "piano_composition.js" as Activity
import "melodies.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool horizontalLayout: background.width > background.height

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

        Keys.onPressed: {
            if(event.key === Qt.Key_1) {
                playNote('1')
            }
            if(event.key === Qt.Key_2) {
                playNote('2')
            }
            if(event.key === Qt.Key_3) {
                playNote('3')
            }
            if(event.key === Qt.Key_4) {
                playNote('4')
            }
            if(event.key === Qt.Key_5) {
                playNote('5')
            }
            if(event.key === Qt.Key_6) {
                playNote('6')
            }
            if(event.key === Qt.Key_7) {
                playNote('7')
            }
            if(event.key === Qt.Key_8) {
                playNote('8')
            }
            if(event.key === Qt.Key_F1 && bar.level >= 4) {
                playNote('-1')
            }
            if(event.key === Qt.Key_F2 && bar.level >= 4) {
                playNote('-2')
            }
            if(event.key === Qt.Key_F3 && bar.level >= 4) {
                playNote('-3')
            }
            if(event.key === Qt.Key_F4 && bar.level >= 4) {
                playNote('-4')
            }
            if(event.key === Qt.Key_F5 && bar.level >= 4) {
                playNote('-5')
            }
            if(event.key === Qt.Key_Delete) {
                multipleStaff.eraseAllNotes()
            }
            if(event.key === Qt.Key_Space) {
                multipleStaff.play()
            }
        }

        function playNote(note) {
            piano.noteClicked(note)
        }
        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property alias bar: bar
            property alias bonus: bonus
            property alias multipleStaff: multipleStaff
            property string staffLength: "short"
            property alias melodyList: melodyList
            property alias file: file
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property int currentType: 1
        property string clefType: bar.level == 2 ? "bass" : "treble"

        File {
            id: file
            onError: console.error("File error: " + msg)
        }

        MelodyList {
            id: melodyList
            onClose: {
                visible = false
                piano.enabled = true
                bar.visible = true
            }
        }

        Rectangle {
            id: instructionBox
            radius: 10
            width: background.width * 0.98
            height: background.height / 9
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.8
            border.width: 6
            color: "white"
            border.color: "#87A6DD"

            GCText {
                id: instructionText
                color: "black"
                z: 3
                anchors.fill: parent
                anchors.rightMargin: parent.width * 0.1
                anchors.leftMargin: parent.width * 0.1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                text: Activity.instructions[bar.level - 1].text
            }
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.50 : parent.width * 0.8
            height: horizontalLayout ? parent.height * 0.58 : parent.height * 0.3
            nbStaves: 3
            clef: clefType
            nbMaxNotesPerStaff: 8
            noteIsColored: true
            isMetronomeDisplayed: true
            anchors.right: horizontalLayout ? parent.right: undefined
            anchors.horizontalCenter: horizontalLayout ? undefined : parent.horizontalCenter
            anchors.top: instructionBox.bottom
            anchors.topMargin: parent.height * 0.1
            anchors.rightMargin: parent.width * 0.043
        }

        GCButtonScroll {
            anchors.right: parent.right
            anchors.rightMargin: 5 * ApplicationInfo.ratio
            anchors.verticalCenter: multipleStaff.verticalCenter
            width: horizontalLayout ? parent.width * 0.033 : parent.width * 0.06
            height: width * heightRatio
            onUp: multipleStaff.flickableStaves.flick(0, multipleStaff.height * 1.3)
            onDown: multipleStaff.flickableStaves.flick(0, -multipleStaff.height * 1.3)
            upVisible: multipleStaff.flickableStaves.visibleArea.yPosition > 0
            downVisible: (multipleStaff.flickableStaves.visibleArea.yPosition + multipleStaff.flickableStaves.visibleArea.heightRatio) < 1
        }

        Piano {
            id: piano
            width: horizontalLayout ? parent.width * 0.4 : parent.width * 0.7
            height: horizontalLayout ? parent.height * 0.45 : parent.width * 0.26
            anchors.horizontalCenter: horizontalLayout ? undefined : parent.horizontalCenter
            anchors.left: horizontalLayout ? parent.left : undefined
            anchors.leftMargin: parent.width * 0.03
            anchors.top: horizontalLayout ? optionsRow.bottom : multipleStaff.bottom
            anchors.topMargin: parent.height * 0.05
            blackLabelsVisible: [4, 5, 6, 7, 8].indexOf(items.bar.level) == -1 ? false : true
            useSharpNotation: bar.level == 5 ? false : true
            onNoteClicked: {
                var blackType = ""
                if(note < 0)
                    blackType = piano.useSharpNotation ? "sharp" : "flat"
                multipleStaff.addNote(note, currentType, blackType, false)
                var noteToPlay = 'qrc:/gcompris/src/activities/piano_composition/resource/' + clefType + '_pitches/' + currentType + '/' + note + '.wav';
                items.audioEffects.play(noteToPlay)
            }
        }

        Row {
            id: optionsRow
            anchors.top: instructionBox.bottom
            anchors.topMargin: 10
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter

            readonly property var noteTypes: [1, 2, 4, 8]
            readonly property var noteLengthName: ["whole-note", "half-note", "quarter-note", "eighth-note"]

            Image {
                id: noteTypeOption

                property int currentIndex: 0

                source: "qrc:/gcompris/src/activities/piano_composition/resource/%1.svg".arg(optionsRow.noteLengthName[currentIndex])
                sourceSize.width: 50
                anchors.top: parent.top
                anchors.topMargin: -6
                visible: (bar.level == 1 || bar.level == 2) ? false : true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        parent.currentIndex = (parent.currentIndex + 1) % 4
                        clickAnimation.start()
                        currentType = optionsRow.noteTypes[parent.currentIndex]
                    }
                }

                SequentialAnimation {
                    id: clickAnimation
                    NumberAnimation {
                        target: noteTypeOption
                        property: "scale"
                        to: 0.7
                        duration: 150
                    }
                    NumberAnimation {
                        target: noteTypeOption
                        property: "scale"
                        to: 1
                        duration: 150
                    }
                }
            }

            Image {
                id: playButton
                source: "qrc:/gcompris/src/activities/piano_composition/resource/play.svg"
                sourceSize.width: 50
                MouseArea {
                    anchors.fill: parent
                    onClicked: multipleStaff.play()
                }
            }

            Image {
                id: clefButton
                source: clefType == "bass" ? "qrc:/gcompris/src/activities/piano_composition/resource/bassClefButton.svg" : "qrc:/gcompris/src/activities/piano_composition/resource/trebbleClefButton.svg"
                sourceSize.width: 50
                visible: bar.level > 2
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        multipleStaff.eraseAllNotes()
                        clefType = (clefType == "bass") ? "treble" : "bass"
                    }
                }
            }

            Image {
                id: clearButton
                source: "qrc:/gcompris/src/activities/piano_composition/resource/edit-clear.svg"
                sourceSize.width: 50
                MouseArea {
                    anchors.fill: parent
                    onClicked: multipleStaff.eraseAllNotes()
                }
            }

            Image {
                id: openButton
                source: "qrc:/gcompris/src/activities/piano_composition/resource/open.svg"
                sourceSize.width: 50
                visible: bar.level == 6 || bar.level == 7
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var dataset = Dataset.get()
                        for(var i = 0; i < dataset.length; i++) {
                            melodyList.melodiesModel.append(dataset[i])
                        }
                        piano.enabled = false
                        bar.visible = false
                        melodyList.visible = true
                    }
                }
            }

            Image {
                id: saveButton
                source: "qrc:/gcompris/src/activities/piano_composition/resource/save.svg"
                sourceSize.width: 50
                visible: bar.level == 6 || bar.level == 7
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Activity.saveMelody()
                    }
                }
            }
            Image {
                id: changeAccidentalStyleButton
                source: piano.useSharpNotation ? "qrc:/gcompris/src/activities/piano_composition/resource/blacksharp.svg" : "qrc:/gcompris/src/activities/piano_composition/resource/blackflat.svg"
                visible: bar.level >= 4
                MouseArea {
                    anchors.fill: parent
                    onClicked: piano.useSharpNotation = !piano.useSharpNotation
                }
            }
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
