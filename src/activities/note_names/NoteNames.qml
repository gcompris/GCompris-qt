/* GCompris - NoteNames.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"
import "../piano_composition"
import "note_names.js" as Activity

ActivityBase {
    id: activity
    property int speedSetting: 5
    property int timerNormalInterval: (13500 / speedSetting)
    isMusicalActivity: true

    onStart: focus = true
    onStop: {}

    property bool horizontalLayout: width >= height

    pageComponent: Rectangle {
        id: activityBackground
        anchors.fill: parent
        color: GCStyle.lightBlueBg
        signal start
        signal stop

        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false

        property bool activityStopped: false

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: [introMessage]

        Keys.onPressed: (event) => {
            var keyNoteBindings = {}
            keyNoteBindings[Qt.Key_1] = 'C'
            keyNoteBindings[Qt.Key_2] = 'D'
            keyNoteBindings[Qt.Key_3] = 'E'
            keyNoteBindings[Qt.Key_4] = 'F'
            keyNoteBindings[Qt.Key_5] = 'G'
            keyNoteBindings[Qt.Key_6] = 'A'
            keyNoteBindings[Qt.Key_7] = 'B'

            if(!introMessage.visible && !iAmReady.visible && !messageBox.visible && multipleStaff.musicElementModel.count - 1) {
                if(keyNoteBindings[event.key]) {
                    // If the key pressed matches the note, pass the correct answer as parameter.	
                    isCorrectKey(keyNoteBindings[event.key])
                }
                else if(event.key === Qt.Key_Left && shiftKeyboardLeft.visible) {
                    doubleOctave.currentOctaveNb--
                }
                else if(event.key === Qt.Key_Right && shiftKeyboardRight.visible) {
                    doubleOctave.currentOctaveNb++
                }
            }
        }

        function isCorrectKey(key) {
            if(Activity.newNotesSequence[Activity.currentNoteIndex][0] === key)
                Activity.correctAnswer()
            else
                items.displayNoteNameTimer.start()
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias multipleStaff: multipleStaff
            property alias doubleOctave: doubleOctave
            property alias bonus: bonus
            property alias iAmReady: iAmReady
            property alias messageBox: messageBox
            property alias addNoteTimer: addNoteTimer
            property alias dataset: dataset
            property alias progressBar: progressBar
            property alias introMessage: introMessage
            property bool isTutorialMode: true
            property alias displayNoteNameTimer: displayNoteNameTimer
        }

        Loader {
            id: dataset
            asynchronous: false
            source: "qrc:/gcompris/src/activities/note_names/resource/dataset_01.qml"
        }

        onStart: {
            if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled) {
                    introMessage.index = -1;
                    activityBackground.audioDisabled = true;
            }
            Activity.start(items, activity.timerNormalInterval);
        }
        onStop: {
            activityStopped = true;
            Activity.stop();
        }

        onWidthChanged: {
            if(!items.isTutorialMode && !activityStopped) {
                multipleStaff.initClefs(activityBackground.clefType)
            }
        }
        onHeightChanged: {
            if(!items.isTutorialMode && !activityStopped) {
                multipleStaff.initClefs(activityBackground.clefType)
            }
        }

        property string clefType: "Treble"

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onStartActivity: {
                introMessage.visible = false;
                iAmReady.visible = true;
            }
            onClose: {
                home();
                introMessage.visible = false;
                iAmReady.visible = true;
            }
            onLoadData: {
                if(activityData && activityData["speedSetting"]) {
                    activity.speedSetting = activityData["speedSetting"];
                }
            }
        }

        Timer {
            id: displayNoteNameTimer
            interval: 2000
            onRunningChanged: {
                if(running) {
                    multipleStaff.pauseNoteAnimation()
                    addNoteTimer.pause()
                    messageBox.visible = true
                }
                else {
                    messageBox.visible = false
                    if(progressBar.percentage != 100 && Activity.newNotesSequence.length) {
                        Activity.wrongAnswer()
                        addNoteTimer.resume()
                    }
                }
            }
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.3
        }

        GCTextPanel {
            id: messageBox
            panelWidth: layoutArea.width - (shiftKeyboardLeft.width + GCStyle.baseMargins) * 2
            panelHeight: shiftKeyboardLeft.height
            color: GCStyle.lightBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinBorder
            textItem.color: GCStyle.darkText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: shiftKeyboardLeft.verticalCenter
            z: 11
            visible: false

            function getTranslatedNoteName(noteName) {
                for(var i = 0; i < doubleOctave.keyNames.length; i++) {
                    if(doubleOctave.keyNames[i][0] === noteName)
                        return doubleOctave.keyNames[i][1]
                }
                return ""
            }

            onVisibleChanged: {
                if(Activity.targetNotes[0] === undefined)
                    textItem.text = ""
                else if(items.isTutorialMode)
                    textItem.text = qsTr("New note: %1").arg(getTranslatedNoteName(Activity.targetNotes[0]))
                else
                    textItem.text = getTranslatedNoteName(Activity.newNotesSequence[Activity.currentNoteIndex])
            }

            MouseArea {
                anchors.fill: parent
                enabled: items.isTutorialMode
                onClicked: {
                    items.multipleStaff.pauseNoteAnimation()
                    items.multipleStaff.musicElementModel.remove(1)
                    Activity.showTutorial()
                }
            }
        }

        Rectangle {
            id: colorLayer
            anchors.fill: parent
            color: GCStyle.grayedBg
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
            visible: !introMessage.visible
            onVisibleChanged: {
                messageBox.visible = false
            }
            onClicked: {
                Activity.initLevel()
            }
        }

        IntroMessage {
            id: introMessage
            z: 12
            intro: ListModel {}
        }

        AdvancedTimer {
            id: addNoteTimer
            interval: activity.timerNormalInterval
            onTriggered: {
                Activity.noteIndexToDisplay = (Activity.noteIndexToDisplay + 1) % Activity.newNotesSequence.length
                Activity.displayNote(Activity.newNotesSequence[Activity.noteIndexToDisplay])
            }
        }

        GCProgressBar {
            id: progressBar
            height: 20 * ApplicationInfo.ratio
            width: layoutArea.width * 0.25

            property int percentage: 0

            value: percentage
            to: 100
            visible: !items.isTutorialMode
            anchors {
                top: layoutArea.top
                right: layoutArea.right
            }
            //: The following translation represents percentage.
            message: qsTr("%1%").arg(value)
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? layoutArea.width * 0.5 : layoutArea.width
            height: horizontalLayout ? layoutArea.height * 0.9 : layoutArea.height * 0.7
            nbStaves: 1
            clef: clefType
            notesColor: "red"
            softColorOpacity: 0
            isFlickable: false
            anchors.top: progressBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: shiftKeyboardLeft.top
            anchors.margins: GCStyle.baseMargins
            noteAnimationEnabled: true
            noteAnimationDuration: items.isTutorialMode ? 9000 : 45000 / activity.speedSetting
            onNoteAnimationFinished: {
                if(!items.isTutorialMode)
                    displayNoteNameTimer.start()
            }
        }

        // We present a pair of two joint piano keyboard octaves.
        Item {
            id: doubleOctave
            height: horizontalLayout ? layoutArea.height * 0.3 : layoutArea.height * 0.4
            anchors.left: layoutArea.left
            anchors.right: layoutArea.right
            anchors.bottom: layoutArea.bottom

            readonly property int nbJointKeyboards: 2
            readonly property int maxNbOctaves: 3
            property int currentOctaveNb: 0
            property var coloredKeyLabels: []
            property var keyNames: []

            Repeater {
                id: octaveRepeater
                anchors.fill: parent
                model: doubleOctave.nbJointKeyboards
                PianoOctaveKeyboard {
                    id: pianoKeyboard
                    width: horizontalLayout ? octaveRepeater.width * 0.5 : octaveRepeater.width
                    height: horizontalLayout ? octaveRepeater.height :
                        octaveRepeater.height * 0.5 - GCStyle.halfMargins
                    blackLabelsVisible: false
                    blackKeysEnabled: blackLabelsVisible
                    whiteKeysEnabled: !messageBox.visible && multipleStaff.musicElementModel.count > 1
                    onNoteClicked: (note) => Activity.checkAnswer(note)
                    currentOctaveNb: doubleOctave.currentOctaveNb
                    anchors.top: (index === 1) ? octaveRepeater.top : undefined
                    anchors.topMargin: horizontalLayout ? 0 : GCStyle.halfMargins
                    anchors.bottom: (index === 0) ? octaveRepeater.bottom : undefined
                    anchors.right: (index === 1) ? octaveRepeater.right : undefined
                    coloredKeyLabels: doubleOctave.coloredKeyLabels
                    labelsColor: "#ff6666"
                    // The octaves sets corresponding to respective clef types are in pairs for the joint piano keyboards at a time when displaying.
                    whiteKeyNoteLabelsBass: {
                        if(index === 0) {
                            return [
                                whiteKeyNoteLabelsArray.slice(0, 4),    // F1 to B1
                                whiteKeyNoteLabelsArray.slice(4, 11),   // C2 to B2
                                whiteKeyNoteLabelsArray.slice(11, 18)   // C3 to B3
                            ]
                        }
                        else {
                            return [
                                whiteKeyNoteLabelsArray.slice(4, 11),   // C2 to B2
                                whiteKeyNoteLabelsArray.slice(11, 18),  // C3 to B3
                                whiteKeyNoteLabelsArray.slice(18, 25)   // C4 to B4
                            ]
                        }
                    }
                    whiteKeyNoteLabelsTreble: {
                        if(index === 0) {
                            return [
                                whiteKeyNoteLabelsArray.slice(11, 18),  // C3 to B3
                                whiteKeyNoteLabelsArray.slice(18, 25),  // C4 to B4
                                whiteKeyNoteLabelsArray.slice(25, 32)   // C5 to B5
                            ]
                        }
                        else {
                            return [
                                whiteKeyNoteLabelsArray.slice(18, 25),  // C4 to B4
                                whiteKeyNoteLabelsArray.slice(25, 32),  // C5 to B5
                                whiteKeyNoteLabelsArray.slice(32, 34)   // C6 to D6
                            ]
                        }
                    }

                    Component.onCompleted: doubleOctave.keyNames = whiteKeyNoteLabelsArray
                }
            }
        }

        Image {
            id: shiftKeyboardLeft
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            width: Math.min(layoutArea.height * 0.2, GCStyle.bigButtonHeight)
            height: width
            sourceSize.height : height
            fillMode: Image.PreserveAspectFit
            visible: (doubleOctave.currentOctaveNb > 0) && doubleOctave.visible
            z: 11
            anchors {
                bottom: doubleOctave.top
                left: layoutArea.left
            }
            MouseArea {
                enabled: !messageBox.visible
                anchors.fill: parent
                onClicked: {
                    doubleOctave.currentOctaveNb--
                }
            }
        }

        Image {
            id: shiftKeyboardRight
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            width: shiftKeyboardLeft.width
            height: width
            sourceSize.height : height
            fillMode: Image.PreserveAspectFit
            visible: (doubleOctave.currentOctaveNb < doubleOctave.maxNbOctaves - 1) && doubleOctave.visible
            z: 11
            anchors {
                bottom: doubleOctave.top
                right: layoutArea.right
            }
            MouseArea {
                enabled: !messageBox.visible
                anchors.fill: parent
                onClicked: {
                    doubleOctave.currentOctaveNb++
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: (help | home | level | reload | activityConfig) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onActivityConfigClicked: {
                multipleStaff.pauseNoteAnimation()
                addNoteTimer.pause()
                displayDialog(dialogActivityConfig)
            }
            onReloadClicked: {
                iAmReady.visible = true
                Activity.initLevel()
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
                    introMessage.index = 0;
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
