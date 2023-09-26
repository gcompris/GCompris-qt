/* GCompris - PlayPiano.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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

        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false

        Component.onCompleted: {
            dialogActivityConfig.initialize()
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
            keyboardBindings[Qt.Key_F2] = 1
            keyboardBindings[Qt.Key_F3] = 2
            keyboardBindings[Qt.Key_F5] = 4
            keyboardBindings[Qt.Key_F6] = 5
            keyboardBindings[Qt.Key_F7] = 6

            if(piano.whiteKeysEnabled && !iAmReady.visible) {
                if(event.key >= Qt.Key_1 && event.key <= Qt.Key_8) {
                    piano.keyRepeater.playKey(keyboardBindings[event.key], "white");
                }
                else if(event.key >= Qt.Key_F2 && event.key <= Qt.Key_F7) {
                    if(piano.blackKeysEnabled)
                        piano.keyRepeater.playKey(keyboardBindings[event.key], "black");
                }
                else if(event.key === Qt.Key_Space) {
                    multipleStaff.play()
                }
                else if(event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) {
                    Activity.undoPreviousAnswer()
                }
            } else if(iAmReady.visible) {
                iAmReady.visible = false;
                iAmReady.clicked();
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
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias iAmReady: iAmReady
            property alias introductoryAudioTimer: introductoryAudioTimer
            property alias parser: parser
            property string mode: "coloredNotes"
        }

        onStart: {
            if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled) {
                    background.audioDisabled = true;
            }
            Activity.start(items);
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
            blackLabelsVisible: ([4, 5, 9, 10].indexOf(bar.level) != -1)
            blackKeysEnabled: blackLabelsVisible && !multipleStaff.isMusicPlaying && !introductoryAudioTimer.running
            whiteKeysEnabled: !multipleStaff.isMusicPlaying && !introductoryAudioTimer.running
            whiteKeyNoteLabelsTreble: [ whiteKeyNoteLabelsArray.slice(18, 26) ]
            whiteKeyNoteLabelsBass: [ whiteKeyNoteLabelsArray.slice(11, 19)]
            onNoteClicked: {
                multipleStaff.playNoteAudio(note, "Quarter", clefType, 500)
                Activity.checkAnswer(note)
            }
            useSharpNotation: true
            playPianoActivity: true
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

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: {
                home()
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
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
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

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
                    background.audioDisabled = false;
                }
            }
            anchors.fill: parent
            focus: true
            active: background.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
