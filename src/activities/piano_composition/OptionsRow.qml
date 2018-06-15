/* GCompris - OptionsRow.qml
*
* Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
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

Row {
    id: optionsRow
    spacing: 15

    //: Whole note, Half note, Quarter note and Eighth note are the different length notes in the musical notation.
    readonly property var noteLengthName: [[qsTr("Whole note"), "Whole"], [qsTr("Half note"), "Half"], [qsTr("Quarter note"), "Quarter"], [qsTr("Eighth note"), "Eighth"]]

    //: Whole rest, Half rest, Quarter rest and Eighth rest are the different length rests (silences) in the musical notation.
    readonly property var translatedRestNames: [qsTr("Whole rest"), qsTr("Half rest"), qsTr("Quarter rest"), qsTr("Eighth rest")]
    readonly property var staffModes: [[qsTr("Add"), "add"], [qsTr("Replace"), "replace"], [qsTr("Erase"), "erase"]]
    readonly property var lyricsOrPianoModes: [[qsTr("Piano"), "piano"], [qsTr("Lyrics"), "lyrics"]]

    property real iconsWidth: Math.min(50, (background.width - optionsRow.spacing * 12) / 14)
    property alias noteOptionsIndex: noteOptions.currentIndex
    property alias staffModeIndex: staffModesOptions.currentIndex
    property alias lyricsOrPianoModeIndex: lyricsOrPianoModeOption.currentIndex
    property alias restOptionIndex: restOptions.currentIndex

    property bool noteOptionsVisible: false
    property bool playButtonVisible: false
    property bool clefButtonVisible: false
    property bool staffModesOptionsVisible: false
    property bool clearButtonVisible: false
    property bool undoButtonVisible: false
    property bool openButtonVisible: false
    property bool saveButtonVisible: false
    property bool changeAccidentalStyleButtonVisible: false
    property bool lyricsOrPianoModeOptionVisible: false
    property bool restOptionsVisible: false

    signal undoButtonClicked
    signal clearButtonClicked
    signal openButtonClicked
    signal saveButtonClicked
    signal restReplaced
    signal emitOptionMessage(string message)

    SwitchableOptions {
        id: noteOptions
        source: "qrc:/gcompris/src/activities/piano_composition/resource/genericNote%1.svg".arg(optionsRow.noteLengthName[currentIndex][1])
        nbOptions: optionsRow.noteLengthName.length
        onClicked: {
            background.currentType = optionsRow.noteLengthName[currentIndex][1]
            emitOptionMessage(optionsRow.noteLengthName[currentIndex][0])
        }
        visible: noteOptionsVisible
    }

    Image {
        id: playButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/play.svg"
        sourceSize.width: optionsRow.iconsWidth
        visible: playButtonVisible
        MouseArea {
            anchors.fill: parent
            onClicked: {
                emitOptionMessage(qsTr("Play melody"))
                multipleStaff.play()
            }
        }
    }

    Image {
        id: clefButton
        source: background.clefType == "Bass" ? "qrc:/gcompris/src/activities/piano_composition/resource/bassClefButton.svg" : "qrc:/gcompris/src/activities/piano_composition/resource/trebbleClefButton.svg"
        sourceSize.width: optionsRow.iconsWidth
        visible: clefButtonVisible
        MouseArea {
            anchors.fill: parent
            onClicked: {
                multipleStaff.eraseAllNotes()
                background.clefType = (background.clefType == "Bass") ? "Treble" : "Bass"
                //: Treble clef and Bass clef are the notations to indicate the pitch of the sound written on it.
                emitOptionMessage((background.clefType === "Treble") ? qsTr("Treble clef") : qsTr("Bass clef"))
                lyricsArea.resetLyricsArea()
            }
        }
    }

    SwitchableOptions {
        id:staffModesOptions
        nbOptions: optionsRow.staffModes.length
        source: "qrc:/gcompris/src/activities/piano_composition/resource/%1.svg".arg(optionsRow.staffModes[currentIndex][1])
        anchors.top: parent.top
        anchors.topMargin: 4
        visible: staffModesOptionsVisible
        onClicked: {
            background.staffMode = optionsRow.staffModes[currentIndex][1]
            emitOptionMessage(optionsRow.staffModes[currentIndex][0])
            multipleStaff.selectedIndex = -1
            multipleStaff.insertingIndex = multipleStaff.notesModel.count
        }
    }

    Image {
        id: clearButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/edit-clear.svg"
        sourceSize.width: optionsRow.iconsWidth
        visible: clearButtonVisible
        MouseArea {
            anchors.fill: parent
            onClicked: clearButtonClicked()
        }
    }

    Image {
        id: undoButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/undo.svg"
        sourceSize.width: optionsRow.iconsWidth
        visible: undoButtonVisible
        MouseArea {
            anchors.fill: parent
            onClicked: {
                emitOptionMessage(qsTr("Undo"))
                undoButtonClicked()
            }
        }
    }

    Image {
        id: openButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/open.svg"
        sourceSize.width: optionsRow.iconsWidth
        visible: openButtonVisible
        MouseArea {
            anchors.fill: parent
            onClicked: openButtonClicked()
        }
    }

    Image {
        id: saveButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/save.svg"
        sourceSize.width: optionsRow.iconsWidth
        visible: saveButtonVisible
        MouseArea {
            anchors.fill: parent
            onClicked: saveButtonClicked()
        }
    }

    Image {
        id: changeAccidentalStyleButton
        source: piano.useSharpNotation ? "qrc:/gcompris/src/activities/piano_composition/resource/blacksharp.svg" : "qrc:/gcompris/src/activities/piano_composition/resource/blackflat.svg"
        sourceSize.width: optionsRow.iconsWidth
        visible: changeAccidentalStyleButtonVisible
        MouseArea {
            anchors.fill: parent
            onClicked: {
                piano.useSharpNotation = !piano.useSharpNotation
                //: Sharp notes and Flat notes represents the accidental style of the notes in the music.
                emitOptionMessage(piano.useSharpNotation ? qsTr("Sharp notes") : qsTr("Flat notes"))
            }
        }
    }

    SwitchableOptions {
        id: lyricsOrPianoModeOption
        nbOptions: optionsRow.lyricsOrPianoModes.length
        source: "qrc:/gcompris/src/activities/piano_composition/resource/%1-icon.svg".arg(optionsRow.lyricsOrPianoModes[currentIndex][1])
        anchors.top: parent.top
        anchors.topMargin: 4
        visible: lyricsOrPianoModeOptionVisible
        onClicked: emitOptionMessage(optionsRow.lyricsOrPianoModes[currentIndex][0])
    }

    Item {
        width: 2.3 * optionsRow.iconsWidth
        height: optionsRow.iconsWidth + 10
        visible: restOptionsVisible
        Rectangle {
            color: "yellow"
            opacity: 0.1
            border.width: 2
            border.color: "black"
            anchors.fill: parent
            radius: 10
        }

        // Since the half rest image is just the rotated image of whole rest image, we check if the current rest type is half, we assign the source as whole rest and rotate it by 180 degrees.
        SwitchableOptions {
            id: restOptions

            readonly property string restTypeImage: ((optionsRow.noteLengthName[currentIndex][1] === "Half") ? "Whole" : optionsRow.noteLengthName[currentIndex][1]).toLowerCase()

            source: "qrc:/gcompris/src/activities/piano_composition/resource/%1Rest.svg".arg(restTypeImage)
            nbOptions: optionsRow.noteLengthName.length
            onClicked: {
                background.restType = optionsRow.noteLengthName[currentIndex][1]
                emitOptionMessage(optionsRow.translatedRestNames[currentIndex])
            }
            rotation: optionsRow.noteLengthName[currentIndex][1] === "Half" ? 180 : 0
            visible: restOptionsVisible
            anchors.topMargin: -3
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Image {
            id: addRestButton
            sourceSize.width: optionsRow.iconsWidth / 1.4
            source: "qrc:/gcompris/src/activities/piano_composition/resource/add.svg"
            anchors.left: restOptions.right
            anchors.leftMargin: 8
            visible: restOptions.visible
            anchors.top: parent.top
            anchors.topMargin: 10
            MouseArea {
                anchors.fill: parent
                onPressed: parent.scale = 0.8
                onReleased: {
                    //: %1 is the name of the rest which is added and displayed from the variable translatedRestNames.
                    emitOptionMessage(qsTr("Added %1").arg(optionsRow.translatedRestNames[restOptionIndex]))
                    parent.scale = 1
                    if(background.staffMode === "add") {
                        if(multipleStaff.selectedIndex == 0)
                            background.askInsertDirection(restType.toLowerCase(), "Rest")
                        else
                            background.addNoteAndPushToStack(restType.toLowerCase(), "Rest")
                    }
                    else {
                        if(multipleStaff.selectedIndex != -1) {
                            restReplaced()
                            multipleStaff.replaceNote(restType.toLowerCase(), "Rest")
                        }
                    }
                }
            }
        }
    }
}
