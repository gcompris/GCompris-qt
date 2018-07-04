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
                piano.whiteKeyRepeater.itemAt(0).keyPressed()
            }
            if(event.key === Qt.Key_2) {
                piano.whiteKeyRepeater.itemAt(1).keyPressed()
            }
            if(event.key === Qt.Key_3) {
                piano.whiteKeyRepeater.itemAt(2).keyPressed()
            }
            if(event.key === Qt.Key_4) {
                piano.whiteKeyRepeater.itemAt(3).keyPressed()
            }
            if(event.key === Qt.Key_5) {
                piano.whiteKeyRepeater.itemAt(4).keyPressed()
            }
            if(event.key === Qt.Key_6) {
                piano.whiteKeyRepeater.itemAt(5).keyPressed()
            }
            if(event.key === Qt.Key_7) {
                piano.whiteKeyRepeater.itemAt(6).keyPressed()
            }
            if(event.key === Qt.Key_8) {
                piano.whiteKeyRepeater.itemAt(7).keyPressed()
            }
            if(event.key === Qt.Key_F1 && piano.blackKeysEnabled) {
                piano.blackKeyRepeater.itemAt(0).keyPressed()
            }
            if(event.key === Qt.Key_F2 && piano.blackKeysEnabled) {
                piano.blackKeyRepeater.itemAt(1).keyPressed()
            }
            if(event.key === Qt.Key_F3 && piano.blackKeysEnabled) {
                piano.blackKeyRepeater.itemAt(2).keyPressed()
            }
            if(event.key === Qt.Key_F4 && piano.blackKeysEnabled) {
                piano.blackKeyRepeater.itemAt(3).keyPressed()
            }
            if(event.key === Qt.Key_F5 && piano.blackKeysEnabled) {
                piano.blackKeyRepeater.itemAt(4).keyPressed()
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

        property string clefType: (items.bar.level <= 7) ? "Treble" : "Bass"
        readonly property bool shiftButtonsVisible: [5, 6, 7, 10, 11, 12].indexOf(items.bar.level) != -1

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
            width: horizontalLayout ? parent.width * 0.4 : parent.width * 0.8
            height: horizontalLayout ? parent.height * 0.7 : parent.height * 0.58
            nbStaves: 1
            clef: clefType
            noteIsColored: items.mode === "coloredNotes"
            isMetronomeDisplayed: false
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: instruction.bottom
            anchors.topMargin: horizontalLayout ? parent.height * 0.02 : parent.height * 0.09
            onNoteClicked: {
                playNoteAudio(musicElementModel.get(noteIndex).noteName_, musicElementModel.get(noteIndex).noteType_,  musicElementModel.get(noteIndex).soundPitch_)
            }
            noteHoverEnabled: false
            centerNotesPosition: true
        }

        Piano {
            id: piano
            width: horizontalLayout ? parent.width * 0.4 : parent.width * 0.7
            height: horizontalLayout ? parent.height * 0.3 : parent.width * 0.26
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 20
            blackLabelsVisible: ([5, 6, 7, 10, 11, 12].indexOf(items.bar.level) != -1)
            useSharpNotation: (bar.level != 6) && (bar.level != 11)
            blackKeysEnabled: blackLabelsVisible && !multipleStaff.isMusicPlaying
            whiteKeysEnabled: !multipleStaff.isMusicPlaying
            onNoteClicked: Activity.checkAnswer(note)
            currentOctaveNb: 0
        }

        Image {
            id: shiftKeyboardLeft
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.width: piano.width / 7
            width: sourceSize.width
            height: width
            fillMode: Image.PreserveAspectFit
            rotation: 180
            visible: (piano.currentOctaveNb > 0) && shiftButtonsVisible
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
            visible: (piano.currentOctaveNb < piano.maxNbOctaves - 1) && shiftButtonsVisible
            anchors {
                verticalCenter: piano.verticalCenter
                left: piano.right
            }
            MouseArea {
                anchors.fill: parent
                onClicked: piano.currentOctaveNb++
            }
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
                multipleStaff.eraseAllNotes()
                iAmReady.visible = true
                Activity.currentLevel = 0
                home()
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
