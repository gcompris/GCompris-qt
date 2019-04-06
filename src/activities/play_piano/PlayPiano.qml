/* GCompris - PlayPiano.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0

import "../../core"
import "../piano_composition"
import "play_piano.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

    property bool horizontalLayout: width >= height * 1.2

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
            keyboardBindings[Qt.Key_8] = 7
            keyboardBindings[Qt.Key_F1] = 1
            keyboardBindings[Qt.Key_F2] = 2
            keyboardBindings[Qt.Key_F3] = 3
            keyboardBindings[Qt.Key_F4] = 4
            keyboardBindings[Qt.Key_F5] = 5

            if(piano.whiteKeysEnabled && !iAmReady.visible) {
                if(event.key >= Qt.Key_1 && event.key <= Qt.Key_8) {
                    piano.keyRepeater.itemAt(keyboardBindings[event.key]).whiteKey.keyPressed()
                }
                else if(event.key >= Qt.Key_F1 && event.key <= Qt.Key_F5) {
                    if(piano.blackKeysEnabled)
                        findBlackKey(keyboardBindings[event.key])
                }
                else if(event.key === Qt.Key_Space) {
                    multipleStaff.play()
                }
                else if(event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) {
                    Activity.undoPreviousAnswer()
                }
            }
        }

        function findBlackKey(keyNumber) {
            for(var i = 0; keyNumber; i++) {
                if(piano.keyRepeater.itemAt(i) === undefined)
                    break
                if(piano.keyRepeater.itemAt(i).blackKey.visible)
                    keyNumber--
                if(keyNumber === 0)
                    piano.keyRepeater.itemAt(i).blackKey.keyPressed()
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property alias multipleStaff: multipleStaff
            property alias piano: piano
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias iAmReady: iAmReady
            property alias introductoryAudioTimer: introductoryAudioTimer
            property alias parser: parser
            property string mode: "coloredNotes"
        }

        onStart: {
            dialogActivityConfig.getInitialConfiguration()
            Activity.start(items)
        }
        onStop: { Activity.stop() }

        property string clefType: (items.bar.level <= 5) ? "Treble" : "Bass"

        Timer {
            id: introductoryAudioTimer
            interval: 4000
            onRunningChanged: {
                if(running)
                    Activity.isIntroductoryAudioPlaying = true
                else {
                    Activity.isIntroductoryAudioPlaying = false
                    Activity.initSubLevel()
                }
            }
        }

        JsonParser {
            id: parser
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.3
            visible: iAmReady.visible
            z: 10
            MouseArea {
                anchors.fill: parent
            }
        }

        ReadyButton {
            id: iAmReady
            focus: true
            z: 10
            onClicked: {
                Activity.initLevel()
            }
        }

        Score {
            id: score
            anchors.top: background.top
            anchors.bottom: undefined
            numberOfSubLevels: 5
            width: horizontalLayout ? parent.width / 10 : (parent.width - instruction.x - instruction.width - 1.5 * anchors.rightMargin)
        }

        Rectangle {
            id: instruction
            radius: 10
            width: background.width * 0.6
            height: background.height / 9
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.8
            border.width: 6
            color: "white"
            border.color: "#87A6DD"

            GCText {
                color: "black"
                z: 3
                anchors.fill: parent
                anchors.rightMargin: parent.width * 0.02
                anchors.leftMargin: parent.width * 0.02
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                text: qsTr("Click on the piano keys that match the given notes.")
            }
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.5 : parent.width * 0.8
            height: horizontalLayout ? parent.height * 0.85 : parent.height * 0.58
            nbStaves: 1
            clef: clefType
            coloredNotes: (items.mode === "coloredNotes") ? ['C', 'D', 'E', 'F', 'G', 'A', 'B'] : []
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: instruction.bottom
            anchors.topMargin: horizontalLayout ? parent.height * 0.02 : parent.height * 0.15
            onNoteClicked: {
                playNoteAudio(musicElementModel.get(noteIndex).noteName_, musicElementModel.get(noteIndex).noteType_,  musicElementModel.get(noteIndex).soundPitch_)
            }
            centerNotesPosition: true
        }

        PianoOctaveKeyboard {
            id: piano
            width: horizontalLayout ? parent.width * 0.5 : parent.width * 0.7
            height: parent.height * 0.3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 20
            blackLabelsVisible: ([4, 5, 9, 10].indexOf(items.bar.level) != -1)
            blackKeysEnabled: blackLabelsVisible && !multipleStaff.isMusicPlaying && !introductoryAudioTimer.running
            whiteKeysEnabled: !multipleStaff.isMusicPlaying && !introductoryAudioTimer.running
            whiteKeyNoteLabelsTreble: [ whiteKeyNoteLabelsArray.slice(18, 26) ]
            whiteKeyNoteLabelsBass: [ whiteKeyNoteLabelsArray.slice(11, 19)]
            onNoteClicked: {
                multipleStaff.playNoteAudio(note, "Quarter", clefType, 500)
                Activity.checkAnswer(note)
            }
            useSharpNotation: true
        }

        Rectangle {
            id: optionDeck
            width: optionsRow.changeAccidentalStyleButtonVisible ? optionsRow.iconsWidth * 3.3 : optionsRow.iconsWidth * 2.2
            height: optionsRow.iconsWidth * 1.1
            color: "white"
            opacity: 0.5
            radius: 10
            y: horizontalLayout ? piano.y : multipleStaff.y / 2 + instruction.height - height / 2
            x: horizontalLayout ? multipleStaff.x + multipleStaff.width + 25 : background.width / 2 - width / 2
        }

        OptionsRow {
            id: optionsRow
            anchors.centerIn: optionDeck

            playButtonVisible: true
            undoButtonVisible: true

            onUndoButtonClicked: Activity.undoPreviousAnswer()
        }

        ExclusiveGroup {
            id: configOptions
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            content: Component {
                Column {
                    id: column
                    spacing: 5
                    width: dialogActivityConfig.width
                    height: dialogActivityConfig.height

                    property alias coloredNotesModeBox: coloredNotesModeBox
                    property alias colorlessNotesModeBox: colorlessNotesModeBox

                    GCDialogCheckBox {
                        id: coloredNotesModeBox
                        width: column.width - 50
                        text: qsTr("Display colored notes.")
                        checked: items.mode === "coloredNotes"
                        exclusiveGroup: configOptions
                        onCheckedChanged: {
                            if(coloredNotesModeBox.checked) {
                                items.mode = "coloredNotes"
                            }
                        }
                    }

                    GCDialogCheckBox {
                        id: colorlessNotesModeBox
                        width: coloredNotesModeBox.width
                        text: qsTr("Display colorless notes.")
                        checked: items.mode === "colorlessNotes"
                        exclusiveGroup: configOptions
                        onCheckedChanged: {
                            if(colorlessNotesModeBox.checked) {
                                items.mode = "colorlessNotes"
                            }
                        }
                    }
                }
            }
            onLoadData: {
                if(dataToSave && dataToSave["mode"])
                    items.mode = dataToSave["mode"]
            }
            onSaveData: dataToSave["mode"] = items.mode
            onClose: {
                home()
            }
            onVisibleChanged: {
                multipleStaff.eraseAllNotes()
                iAmReady.visible = true
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | config | reload }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                displayDialog(dialogActivityConfig)
            }
            onReloadClicked: {
                multipleStaff.eraseAllNotes()
                iAmReady.visible = true
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
