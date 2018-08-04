/* GCompris - MultipleStaff.qml
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
import "qrc:/gcompris/src/activities/piano_composition/NoteNotations.js" as NoteNotations

Item {
    id: multipleStaff

    property int nbStaves
    property string clef
    property int distanceBetweenStaff: multipleStaff.height / 3.3

    // Stores the note index which is selected.
    property int selectedIndex: -1
    property var coloredNotes: []
    property string notesColor: "inbuilt"
    property bool noteHoverEnabled: true
    property bool centerNotesPosition: false
    property bool isPulseMarkerDisplayed: false
    property bool noteAnimationEnabled: false
    readonly property bool isMusicPlaying: musicTimer.running

    property alias flickableStaves: flickableStaves
    property alias musicElementModel: musicElementModel
    property alias musicElementRepeater: musicElementRepeater
    property real flickableTopMargin: multipleStaff.height / 14 + distanceBetweenStaff / 3.5
    readonly property real pulseMarkerX: pulseMarker.x
    readonly property bool isPulseMarkerRunning: pulseMarkerAnimation.running
    property bool isFlickable: true
    property bool enableNotesSound: true
    property int currentEnteringStaff: 0
    property real firstCenteredNotePosition: multipleStaff.width / 3.3
    property real spaceBetweenCenteredNotes: 0

    /**
     * Emitted when a note is clicked.
     *
     * It is used for selecting note to play, erase and do other operations on it.
     */
    signal noteClicked(int noteIndex)

    /**
     * Emitted when the animation of the note from the right of the staff to the left is finished.
     *
     * It's used in note_names activity.
     */
    signal noteAnimationFinished

    /**
     * Emitted when the pulseMarker's animation is finished.
     */
    signal pulseMarkerAnimationFinished

    /**
     * Used in play_rhythm activity. It tells the instants when pulseMarker reaches a note and the drum sound is to be played.
     */
    signal playDrumSound

    ListModel {
        id: musicElementModel
    }

    Flickable {
        id: flickableStaves
        interactive: multipleStaff.isFlickable
        flickableDirection: Flickable.VerticalFlick
        contentWidth: staffColumn.width
        contentHeight: staffColumn.height + distanceBetweenStaff
        anchors.fill: parent
        clip: true
        Behavior on contentY {
            NumberAnimation { duration: 250 }
        }

        Column {
            id: staffColumn
            spacing: distanceBetweenStaff
            anchors.top: parent.top
            anchors.topMargin: flickableTopMargin
            Repeater {
                id: staves
                model: nbStaves
                Staff {
                    id: staff
                    height: multipleStaff.height / 5
                    width: multipleStaff.width - 5
                    lastPartition: index == (nbStaves - 1)
                }
            }
        }

        Repeater {
            id: musicElementRepeater
            model: musicElementModel
            MusicElement {
                id: musicElement
                noteName: noteName_
                noteType: noteType_
                highlightWhenPlayed: highlightWhenPlayed_
                noteIsColored: multipleStaff.coloredNotes.indexOf(noteName[0]) != -1
                soundPitch: soundPitch_
                clefType: clefType_
                elementType: elementType_
                isDefaultClef: isDefaultClef_

                property int staffNb: staffNb_
                property alias noteAnimation: noteAnimation
                // The shift which the elements experience when a sharp/flat note is added before them.
                readonly property real sharpShiftDistance: blackType != "" ? width / 6 : 0

                noteDetails: multipleStaff.getNoteDetails(noteName, noteType, clefType)

                MouseArea {
                    id: noteMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: multipleStaff.noteClicked(index)
                }

                function highlightNote() {
                    highlightTimer.start()
                }

                readonly property real defaultXPosition: musicElementRepeater.itemAt(index - 1) ? (musicElementRepeater.itemAt(index - 1).width + musicElementRepeater.itemAt(index - 1).x)
                                                                                                : 0

                x: {
                    if(multipleStaff.noteAnimationEnabled)
                        return NaN
                    // !musicElementRepeater.itemAt(index - 1) acts as a fallback condition when there is no previous element present. It happens when Qt clears the model internally.
                    if(isDefaultClef || !musicElementRepeater.itemAt(index - 1))
                        return 0
                    else if(musicElementRepeater.itemAt(index - 1).elementType === "clef") {
                        if(centerNotesPosition)
                            return sharpShiftDistance + defaultXPosition + multipleStaff.firstCenteredNotePosition
                        else
                            return sharpShiftDistance + defaultXPosition + 10
                    }
                    else
                        return sharpShiftDistance + defaultXPosition + multipleStaff.spaceBetweenCenteredNotes
                }

                onYChanged: {
                    if(noteAnimationEnabled && elementType === "note")
                        noteAnimation.start()
                }

                y: {
                    if(elementType === "clef")
                        return flickableTopMargin + staves.itemAt(staffNb).y
                    else if(noteDetails === undefined || staves.itemAt(staffNb) == undefined)
                        return 0

                    var verticalDistanceBetweenLines = staves.itemAt(0).verticalDistanceBetweenLines
                    var shift =  -verticalDistanceBetweenLines / 2
                    var relativePosition = noteDetails.positionOnStaff
                    var imageY = flickableTopMargin + staves.itemAt(staffNb).y + 2 * verticalDistanceBetweenLines

                    if(rotation === 180) {
                        return imageY - (4 - relativePosition) * verticalDistanceBetweenLines + shift
                    }

                    return imageY - (6 - relativePosition) * verticalDistanceBetweenLines + shift
                }

                NumberAnimation {
                    id: noteAnimation
                    target: musicElement
                    properties: "x"
                    duration: 9000
                    from: multipleStaff.width - 10
                    to: musicElement.clefImageWidth
                    onStopped: {
                        noteAnimationFinished()
                    }
                }
            }
        }

        Image {
            id: secondStaffDefaultClef
            sourceSize.width: musicElementModel.count ? musicElementRepeater.itemAt(0).clefImageWidth : 0
            y: staves.count === 2 ? flickableTopMargin + staves.itemAt(1).y : 0
            visible: (currentEnteringStaff === 0) && (nbStaves === 2)
            source: background.clefType ? "qrc:/gcompris/src/activities/piano_composition/resource/" + background.clefType.toLowerCase() + "Clef.svg"
                                        : ""
        }
    }

    Rectangle {
        id: pulseMarker
        width: activity.horizontalLayout ? 5 : 3
        border.width: width / 2
        height: staves.itemAt(0) == undefined ? 0 : 4 * staves.itemAt(0).verticalDistanceBetweenLines + width
        opacity: isPulseMarkerDisplayed && pulseMarkerAnimation.running
        color: "red"
        y: flickableTopMargin

        property real nextPosition: 0

        NumberAnimation {
            id: pulseMarkerAnimation
            target: pulseMarker
            property: "x"
            to: pulseMarker.nextPosition
            onStopped: {
                if(pulseMarker.x === multipleStaff.width)
                    pulseMarkerAnimationFinished()
                else
                    playDrumSound()
            }
        }
    }

    /**
     * Initializes the default clefs on the staves.
     *
     * @param clefType: The clef type to be initialized.
     */
    function initClefs(clefType) {
        musicElementModel.clear()
        musicElementModel.append({ "elementType_": "clef", "clefType_": clefType, "staffNb_": 0, "isDefaultClef_": true,
                                   "noteName_": "", "noteType_": "", "soundPitch_": clefType,
                                   "highlightWhenPlayed_": false })
    }

    /**
     * Pauses the sliding animation of the notes.
     */
    function pauseNoteAnimation() {
        for(var i = 0; i < musicElementModel.count; i++) {
            if(musicElementRepeater.itemAt(i).noteAnimation.running)
                musicElementRepeater.itemAt(i).noteAnimation.pause()
        }
    }

    function resumeNoteAnimation() {
        for(var i = 0; i < musicElementModel.count; i++) {
            musicElementRepeater.itemAt(i).noteAnimation.resume()
        }
    }

    /**
     * Gets all the details of any note like note image, position on staff etc. from NoteNotations.
     */
    function getNoteDetails(noteName, noteType, clefType) {
        var notesDetails = NoteNotations.get()
        var noteNotation
        if(noteType === "Rest")
            noteNotation = noteName + noteType
        else
            noteNotation = clefType + noteName

        for(var i = 0; i < notesDetails.length; i++) {
            if(noteNotation === notesDetails[i].noteName) {
                return notesDetails[i]
            }
        }
    }

    /**
     * Adds a note to the staff.
     */
    function addMusicElement(elementType, noteName, noteType, highlightWhenPlayed, playAudio, clefType, soundPitch, isUnflicked) {
        if(soundPitch == undefined || soundPitch === "")
            soundPitch = clefType

        var isNextStaff = (selectedIndex == -1) && musicElementModel.count && ((staves.itemAt(0).width - musicElementRepeater.itemAt(musicElementModel.count - 1).x - musicElementRepeater.itemAt(musicElementModel.count - 1).width) < musicElementRepeater.itemAt(0).clefImageWidth)

        // If the incoming element is a clef, make sure that there is enough required space to fit one more note too. Else it creates problem when the note is erased and the view is redrawn, else move on to the next staff.
        if(elementType === "clef" && musicElementModel.count && (selectedIndex == -1)) {
            if(staves.itemAt(0).width - musicElementRepeater.itemAt(musicElementModel.count - 1).x - musicElementRepeater.itemAt(musicElementModel.count - 1).width - 2 * Math.max(musicElementRepeater.itemAt(0).clefImageWidth, musicElementRepeater.itemAt(0).noteImageWidth)  < 0)
                isNextStaff = true
        }

        if(isNextStaff && !noteAnimationEnabled) {
            multipleStaff.currentEnteringStaff++
            if(multipleStaff.currentEnteringStaff >= multipleStaff.nbStaves)
                multipleStaff.nbStaves++
            // When a new staff is added, initialise it with a default clef.
            musicElementModel.append({"noteName_": "", "noteType_": "", "soundPitch_": soundPitch,
                                      "clefType_": clefType, "highlightWhenPlayed_": false,
                                      "staffNb_": multipleStaff.currentEnteringStaff,
                                      "isDefaultClef_": true, "elementType_": "clef"})

            if(!isUnflicked)
                flickableStaves.flick(0, - nbStaves * multipleStaff.height)

            if(elementType === "clef")
                return 0

            isNextStaff = false
        }

        if(selectedIndex === -1) {
            var isDefualtClef = false
            if(!musicElementModel.count)
                isDefualtClef = true
            musicElementModel.append({"noteName_": noteName, "noteType_": noteType, "soundPitch_": soundPitch,
                                      "clefType_": clefType, "highlightWhenPlayed_": highlightWhenPlayed,
                                      "staffNb_": multipleStaff.currentEnteringStaff,
                                      "isDefaultClef_": isDefualtClef, "elementType_": elementType})

        }
        else {
            var tempModel = createNotesBackup()
            var insertingIndex = selectedIndex + 1
            if(elementType === "clef")
                insertingIndex--

            tempModel.splice(insertingIndex, 0, {"elementType_": elementType, "noteName_": noteName, "noteType_": noteType,
                                                                  "soundPitch_": soundPitch, "clefType_": clefType })
            if(elementType === "clef") {
                for(var i = 0; i < musicElementModel.count && tempModel[i]["elementType_"] != "clef"; i++)
                    tempModel[i]["soundPitch_"] = clefType
            }
            selectedIndex = -1

            redraw(tempModel)
        }

        multipleStaff.selectedIndex = -1
        background.clefType = musicElementModel.get(musicElementModel.count - 1).soundPitch_

        if(playAudio)
            playNoteAudio(noteName, noteType, soundPitch, musicElementRepeater.itemAt(musicElementModel.count - 1).duration)
    }

    /**
     * Creates a backup of the musicElementModel before erasing it.
     *
     * This backup data is used to redraw the notes.
     */
    function createNotesBackup() {
        var tempModel = []
        for(var i = 0; i < musicElementModel.count; i++)
            tempModel.push(JSON.parse(JSON.stringify(musicElementModel.get(i))))

        return tempModel
    }

    /**
     * Redraws all the notes on the staves.
     */
    function redraw(notes) {
        musicElementModel.clear()
        currentEnteringStaff = 0
        selectedIndex = -1
        for(var i = 0; i < notes.length; i++) {
            addMusicElement(notes[i]["elementType_"], notes[i]["noteName_"], notes[i]["noteType_"], false, false, notes[i]["clefType_"], notes[i]["soundPitch_"], true)
        }

        // Remove the remaining unused staffs.
        if((multipleStaff.currentEnteringStaff + 1 < multipleStaff.nbStaves) && (multipleStaff.nbStaves > 2)) {
            nbStaves = multipleStaff.currentEnteringStaff + 1
            flickableStaves.flick(0, - nbStaves * multipleStaff.height)
        }

        if(musicElementModel.get(musicElementModel.count - 1).isDefaultClef_ && nbStaves > 2)
            musicElementModel.remove(musicElementModel.count - 1)

        if(musicElementModel.get(musicElementModel.count - 1).staffNb_ < nbStaves - 1 && nbStaves != 2)
            nbStaves = musicElementModel.get(musicElementModel.count - 1).staffNb_ + 1

        currentEnteringStaff = musicElementModel.get(musicElementModel.count - 1).staffNb_
        background.clefType = musicElementModel.get(musicElementModel.count - 1).soundPitch_
    }

    /**
     * Erases the selected note.
     *
     * @param noteIndex: index of the note to be erased
     */
    function eraseNote(noteIndex) {
        musicElementModel.remove(noteIndex)
        selectedIndex = -1
        var tempModel = createNotesBackup()
        redraw(tempModel)
    }

    /**
     * Erases all the notes.
     */
    function eraseAllNotes() {
        musicElementModel.clear()
        selectedIndex = -1
        multipleStaff.currentEnteringStaff = 0
        initClefs(background.clefType)
    }

    /**
     * Plays audio for a note.
     *
     * @param noteName: name of the note to be played.
     * @param noteType: note type to be played.
     */
    function playNoteAudio(noteName, noteType, soundPitch, duration) {
        if(noteName) {
            if(noteType != "Rest") {
                // We should find a corresponding b type enharmonic notation for # type note to play the audio.
                if(noteName[1] === "#") {
                    var blackKeysFlat = piano.blackKeyFlatNotes
                    var blackKeysSharp = piano.blackKeySharpNotes

                    for(var i = 0; i < blackKeysSharp.length; i++) {
                        if(blackKeysSharp[i][0] === noteName) {
                            noteName = blackKeysFlat[i][0]
                            break
                        }
                    }
                }
                audioLooper.stop()
                var noteToPlay = "qrc:/gcompris/src/activities/piano_composition/resource/" + soundPitch.toLowerCase() + "_pitches/" + noteName + ".wav"
                audioLooper.playMusic(noteToPlay, duration)
            }
        }
    }

    Timer {
        id: audioLooper

        signal playMusic(string noteToPlay, int duration)
        property string audio
        property int loopCounter

        onPlayMusic: {
            audio = noteToPlay
            audioLooper.interval = Math.min(1000, duration)
            loopCounter = Math.ceil(duration / 1000)
            start()
        }
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if(--loopCounter < 0)
                stop()
            else
                items.audioEffects.play(audio)
        }
        onRunningChanged: {
            if(!running) {
                items.audioEffects.stop()
            }
        }
    }

    /**
     * Get all the notes from the musicElementModel and returns the melody.
     */
    function getAllNotes() {
        var notes = createNotesBackup()
        return notes
    }

    /**
     * Loads melody from the provided data, to the staffs.
     *
     * @param data: melody to be loaded
     */
    function loadFromData(data) {
        if(data != undefined) {
            var melody = data.split(" ")
            background.clefType = melody[0]
            eraseAllNotes()
            for(var i = 1 ; i < melody.length; ++i) {
                var noteLength = melody[i].length
                var noteName = melody[i][0]
                var noteType
                if(melody[i].substring(noteLength - 4, noteLength) === "Rest") {
                    noteName = melody[i].substring(0, noteLength - 4)
                    noteType = "Rest"
                }
                else if(melody[i][1] === "#" || melody[i][1] === "b") {
                    noteType = melody[i].substring(3, melody[i].length)
                    noteName += melody[i][1] + melody[i][2];
                }
                else {
                    noteType = melody[i].substring(2, melody[i].length)
                    noteName += melody[i][1]
                }
                addMusicElement("note", noteName, noteType, false, false, melody[0])
            }
            var tempModel = createNotesBackup()
            redraw(tempModel)
        }
    }

    /**
     * Used in the activity play_piano.
     *
     * Checks if the answered note is correct
     */
    function indicateAnsweredNote(isCorrectAnswer, noteIndexAnswered) {
        musicElementRepeater.itemAt(noteIndexAnswered).noteAnswered = true
        musicElementRepeater.itemAt(noteIndexAnswered).isCorrectlyAnswered = isCorrectAnswer
    }

    /**
     * Used in the activity play_piano.
     *
     * Reverts the previous answer.
     */
    function revertAnswer(noteIndexReverting) {
        musicElementRepeater.itemAt(noteIndexReverting).noteAnswered = false
    }

    function play() {
        musicTimer.currentNote = 0
        selectedIndex = -1
        musicTimer.interval = 1
        if(isFlickable)
            flickableStaves.flick(0, nbStaves * multipleStaff.height)

        pulseMarkerAnimation.stop()

        if(musicElementModel.count > 1)
            pulseMarker.x = musicElementRepeater.itemAt(1).x + musicElementRepeater.itemAt(1).width / 2
        else
            pulseMarker.x = 0

        musicTimer.start()
    }

    /**
     * Stops the audios playing.
     */
    function stopAudios() {
        musicElementModel.clear()
        musicTimer.stop()
        items.audioEffects.stop()
    }

    Timer {
        id: musicTimer

        property int currentNote: 0

        onRunningChanged: {
            if(!running && musicElementModel.get(currentNote) !== undefined) {
                var currentType = musicElementModel.get(currentNote).noteType_
                var note = musicElementModel.get(currentNote).noteName_
                var soundPitch = musicElementModel.get(currentNote).soundPitch_
                var currentStaff = musicElementModel.get(currentNote).staffNb_
                background.clefType = musicElementModel.get(currentNote).clefType_

                if(musicElementModel.get(currentNote).isDefaultClef_ && currentStaff > 1) {
                    flickableStaves.contentY = staves.itemAt(currentStaff - 1).y
                }

                musicTimer.interval = musicElementRepeater.itemAt(currentNote).duration
                if(multipleStaff.enableNotesSound)
                    playNoteAudio(note, currentType, soundPitch, musicTimer.interval)
                pulseMarkerAnimation.stop()
                pulseMarkerAnimation.duration = Math.max(1, musicTimer.interval)
                if(musicElementRepeater.itemAt(currentNote + 1) != undefined)
                    pulseMarker.nextPosition = musicElementRepeater.itemAt(currentNote + 1).x + musicElementRepeater.itemAt(currentNote + 1).width / 2
                else
                    pulseMarker.nextPosition = multipleStaff.width

                pulseMarkerAnimation.start()

                if(!isPulseMarkerDisplayed)
                    musicElementRepeater.itemAt(currentNote).highlightNote()
                currentNote++
                musicTimer.start()
            }
        }
    }
}
