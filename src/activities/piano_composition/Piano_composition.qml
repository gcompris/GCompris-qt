/* GCompris - Piano_composition.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
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
import QtQuick.Controls 1.5
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "piano_composition.js" as Activity
import "melodies.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

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
            var keyboardBindings = {}
            keyboardBindings[Qt.Key_1] = 0
            keyboardBindings[Qt.Key_2] = 1
            keyboardBindings[Qt.Key_3] = 2
            keyboardBindings[Qt.Key_4] = 3
            keyboardBindings[Qt.Key_5] = 4
            keyboardBindings[Qt.Key_6] = 5
            keyboardBindings[Qt.Key_7] = 6
            keyboardBindings[Qt.Key_F1] = 1
            keyboardBindings[Qt.Key_F2] = 2
            keyboardBindings[Qt.Key_F3] = 3
            keyboardBindings[Qt.Key_F4] = 4
            keyboardBindings[Qt.Key_F5] = 5

            if(event.key >= Qt.Key_1 && event.key <= Qt.Key_7) {
                piano.keyRepeater.itemAt(keyboardBindings[event.key]).whiteKey.keyPressed()
            }
            else if(event.key >= Qt.Key_F1 && event.key <= Qt.Key_F5) {
                if(piano.blackKeysEnabled)
                    findBlackKey(keyboardBindings[event.key])
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
                multipleStaff.play()
            }
        }

        function findBlackKey(keyNumber) {
            for(var i = 0; keyNumber; i++) {
                if(piano.keyRepeater.itemAt(i) == undefined)
                    break
                if(piano.keyRepeater.itemAt(i).blackKey.visible)
                    keyNumber--
                if(keyNumber == 0)
                    piano.keyRepeater.itemAt(i).blackKey.keyPressed()
            }
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
            property alias piano: piano
            property alias optionsRow: optionsRow
            property alias lyricsArea: lyricsArea
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property string currentType: "Quarter"
        property string restType: "Quarter"
        property string clefType: bar.level == 2 ? "Bass" : "Treble"
        property bool isLyricsMode: (optionsRow.lyricsOrPianoModeIndex === 1) && optionsRow.lyricsOrPianoModeOptionVisible

        File {
            id: file
            onError: console.error("File error: " + msg)
        }

        Item {
            id: clickedOptionMessage

            signal show(string message)
            onShow: {
                messageText.text = message
                messageAnimation.stop()
                messageAnimation.start()
            }

            width: horizontalLayout ? parent.width / 12 : parent.width / 6
            height: width * 0.4
            visible: false
            anchors.top: optionsRow.bottom
            anchors.horizontalCenter: optionsRow.horizontalCenter
            z: 5
            Rectangle {
                id: messageRectangle
                width: messageText.contentWidth + 5
                height: messageText.height + 5
                anchors.centerIn: messageText
                color: "black"
                opacity: 0.5
                border.width: 3
                border.color: "black"
                radius: 15
            }

            GCText {
                id: messageText
                anchors.fill: parent
                anchors.rightMargin: parent.width * 0.02
                anchors.leftMargin: parent.width * 0.02
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: "white"
            }

            SequentialAnimation {
                id: messageAnimation
                onStarted: clickedOptionMessage.visible = true
                PauseAnimation {
                    duration: 1000
                }
                NumberAnimation {
                    targets: [messageRectangle, messageText]
                    property: "opacity"
                    to: 0
                    duration: 200
                }
                onStopped: {
                    clickedOptionMessage.visible = false
                    messageRectangle.opacity = 0.5
                    messageText.opacity = 1
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
            radius: 10
            width: background.width * 0.75
            height: background.height * 0.15
            anchors.right: parent.right
            anchors.margins: 10
            opacity: 0.8
            border.width: 6
            color: "white"
            border.color: "#87A6DD"

            GCText {
                id: instructionText
                color: "black"
                z: 3
                anchors.fill: parent
                anchors.rightMargin: parent.width * 0.02
                anchors.leftMargin: parent.width * 0.02
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                text: Activity.instructions[bar.level - 1].text
            }
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.50 : parent.width * 0.6
            height: horizontalLayout ? parent.height * 0.58 : parent.height * 0.3
            nbStaves: 2
            clef: clefType
            coloredNotes: ['C','D', 'E', 'F', 'G', 'A', 'B']
            anchors.right: horizontalLayout ? parent.right: undefined
            anchors.horizontalCenter: horizontalLayout ? undefined : parent.horizontalCenter
            anchors.top: instructionBox.bottom
            anchors.topMargin: parent.height * 0.1
            anchors.rightMargin: parent.width * 0.043
            noteHoverEnabled: true
            onNoteClicked: {
                if(selectedIndex === noteIndex)
                    selectedIndex = -1
                else {
                    selectedIndex = noteIndex
                    background.clefType = musicElementModel.get(selectedIndex).soundPitch_
                    playNoteAudio(musicElementModel.get(selectedIndex).noteName_, musicElementModel.get(selectedIndex).noteType_, background.clefType, musicElementRepeater.itemAt(selectedIndex).duration)
                }
            }
        }

        GCButtonScroll {
            id: multipleStaffFlickButton
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

        PianoOctaveKeyboard {
            id: piano
            width: horizontalLayout ? parent.width * 0.34 : parent.width * 0.6
            height: horizontalLayout ? parent.height * 0.40 : parent.width * 0.26
            anchors.horizontalCenter: horizontalLayout ? undefined : parent.horizontalCenter
            anchors.left: horizontalLayout ? parent.left : undefined
            anchors.leftMargin: parent.width * 0.04
            anchors.top: horizontalLayout ? multipleStaff.top : multipleStaff.bottom
            anchors.topMargin: horizontalLayout ? parent.height * 0.08 : parent.height * 0.025
            blackLabelsVisible: [3, 4, 5, 6, 7, 8].indexOf(items.bar.level) == -1 ? false : true
            useSharpNotation: bar.level != 4
            blackKeysEnabled: bar.level > 2
            visible: !background.isLyricsMode
            currentOctaveNb: (background.clefType === "Bass") ? 0 : 1
            onNoteClicked: {
                parent.addMusicElementAndPushToStack(note, currentType)
            }
        }

        function addMusicElementAndPushToStack(noteName, noteType, elementType) {
            if(noteType === "Rest")
                elementType = "rest"
            else if(elementType == undefined)
                elementType = "note"

            var tempModel = multipleStaff.createNotesBackup()
            Activity.pushToStack(tempModel)
            multipleStaff.addMusicElement(elementType, noteName, noteType, false, true, background.clefType)
        }

        Image {
            id: shiftKeyboardLeft
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            sourceSize.width: piano.width / 7
            width: sourceSize.width
            height: width
            fillMode: Image.PreserveAspectFit
            visible: (piano.currentOctaveNb > 0) && piano.visible
            anchors {
                verticalCenter: piano.verticalCenter
                right: piano.left
            }
            MouseArea {
                anchors.fill: parent
                onClicked: piano.currentOctaveNb--
            }
        }

        Image {
            id: shiftKeyboardRight
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.width: piano.width / 7
            width: sourceSize.width
            height: width
            fillMode: Image.PreserveAspectFit
            visible: (piano.currentOctaveNb < piano.maxNbOctaves - 1) && piano.visible
            anchors {
                verticalCenter: piano.verticalCenter
                left: piano.right
            }
            MouseArea {
                anchors.fill: parent
                onClicked: piano.currentOctaveNb++
            }
        }

        LyricsArea {
            id: lyricsArea
            width: PianoOctaveKeyboard.width
        }

        GCCreationHandler {
            id: creationHandler
            onFileLoaded:  {
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
            columns: horizontalLayout ? 11 : 1
            anchors.top: horizontalLayout ? instructionBox.bottom : background.top
            anchors.margins: 10
            anchors.left: background.left
            iconsWidth: horizontalLayout ? background.width / 15 : (background.height - bar.height) / 12

            noteOptionsVisible: bar.level > 4
            playButtonVisible: true
            keyOption.clefButtonVisible: bar.level > 2
            clearButtonVisible: true
            undoButtonVisible: true
            openButtonVisible: bar.level > 6
            saveButtonVisible: bar.level > 6
            changeAccidentalStyleButtonVisible: bar.level >= 4
            lyricsOrPianoModeOptionVisible: bar.level > 6
            restOptionsVisible: bar.level > 5
            bpmVisible: true

            onUndoButtonClicked: {
                Activity.undoChange()
            }
            onClearButtonClicked: {
                if((multipleStaff.musicElementModel.count > 1) && multipleStaff.selectedIndex === -1) {
                    Core.showMessageDialog(main,
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
                print(notesToSave)
                creationHandler.saveWindow(notesToSave)
            }
            keyOption.onClefAdded: {
                var insertingIndex = multipleStaff.selectedIndex === -1 ? multipleStaff.musicElementModel.count : multipleStaff.selectedIndex
                var tempModel = multipleStaff.createNotesBackup()
                Activity.pushToStack(tempModel)
                multipleStaff.addMusicElement("clef", "", "", false, false, background.clefType)
                if(background.clefType === "Bass")
                    piano.currentOctaveNb = 0
                else
                    piano.currentOctaveNb = 1
            }
            onBpmDecreased: {
                if(multipleStaff.bpmValue - 1 >= 1)
                    multipleStaff.bpmValue--
            }
            onBpmIncreased: {
                multipleStaff.bpmValue++
            }
            onEmitOptionMessage: clickedOptionMessage.show(message)
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            content: Component {
                Column {
                    id: column
                    spacing: 10
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height

                    GCText {
                        text: qsTr("Select the type of melody to load.")
                        fontSizeMode: mediumSize
                    }

                    Button {
                        text: qsTr("Pre-defined melodies")
                        onClicked: {
                            melodyList.melodiesModel.clear()
                            var dataset = Dataset.get()
                            for(var i = 0; i < dataset.length; i++) {
                                melodyList.melodiesModel.append(dataset[i])
                            }
                            melodyList.visible = true
                            piano.enabled = false
                            melodyList.forceActiveFocus()
                            dialogActivityConfig.close()
                        }
                        width: 150 * ApplicationInfo.ratio
                        height: 60 * ApplicationInfo.ratio
                        style: GCButtonStyle {
                            theme: "dark"
                        }
                    }

                    Button {
                        text: qsTr("Your saved melodies")
                        onClicked: {
                            creationHandler.loadWindow()
                            dialogActivityConfig.close()
                        }
                        width: 150 * ApplicationInfo.ratio
                        height: 60 * ApplicationInfo.ratio
                        style: GCButtonStyle {
                            theme: "dark"
                        }
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
