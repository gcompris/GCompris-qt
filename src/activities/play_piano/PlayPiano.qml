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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0
import QtMultimedia 5.0

import "../../core"
import "../piano_composition"
import "play_piano.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool horizontalLayout: width > height

    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        property string backgroundImagesUrl: ":/gcompris/src/activities/piano_composition/resource/background/"
        property var backgroundImages: directory.getFiles(backgroundImagesUrl)

        Directory {
            id: directory
        }

        source:{
            if(items.bar.level === 0)
                return "qrc" + backgroundImagesUrl + backgroundImages[0]
            else
                return "qrc" + backgroundImagesUrl + backgroundImages[(items.bar.level - 1) % backgroundImages.length]
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Keys.onPressed: {
            if(event.key === Qt.Key_1) {
                piano.keyRepeater.itemAt(0).whiteKey.keyPressed()
            }
            if(event.key === Qt.Key_2) {
                piano.keyRepeater.itemAt(1).whiteKey.keyPressed()
            }
            if(event.key === Qt.Key_3) {
                piano.keyRepeater.itemAt(2).whiteKey.keyPressed()
            }
            if(event.key === Qt.Key_4) {
                piano.keyRepeater.itemAt(3).whiteKey.keyPressed()
            }
            if(event.key === Qt.Key_5) {
                piano.keyRepeater.itemAt(4).whiteKey.keyPressed()
            }
            if(event.key === Qt.Key_6) {
                piano.keyRepeater.itemAt(5).whiteKey.keyPressed()
            }
            if(event.key === Qt.Key_7) {
                piano.keyRepeater.itemAt(6).whiteKey.keyPressed()
            }
            if(event.key === Qt.Key_8) {
                piano.keyRepeater.itemAt(7).whiteKey.keyPressed()
            }
            if(event.key === Qt.Key_F1 && piano.blackKeysEnabled) {
                findBlackKey(1)
            }
            if(event.key === Qt.Key_F2 && piano.blackKeysEnabled) {
                findBlackKey(2)
            }
            if(event.key === Qt.Key_F3 && piano.blackKeysEnabled) {
                findBlackKey(3)
            }
            if(event.key === Qt.Key_F4 && piano.blackKeysEnabled) {
                findBlackKey(4)
            }
            if(event.key === Qt.Key_F5 && piano.blackKeysEnabled) {
                findBlackKey(5)
            }
            if(event.key === Qt.Key_Space) {
                multipleStaff.play()
            }
            if(event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) {
                Activity.undoPreviousAnswer()
            }
            if(event.key === Qt.Key_Left && shiftKeyboardLeft.visible) {
                piano.currentOctaveNb--
            }
            if(event.key === Qt.Key_Right && shiftKeyboardRight.visible) {
                piano.currentOctaveNb++
            }
        }

        function findBlackKey(keyNumber) {
            for(var i = 0; keyNumber; i++) {
                if(piano.keyRepeater.itemAt(i) == undefined)
                    break
                if(piano.keyRepeater.itemAt(i).blackKey.visible)
                    keyNumber--
                if(!keyNumber)
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
            isPulseMarkerDisplayed: false
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: instruction.bottom
            anchors.topMargin: horizontalLayout ? parent.height * 0.02 : parent.height * 0.15
            onNoteClicked: {
                playNoteAudio(musicElementModel.get(noteIndex).noteName_, musicElementModel.get(noteIndex).noteType_,  musicElementModel.get(noteIndex).soundPitch_)
            }
            noteHoverEnabled: false
            centerNotesPosition: true
        }

        Piano {
            id: piano
            width: horizontalLayout ? parent.width * 0.3 : parent.width * 0.7
            height: horizontalLayout ? parent.height * 0.3 : parent.width * 0.26
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 20
            blackLabelsVisible: ([4, 5, 9, 10].indexOf(items.bar.level) != -1)
            blackKeysEnabled: blackLabelsVisible && !multipleStaff.isMusicPlaying && !introductoryAudioTimer.running
            whiteKeysEnabled: !multipleStaff.isMusicPlaying && !introductoryAudioTimer.running
            onNoteClicked: {
                multipleStaff.playNoteAudio(note, "Quarter", clefType, 1000)
                Activity.checkAnswer(note)
            }
            currentOctaveNb: 0
            useSharpNotation: true
        }

        Rectangle {
            id: optionDeck
            width: optionsRow.changeAccidentalStyleButtonVisible ? optionsRow.iconsWidth * 5 : optionsRow.iconsWidth * 4
            height: optionsRow.iconsWidth * 1.7
            border.width: 2
            border.color: "black"
            color: "black"
            opacity: 0.5
            radius: 10
            y: horizontalLayout ? background.height / 2 - height : instruction.height + 10
            x: horizontalLayout ? background.width - width - 25 : background.width / 2 - width / 2
        }

        OptionsRow {
            id: optionsRow
            anchors.top: optionDeck.top
            anchors.topMargin: 15
            anchors.horizontalCenter: optionDeck.horizontalCenter
            iconsWidth: horizontalLayout ? Math.min(50, (background.width - piano.x - piano.width) / 5) : 45

            playButtonVisible: true
            undoButtonVisible: true
            changeAccidentalStyleButtonVisible: [7, 12].indexOf(items.bar.level) != -1

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
