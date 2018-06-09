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

    readonly property var noteLengthName: ["Whole", "Half", "Quarter", "Eighth"]
    readonly property var staffModes: ["add", "replace", "erase"]
    readonly property var lyricsOrPianoModes: ["piano", "lyrics"]

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

    SwitchableOptions {
        id: noteOptions
        source: "qrc:/gcompris/src/activities/piano_composition/resource/genericNote%1.svg".arg(optionsRow.noteLengthName[currentIndex])
        nbOptions: optionsRow.noteLengthName.length
        onClicked: background.currentType = optionsRow.noteLengthName[currentIndex]
        visible: noteOptionsVisible
    }

    Image {
        id: playButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/play.svg"
        sourceSize.width: optionsRow.iconsWidth
        visible: playButtonVisible
        MouseArea {
            anchors.fill: parent
            onClicked: multipleStaff.play()
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
                lyricsArea.resetLyricsArea()
            }
        }
    }

    SwitchableOptions {
        id:staffModesOptions
        nbOptions: optionsRow.staffModes.length
        source: "qrc:/gcompris/src/activities/piano_composition/resource/%1.svg".arg(optionsRow.staffModes[currentIndex])
        anchors.top: parent.top
        anchors.topMargin: 4
        visible: staffModesOptionsVisible
        onClicked: {
            background.staffMode = optionsRow.staffModes[currentIndex]
            if(background.staffMode != "replace") {
                multipleStaff.noteToReplace = -1
            }
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
            onClicked: undoButtonClicked()
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
            onClicked: piano.useSharpNotation = !piano.useSharpNotation
        }
    }

    SwitchableOptions {
        id: lyricsOrPianoModeOption
        nbOptions: optionsRow.lyricsOrPianoModes.length
        source: "qrc:/gcompris/src/activities/piano_composition/resource/%1-icon.svg".arg(optionsRow.lyricsOrPianoModes[currentIndex])
        anchors.top: parent.top
        anchors.topMargin: 4
        visible: lyricsOrPianoModeOptionVisible
    }

    // Since the half rest image is just the rotated image of whole rest image, we check if the current rest type is half, we assign the source as whole rest and rotate it by 180 degrees.
    SwitchableOptions {
        id: restOptions

        readonly property string restTypeImage: ((optionsRow.noteLengthName[currentIndex] === "Half") ? "Whole" : optionsRow.noteLengthName[currentIndex]).toLowerCase()

        source: "qrc:/gcompris/src/activities/piano_composition/resource/%1Rest.svg".arg(restTypeImage)
        nbOptions: optionsRow.noteLengthName.length
        onClicked: background.restType = optionsRow.noteLengthName[currentIndex]
        rotation: optionsRow.noteLengthName[currentIndex] === "Half" ? 180 : 0
        visible: restOptionsVisible
    }

    Image {
        id: addRestButton
        sourceSize.width: optionsRow.iconsWidth
        source: "qrc:/gcompris/src/core/resource/apply.svg"
        visible: restOptions.visible
        anchors.top: parent.top
        anchors.topMargin: 4
        MouseArea {
            anchors.fill: parent
            onPressed: parent.scale = 0.8
            onReleased: {
                parent.scale = 1
                if(background.staffMode === "add")
                    multipleStaff.addNote(restType.toLowerCase(), "Rest", false, false)
                else
                    multipleStaff.replaceNote(restType.toLowerCase(), "Rest")
            }
        }
    }
}
