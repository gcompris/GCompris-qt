/* GCompris - MultipleStaff.qml
 *
 * SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/activities/piano_composition/NoteNotations.js" as NoteNotations

Item {
    id: multipleStaff

    property int nbStaves
    property string clef
    property int distanceBetweenStaff: multipleStaff.height / 3.3
    readonly property real clefImageWidth: 3 * height / 25

    // Stores the note index which is selected.
    property int selectedIndex: -1

    // The notes that are to be colored can be assigned to this variable in the activity
    property var coloredNotes: []

    // When the notesColor is inbuilt, the default color mapping will be done, else assign any color externally in the activity. Example: Reference notes in note_names are red colored.
    property string notesColor: "inbuilt"
    property bool noteHoverEnabled: false

    // Stores if the notes are to be centered on the staff. Used in Play_piano and Play_rhythm.
    property bool centerNotesPosition: false
    property bool isPulseMarkerDisplayed: false
    property bool noteAnimationEnabled: false
    readonly property bool isMusicPlaying: musicTimer.running

    property alias flickableStaves: flickableStaves
    property alias musicElementModel: musicElementModel
    property alias musicElementRepeater: musicElementRepeater
    property double softColorOpacity : 0.8
    property real flickableTopMargin: multipleStaff.height / 14 + distanceBetweenStaff / 3.5
    readonly property real pulseMarkerX: pulseMarker.x
    readonly property bool isPulseMarkerRunning: pulseMarkerAnimation.running
    property bool isFlickable: true
    property bool enableNotesSound: true
    property int currentEnteringStaff: 0
    property int bpmValue: 120
    property real noteAnimationDuration: 9000

    // The position where the 1st note in the centered state is to be placed.
    property real firstCenteredNotePosition: multipleStaff.width / 3.3
    property real spaceBetweenNotes: 0

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
                        return sharpShiftDistance + defaultXPosition + multipleStaff.spaceBetweenNotes
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
                    duration: noteAnimationDuration
                    from: multipleStaff.width - 10
                    to: multipleStaff.clefImageWidth
                    onStopped: {
                        noteAnimationFinished()
                    }
                }
            }
        }

        Image {
            id: secondStaffDefaultClef
            sourceSize.width: musicElementModel.count ? multipleStaff.clefImageWidth : 0
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
            onStarted: {
                if(pulseMarker.height == 0 && staves.count != 0) {
                    pulseMarker.height = Qt.binding(function() {return 4 * staves.itemAt(0).verticalDistanceBetweenLines + pulseMarker.width;})
                }
            }
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

        var isNextStaff = (selectedIndex == -1) && musicElementModel.count && ((staves.itemAt(0).width - musicElementRepeater.itemAt(musicElementModel.count - 1).x - musicElementRepeater.itemAt(musicElementModel.count - 1).width) < multipleStaff.clefImageWidth)

        // If the incoming element is a clef, make sure that there is enough required space to fit one more note too. Else it creates problem when the note is erased and the view is redrawn, else move on to the next staff.
        if(elementType === "clef" && musicElementModel.count && (selectedIndex == -1)) {
            if(staves.itemAt(0).width - musicElementRepeater.itemAt(musicElementModel.count - 1).x - musicElementRepeater.itemAt(musicElementModel.count - 1).width - 2 * Math.max(multipleStaff.clefImageWidth, musicElementRepeater.itemAt(0).noteImageWidth)  < 0)
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
            var isDefaultClef = false
            if(!musicElementModel.count)
                isDefaultClef = true
            musicElementModel.append({"noteName_": noteName, "noteType_": noteType, "soundPitch_": soundPitch,
                                      "clefType_": clefType, "highlightWhenPlayed_": highlightWhenPlayed,
                                      "staffNb_": multipleStaff.currentEnteringStaff,
                                      "isDefaultClef_": isDefaultClef, "elementType_": elementType})

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
            var note = notes[i]
            // On load melody from file, the first "note" is the BPM value
            if(note.bpm) {
                bpmValue = note.bpm;
            }
            else {
                addMusicElement(note["elementType_"], note["noteName_"], note["noteType_"], false, false, note["clefType_"], note["soundPitch_"], true)
            }
        }

        // Remove the remaining unused staffs.
        if((multipleStaff.currentEnteringStaff + 1 < multipleStaff.nbStaves) && (multipleStaff.nbStaves > 2)) {
            nbStaves = multipleStaff.currentEnteringStaff + 1
            flickableStaves.flick(0, - nbStaves * multipleStaff.height)
        }

        var lastMusicElement = musicElementModel.get(musicElementModel.count - 1)
        if(lastMusicElement.isDefaultClef_ && nbStaves > 2) {
            musicElementModel.remove(musicElementModel.count - 1)
            lastMusicElement = musicElementModel.get(musicElementModel.count - 1)
        }

        if(lastMusicElement.staffNb_ < nbStaves - 1 && nbStaves != 2)
            nbStaves = lastMusicElement.staffNb_ + 1

        currentEnteringStaff = lastMusicElement.staffNb_
        background.clefType = lastMusicElement.soundPitch_
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

    readonly property var octave1MidiNumbersTable: {"C":24,"C#":25,"Db":25,"D":26,"D#":27,"Eb":27,"E":28,"F":29,"F#":30,"Gb":30,"G":31,"G#":32,"Ab":32,"A":33,"A#":34,"Bb":34,"B":35}
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
                    var blackKeysFlat = piano.blackKeyFlatNoteLabelsArray
                    var blackKeysSharp = piano.blackKeySharpNoteLabelsArray

                    for(var i = 0; i < blackKeysSharp.length; i++) {
                        if(blackKeysSharp[i][0] === noteName) {
                            noteName = blackKeysFlat[i][0]
                            break
                        }
                    }
                }

                var octaveNb = ""
                var noteCharName = ""
                if(noteName[1] == "#" || noteName[1] == "b") {
                    noteCharName = noteName[0] + noteName[1]
                    octaveNb = noteName[2]
                }
                else
                {
                    noteCharName = noteName[0]
                    octaveNb = noteName[1]
                }
                var noteMidiName = (octaveNb-1)*12 + octave1MidiNumbersTable[noteCharName];

                GSynth.generate(noteMidiName, duration)
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

    function stopPlaying() {
        musicTimer.currentNote = -1
        musicTimer.stop()
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
                var currentElement = musicElementModel.get(currentNote)
                var currentType = currentElement.noteType_
                var note = currentElement.noteName_
                var soundPitch = currentElement.soundPitch_
                var currentStaff = currentElement.staffNb_
                background.clefType = currentElement.clefType_

                if(currentElement.isDefaultClef_ && currentStaff > 1) {
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
