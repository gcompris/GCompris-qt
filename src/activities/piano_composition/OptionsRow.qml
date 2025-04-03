/* GCompris - OptionsRow.qml
*
* SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"

Grid {
    id: optionsRow
    columns: 2

    //: Whole note, Half note, Quarter note and Eighth note are the different length notes in the musical notation.
    readonly property var noteLengthName: [[qsTr("Whole note"), "Whole"], [qsTr("Half note"), "Half"], [qsTr("Quarter note"), "Quarter"], [qsTr("Eighth note"), "Eighth"]]

    //: Whole rest, Half rest, Quarter rest and Eighth rest are the different length rests (silences) in the musical notation.
    readonly property var restAddedMessage: [qsTr("Whole rest added"), qsTr("Half rest added"), qsTr("Quarter rest added"), qsTr("Eighth rest added")]
    readonly property var translatedRestNames: [qsTr("Whole rest"), qsTr("Half rest"), qsTr("Quarter rest"), qsTr("Eighth rest")]
    readonly property var lyricsOrPianoModes: [[qsTr("Piano"), "piano"], [qsTr("Lyrics"), "lyrics"]]

    property real iconsWidth: score.height * 1.2
    property alias noteOptionsIndex: noteOptions.currentIndex
    property alias lyricsOrPianoModeIndex: lyricsOrPianoModeOption.currentIndex
    property alias keyOption: keyOption
    property alias bpmMeter: bpmMeter
    property alias restOptionIndex: restOptions.currentIndex

    property bool restOptionsVisible: false
    property bool noteOptionsVisible: false
    property bool playButtonVisible: false
    property bool clearButtonVisible: false
    property bool undoButtonVisible: false
    property bool openButtonVisible: false
    property bool saveButtonVisible: false
    property bool changeAccidentalStyleButtonVisible: false
    property bool lyricsOrPianoModeOptionVisible: false
    property bool bpmVisible: false

    signal undoButtonClicked
    signal clearButtonClicked
    signal openButtonClicked
    signal saveButtonClicked
    signal playButtonClicked
    signal bpmIncreased
    signal bpmDecreased
    signal bpmChanged
    signal emitOptionMessage(string message)

    onPlayButtonClicked: {
        if(!multipleStaff.isMusicPlaying) {
            emitOptionMessage(qsTr("Play melody"))
            multipleStaff.play()
        } else {
            multipleStaff.stopPlaying()
        }
    }


    BpmMeter {
        id: bpmMeter
    }

    BarButton {
        id: playButton
        source: multipleStaff.isMusicPlaying ?
            "qrc:/gcompris/src/activities/piano_composition/resource/stop.svg" :
            "qrc:/gcompris/src/activities/piano_composition/resource/play.svg"
        width: optionsRow.iconsWidth
        visible: playButtonVisible
        onClicked: {
                optionsRow.playButtonClicked()
        }
    }

    BarButton {
        id: clearButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/erase.svg"
        width: optionsRow.iconsWidth
        visible: clearButtonVisible
        onClicked: clearButtonClicked()
    }

    BarButton {
        id: undoButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/undo.svg"
        width: optionsRow.iconsWidth
        visible: undoButtonVisible
        onClicked: {
                emitOptionMessage(qsTr("Undo"))
                undoButtonClicked()
        }
    }

    KeyOption {
        id: keyOption
    }

    Item {
        id: rests
        width: optionsRow.iconsWidth * 2
        height: optionsRow.iconsWidth
        visible: restOptionsVisible
        Rectangle {
            color: GCStyle.lightTransparentBg
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.blueBorder
            anchors.fill: parent
            radius: GCStyle.halfMargins
        }

        SwitchableOptions {
            id: restOptions

            readonly property string restTypeImage: (optionsRow.noteLengthName[currentIndex][1].toLowerCase())

            source: "qrc:/gcompris/src/activities/piano_composition/resource/rest%1.svg".arg(restTypeImage)
            nbOptions: optionsRow.noteLengthName.length
            onClicked: {
                activityBackground.restType = optionsRow.noteLengthName[currentIndex][1]
                emitOptionMessage(optionsRow.translatedRestNames[currentIndex])
            }
            width: optionsRow.iconsWidth - 2 * GCStyle.tinyMargins
            visible: restOptionsVisible
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: GCStyle.tinyMargins
        }

        BarButton {
            id: addRestButton
            width: restOptions.width
            height: width
            source: "qrc:/gcompris/src/activities/piano_composition/resource/add.svg"
            anchors.right: parent.right
            anchors.rightMargin: GCStyle.tinyMargins
            anchors.verticalCenter: parent.verticalCenter
            visible: restOptions.visible
            onClicked: {
                emitOptionMessage(optionsRow.restAddedMessage[restOptionIndex])
                parent.scale = 1
                pianoLayout.addMusicElementAndPushToStack(restType.toLowerCase(), "Rest")
            }
        }
    }

    BarButton {
        id: changeAccidentalStyleButton
        source: changeAccidentalStyleButtonVisible ? (piano.useSharpNotation ? "qrc:/gcompris/src/activities/piano_composition/resource/blacksharp.svg"
                                                   : "qrc:/gcompris/src/activities/piano_composition/resource/blackflat.svg")
                                                   : ""
        sourceSize.width: optionsRow.iconsWidth
        visible: changeAccidentalStyleButtonVisible
        onClicked: {
            piano.useSharpNotation = !piano.useSharpNotation
            //: Sharp notes and Flat notes represents the accidental style of the notes in the music.
            emitOptionMessage(piano.useSharpNotation ? qsTr("Sharp notes") : qsTr("Flat notes"))
        }
    }

    SwitchableOptions {
        id: noteOptions
        source: "qrc:/gcompris/src/activities/piano_composition/resource/note%1.svg".arg(optionsRow.noteLengthName[currentIndex][1])
        nbOptions: optionsRow.noteLengthName.length
        width: optionsRow.iconsWidth
        currentIndex: 2
        onClicked: {
            activityBackground.currentType = optionsRow.noteLengthName[currentIndex][1]
            emitOptionMessage(optionsRow.noteLengthName[currentIndex][0])
        }
        visible: noteOptionsVisible
    }

    BarButton {
        id: openButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/open.svg"
        width: optionsRow.iconsWidth
        height: width
        visible: openButtonVisible
        onClicked: openButtonClicked()
    }

    BarButton {
        id: saveButton
        source: "qrc:/gcompris/src/activities/piano_composition/resource/save.svg"
        width: optionsRow.iconsWidth
        height: width
        visible: saveButtonVisible
        onClicked: saveButtonClicked()
    }

    SwitchableOptions {
        id: lyricsOrPianoModeOption
        nbOptions: optionsRow.lyricsOrPianoModes.length
        width: optionsRow.iconsWidth
        source: "qrc:/gcompris/src/activities/piano_composition/resource/%1.svg".arg(optionsRow.lyricsOrPianoModes[currentIndex][1])
        visible: lyricsOrPianoModeOptionVisible
        onClicked: emitOptionMessage(optionsRow.lyricsOrPianoModes[currentIndex][0])
    }
    
}
