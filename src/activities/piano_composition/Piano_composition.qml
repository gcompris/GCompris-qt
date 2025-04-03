/* GCompris - Piano_composition.qml
 *
 * SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Refactoring)
 * 
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "piano_composition.js" as Activity
import "melodies.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

    pageComponent: Rectangle {
        id: activityBackground
        anchors.fill: parent
        color: GCStyle.lightBlueBg
        signal start
        signal stop

        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false
        readonly property bool horizontalLayout: activityBackground.width >= activityBackground.height

        property bool activityStopped: false


        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Keys.onPressed: (event) => {
            var keyboardBindings = {}
            keyboardBindings[Qt.Key_1] = 0
            keyboardBindings[Qt.Key_2] = 1
            keyboardBindings[Qt.Key_3] = 2
            keyboardBindings[Qt.Key_4] = 3
            keyboardBindings[Qt.Key_5] = 4
            keyboardBindings[Qt.Key_6] = 5
            keyboardBindings[Qt.Key_7] = 6
            keyboardBindings[Qt.Key_F2] = 1
            keyboardBindings[Qt.Key_F3] = 2
            keyboardBindings[Qt.Key_F5] = 4
            keyboardBindings[Qt.Key_F6] = 5
            keyboardBindings[Qt.Key_F7] = 6

            if(event.key >= Qt.Key_1 && event.key <= Qt.Key_7) {
                piano.keyRepeater.playKey(keyboardBindings[event.key], "white");
            }
            else if(event.key >= Qt.Key_F2 && event.key <= Qt.Key_F7) {
                if(piano.blackKeysEnabled)
                    piano.keyRepeater.playKey(keyboardBindings[event.key], "black");
            }
            if(event.key === Qt.Key_Left && shiftKeyboardLeft.visible) {
                piano.currentOctaveNb--
            }
            if(event.key === Qt.Key_Right && shiftKeyboardRight.visible) {
                piano.currentOctaveNb++
            }
            if(event.key === Qt.Key_Delete) {
                optionsRow.clearButtonClicked()
            }
            if(event.key === Qt.Key_Backspace) {
                optionsRow.undoButtonClicked()
            }
            if(event.key === Qt.Key_Space) {
                optionsRow.playButtonClicked()
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias multipleStaff: multipleStaff
            property string staffLength: "short"
            property alias melodyList: melodyList
            property alias file: file
            property alias piano: piano
            property alias optionsRow: optionsRow
            property alias lyricsArea: lyricsArea
        }

        onStart: {
            Activity.start(items);
            if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled) {
                    activityBackground.audioDisabled = true;
            }
        }
        onStop: {
            activityStopped = true;
            Activity.stop();
        }

        property string currentType: "Quarter"
        property string restType: "Whole"
        property string clefType: items.currentLevel == 1 ? "Bass" : "Treble"
        property bool isLyricsMode: (optionsRow.lyricsOrPianoModeIndex === 1) && optionsRow.lyricsOrPianoModeOptionVisible

        File {
            id: file
            onError: (msg) => console.error("File error: " + msg)
        }

        GCTextPanel {
            id: messagePanel
            panelWidth: Math.min(activityBackground.width / 6, optionsRow.iconsWidth * 3)
            panelHeight: Math.min(panelWidth * 0.5, optionsRow.iconsWidth)
            fixedHeight: true
            anchors.top: optionsRow.bottom
            anchors.topMargin: GCStyle.tinyMargins
            anchors.horizontalCenter: optionsRow.horizontalCenter
            textItem.fontSize: textItem.smallSize
            opacity: 0
            z: 5

            signal show(string message)
            onShow: (message) => {
                messagePanel.textItem.text = message
                messageAnimation.stop()
                messageAnimation.start()
            }

            SequentialAnimation {
                id: messageAnimation
                onStarted: messagePanel.opacity = 1
                PauseAnimation {
                    duration: 1000
                }
                NumberAnimation {
                    targets: messagePanel
                    property: "opacity"
                    to: 0
                    duration: 200
                }
                onStopped: {
                    messagePanel.opacity = 0
                }
            }
        }

        MelodyList {
            id: melodyList
            onClose: {
                visible = false
                piano.enabled = true
                focus = false
                activity.focus = true
            }
        }

        Rectangle {
            id: instructionBox
            radius: GCStyle.halfMargins
            width: activityBackground.horizontalLayout ? activityBackground.width * 0.75 : activityBackground.width - 2 * (optionsRow.iconsWidth + GCStyle.halfMargins)
            height: activityBackground.height * 0.15
            anchors.top: parent.top
            anchors.right: parent.right
            border.width: GCStyle.thinBorder
            color: GCStyle.lightBg
            border.color: GCStyle.blueBorder

            GCText {
                id: instructionText
                color: GCStyle.darkText
                z: 3
                anchors.fill: parent
                anchors.margins: GCStyle.halfMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                text: Activity.instructions[items.currentLevel].text
            }
        }

        MultipleStaff {
            id: multipleStaff
            nbStaves: 2
            visibleStaves: 2
            clef: clefType
            coloredNotes: ['C','D', 'E', 'F', 'G', 'A', 'B']
            noteHoverEnabled: true
            anchors.margins: GCStyle.halfMargins

            onNoteClicked: (noteIndex) => {
                if(selectedIndex === noteIndex)
                    selectedIndex = -1
                else {
                    selectedIndex = noteIndex
                    activityBackground.clefType = musicElementModel.get(selectedIndex).soundPitch_
                    playNoteAudio(musicElementModel.get(selectedIndex).noteName_, musicElementModel.get(selectedIndex).noteType_, activityBackground.clefType, musicElementRepeater.itemAt(selectedIndex).duration)
                }
            }

            // redraw notes on width/height changed to ensure all notes are visible and staves are filled.
            onWidthChanged: {
                if(!activityBackground.activityStopped) {
                    redrawTimer.restart();
                }
            }
            onHeightChanged: {
                if(!activityBackground.activityStopped) {
                    redrawTimer.restart();
                }
            }
        }

        Timer {
            id: redrawTimer
            interval: 500
            onTriggered: {
                if(multipleStaff.musicElementModel.count > 0) {
                    // redraw twice as sometimes on the first try some items are overlapped on first staff...
                    var notes = multipleStaff.createNotesBackup();
                    multipleStaff.redraw(notes);
                    multipleStaff.redraw(notes);
                }
            }
        }

        GCButtonScroll {
            id: multipleStaffFlickButton
            anchors.left: multipleStaff.right
            anchors.verticalCenter: multipleStaff.verticalCenter
            width: bar.height * 0.3
            height: width * 2
            onUp: multipleStaff.flickableStaves.flick(0, multipleStaff.height * 1.3)
            onDown: multipleStaff.flickableStaves.flick(0, -multipleStaff.height * 1.3)
            upVisible: multipleStaff.flickableStaves.atYBeginning ? false : true
            downVisible: multipleStaff.flickableStaves.atYEnd ? false : true
        }

        Item {
            id: pianoLayout
            width: multipleStaff.width + multipleStaffFlickButton.width
            height: multipleStaff.height
            anchors.margins: GCStyle.halfMargins

            PianoOctaveKeyboard {
                id: piano
                height: parent.height
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                blackLabelsVisible: [3, 4, 5, 6, 7, 8].indexOf(items.currentLevel + 1) == -1 ? false : true
                useSharpNotation: items.currentLevel != 3
                blackKeysEnabled: items.currentLevel > 1
                visible: !activityBackground.isLyricsMode
                currentOctaveNb: 1

                onNoteClicked: (note) => {
                    parent.addMusicElementAndPushToStack(note, currentType)
                }
            }

            function addMusicElementAndPushToStack(noteName, noteType, elementType) {
                if(noteType === "Rest") {
                    elementType = "rest"
                } else if(elementType === undefined) {
                    elementType = "note"
                }

                var tempModel = multipleStaff.createNotesBackup()
                Activity.pushToStack(tempModel)
                multipleStaff.addMusicElement(elementType, noteName, noteType, false, true, activityBackground.clefType)
            }

            Image {
                id: shiftKeyboardLeft
                source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
                sourceSize.width: parent.width * 0.1
                width: sourceSize.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                visible: (piano.currentOctaveNb > 0) && piano.visible
                anchors.right: piano.left
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: piano.currentOctaveNb--
                }
            }

            Image {
                id: shiftKeyboardRight
                source: "qrc:/gcompris/src/core/resource/bar_next.svg"
                sourceSize.width: parent.width * 0.1
                width: sourceSize.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                visible: (piano.currentOctaveNb < piano.maxNbOctaves - 1) && piano.visible
                anchors.left: piano.right
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: piano.currentOctaveNb++
                }
            }

            LyricsArea {
                id: lyricsArea
                width: parent.width
                height: parent.height
                anchors.fill: pianoLayout
            }

        }

        GCCreationHandler {
            id: creationHandler
            onFileLoaded: (data, filePath) => {
                // We need to draw the notes twice since we first need to count the number of staffs needed for the melody (we get that from
                // the 1st redraw call), then we redraw the 2nd time to actually display the notes perfectly. This is done because for some reason, the
                // staves model is updated slower than the addition of notes, so the notes aggregates in their default position instead of
                // their required position, due to unavailability of the updated staff at that instant. So calculating the number of required staffs first seems the only solution for now.
                multipleStaff.redraw(data)
                multipleStaff.redraw(data)
                lyricsArea.resetLyricsArea()
            }
            onClose: {
                optionsRow.lyricsOrPianoModeIndex = 0
            }
        }

        OptionsRow {
            id: optionsRow
            anchors.margins: GCStyle.halfMargins
            anchors.left: activityBackground.left
            iconsWidth: 0
            noteOptionsVisible: items.currentLevel > 3
            playButtonVisible: true
            keyOption.clefButtonVisible: items.currentLevel > 1
            clearButtonVisible: true
            undoButtonVisible: true
            openButtonVisible: items.currentLevel > 5
            saveButtonVisible: items.currentLevel > 5
            changeAccidentalStyleButtonVisible: items.currentLevel >= 3
            lyricsOrPianoModeOptionVisible: items.currentLevel > 5
            restOptionsVisible: items.currentLevel > 4
            bpmVisible: true

            onUndoButtonClicked: {
                Activity.undoChange()
            }
            onClearButtonClicked: {
                if((multipleStaff.musicElementModel.count > 1) && multipleStaff.selectedIndex === -1) {
                    Core.showMessageDialog(activity,
                        qsTr("You have not selected any note. Do you want to erase all the notes?"),
                        qsTr("Yes"), function() {
                            Activity.undoStack = []
                            lyricsArea.resetLyricsArea()
                           multipleStaff.eraseAllNotes()
                           multipleStaff.nbStaves = 2
                        },
                        qsTr("No"), null,
                        null
                    )
                }
                else if((multipleStaff.musicElementModel.count > 1) && !multipleStaff.musicElementModel.get(multipleStaff.selectedIndex).isDefaultClef_) {
                    var noteIndex = multipleStaff.selectedIndex
                    var tempModel = multipleStaff.createNotesBackup()
                    Activity.pushToStack(tempModel)
                    multipleStaff.eraseNote(noteIndex)
                }
            }
            onOpenButtonClicked: {
                dialogActivityConfig.active = true
                displayDialog(dialogActivityConfig)
            }
            onSaveButtonClicked: {
                var notesToSave = multipleStaff.createNotesBackup()
                // add bpm at start
                notesToSave.unshift({"bpm": multipleStaff.bpmValue});
                creationHandler.saveWindow(notesToSave)
            }
            keyOption.onClefAdded: {
                var insertingIndex = multipleStaff.selectedIndex === -1 ? multipleStaff.musicElementModel.count : multipleStaff.selectedIndex
                var tempModel = multipleStaff.createNotesBackup()
                Activity.pushToStack(tempModel)
                multipleStaff.addMusicElement("clef", "", "", false, false, activityBackground.clefType)
                piano.currentOctaveNb = 1
            }
            onBpmDecreased: {
                if(multipleStaff.bpmValue - 1 >= 1)
                    multipleStaff.bpmValue--
            }
            onBpmIncreased: {
                multipleStaff.bpmValue++
            }
            onEmitOptionMessage: (message) => messagePanel.show(message)
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            content: Component {
                Column {
                    id: column
                    spacing: GCStyle.baseMargins
                    width: dialogActivityConfig.width - 2 * GCStyle.baseMargins

                    GCText {
                        text: qsTr("Select the type of melody to load.")
                        fontSizeMode: mediumSize
                    }

                    GCButton {
                        text: qsTr("Pre-defined melodies")
                        onClicked: {
                            melodyList.melodiesModel.clear()
                            var dataset = Dataset.get()
                            for(var i = 0; i < dataset.length; i++) {
                                melodyList.melodiesModel.append(dataset[i])
                            }
                            dialogActivityConfig.close()
                            melodyList.visible = true
                            piano.enabled = false
                            melodyList.forceActiveFocus()
                        }
                        width: 150 * ApplicationInfo.ratio
                        height: 60 * ApplicationInfo.ratio
                        theme: "dark"
                    }

                    GCButton {
                        text: qsTr("Your saved melodies")
                        onClicked: {
                            dialogActivityConfig.close()
                            creationHandler.loadWindow()
                        }
                        width: 150 * ApplicationInfo.ratio
                        height: 60 * ApplicationInfo.ratio
                        theme: "dark"
                    }
                }
            }
            onClose: home()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
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

        states: [
            State {
                name: "hScreen"
                when: horizontalLayout
                AnchorChanges {
                    target: optionsRow
                    anchors.top: instructionBox.bottom
                }
                PropertyChanges {
                    optionsRow {
                        columns: 11
                        iconsWidth: activityBackground.width / 15
                    }
                }
                AnchorChanges {
                    target: multipleStaff
                    anchors.left: activityBackground.horizontalCenter
                    anchors.top: optionsRow.bottom
                }
                PropertyChanges {
                    multipleStaff {
                        width: activityBackground.width * 0.5 - multipleStaffFlickButton.width - GCStyle.halfMargins * 3
                        height: activityBackground.height - instructionBox.height - optionsRow.height - bar.height - GCStyle.halfMargins * 4
                    }
                }
                AnchorChanges {
                    target: pianoLayout
                    anchors.left: activityBackground.left
                    anchors.top: optionsRow.bottom
                }
            },
            State {
                name: "vScreen"
                when: !horizontalLayout
                AnchorChanges {
                    target: optionsRow
                    anchors.top: activityBackground.top
                }
                PropertyChanges {
                    optionsRow {
                        columns: 1
                        iconsWidth: (activityBackground.height - bar.height) / 12
                    }
                }
                AnchorChanges {
                    target: multipleStaff
                    anchors.left: optionsRow.right
                    anchors.top: instructionBox.bottom
                }
                PropertyChanges {
                    multipleStaff {
                        width: activityBackground.width - multipleStaffFlickButton.width - optionsRow.width - GCStyle.halfMargins * 3
                        height: (activityBackground.height - instructionBox.height - bar.height - GCStyle.halfMargins * 4) * 0.5
                    }
                }
                AnchorChanges {
                    target: pianoLayout
                    anchors.left: optionsRow.right
                    anchors.top: multipleStaff.bottom
                }
            }
        ]

        Loader {
            id: audioNeededDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("This activity requires sound, so it will play some sounds even if the audio voices or effects are disabled in the main configuration.")
                button1Text: qsTr("Quit")
                button2Text: qsTr("Continue")
                onButton1Hit: activity.home();
                onClose: {
                    activityBackground.audioDisabled = false;
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
