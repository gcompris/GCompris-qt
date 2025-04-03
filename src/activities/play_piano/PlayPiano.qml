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
import core 1.0

import "../../core"
import "../piano_composition"
import "play_piano.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    isMusicalActivity: true

    pageComponent: Rectangle {
        id: activityBackground
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false
        readonly property bool horizontalLayout: width >= height * 1.2

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Keys.onPressed: (event) => {
            if(items.buttonsBlocked)
                return;

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
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias multipleStaff: multipleStaff
            property alias piano: piano
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias iAmReady: iAmReady
            property alias introductoryAudioTimer: introductoryAudioTimer
            property alias parser: parser
            property alias answerFeedbackTimer: answerFeedbackTimer
            property string mode: "coloredNotes"
            property bool buttonsBlocked: false
            property bool readyPressed: false
        }

        onStart: {
            if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled) {
                    activityBackground.audioDisabled = true;
            }
            Activity.start(items);
        }
        onStop: { Activity.stop() }

        property string clefType: (bar.level <= 5) ? "Treble" : "Bass"

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

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

        Timer {
            id: answerFeedbackTimer
            interval: 1000
            onRunningChanged: {
                if(!running)
                    Activity.answerFeedback()
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
                items.readyPressed = true;
                Activity.initLevel();
            }
        }

        Score {
            id: score
            anchors.top: activityBackground.top
            anchors.bottom: undefined
            numberOfSubLevels: 5
            width: activityBackground.horizontalLayout ? parent.width / 10 : (parent.width - instruction.x - instruction.width - 1.5 * anchors.rightMargin)
            onStop: Activity.nextSubLevel()
        }

        Rectangle {
            id: instruction
            radius: 10
            width: activityBackground.width * 0.6
            height: activityBackground.height / 9
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

        Item {
            id: staffLayoutArea
            anchors.bottom: piano.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
            height: activityBackground.horizontalLayout ?
                piano.y - instruction.height - 2 * GCStyle.baseMargins :
                piano.y - optionDeck.y - optionDeck.height - 2 * GCStyle.baseMargins
        }

        MultipleStaff {
            id: multipleStaff
            anchors.centerIn: staffLayoutArea

            // we count maximum 4 notes + the clef, but in case there is more someday, add a Math.max check...
            property int maxItemsOnTheStaff: Math.max(5, multipleStaff.musicElementModel.count)
            // To make sure all the notes fit on one line.
            property int relativeSizeUnit: Math.min(staffLayoutArea.height / 14, staffLayoutArea.width / (5 * maxItemsOnTheStaff))

            height: relativeSizeUnit * 14
            width: relativeSizeUnit * (5 * maxItemsOnTheStaff)
            nbStaves: 1
            clef: clefType
            coloredNotes: (items.mode === "coloredNotes") ? ['C', 'D', 'E', 'F', 'G', 'A', 'B'] : []
            isFlickable: false
            onNoteClicked: {
                playNoteAudio(musicElementModel.get(noteIndex).noteName_, musicElementModel.get(noteIndex).noteType_,  musicElementModel.get(noteIndex).soundPitch_)
            }
        }

        PianoOctaveKeyboard {
            id: piano
            width: activityBackground.horizontalLayout ? parent.width * 0.5 : parent.width * 0.7
            height: parent.height * 0.3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 2 * GCStyle.baseMargins
            blackLabelsVisible: ([4, 5, 9, 10].indexOf(bar.level) != -1)
            blackKeysEnabled: blackLabelsVisible && !multipleStaff.isMusicPlaying && !introductoryAudioTimer.running && !items.buttonsBlocked
            whiteKeysEnabled: !multipleStaff.isMusicPlaying && !introductoryAudioTimer.running && !items.buttonsBlocked
            whiteKeyNoteLabelsTreble: [ whiteKeyNoteLabelsArray.slice(18, 26) ]
            whiteKeyNoteLabelsBass: [ whiteKeyNoteLabelsArray.slice(11, 19)]
            onNoteClicked: (note) => {
                multipleStaff.playNoteAudio(note, "Quarter", clefType, 500)
                Activity.checkAnswer(note)
            }
            useSharpNotation: true
            playPianoActivity: true
        }

        Rectangle {
            id: optionDeck
            width: activityBackground.horizontalLayout ?
                Math.min(GCStyle.bigButtonHeight * 2 + GCStyle.halfMargins * 3, activityBackground.width * 0.25 - GCStyle.baseMargins * 2) :
                GCStyle.bigButtonHeight * 2 + GCStyle.halfMargins * 3
            height: width * 0.5
            color: "white"
            opacity: 0.5
            radius: 10
            y: activityBackground.horizontalLayout ? piano.y : instruction.height + GCStyle.baseMargins
            x: activityBackground.horizontalLayout ? piano.x + piano.width + GCStyle.baseMargins : activityBackground.width / 2 - width / 2
        }

        OptionsRow {
            id: optionsRow
            anchors.centerIn: optionDeck
            iconsWidth: optionDeck.height - GCStyle.halfMargins

            playButtonVisible: true
            undoButtonVisible: true

            onUndoButtonClicked: Activity.undoPreviousAnswer()
        }
        MouseArea {
            id: optionsRowLock
            anchors.fill: optionsRow
            enabled: items.buttonsBlocked
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
            Component.onCompleted: win.connect(Activity.nextLevel)
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
