/* GCompris - Piano_composition.qml
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
import QtQuick.Controls 1.0
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "piano_composition.js" as Activity
import "melodies.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

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
            if(event.key === Qt.Key_Delete) {
                multipleStaff.eraseAllNotes()
            }
            if(event.key === Qt.Key_Space) {
                multipleStaff.play()
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

        property string currentType: "Whole"
        property string restType: "Whole"
        property string clefType: bar.level == 2 ? "bass" : "treble"
        property string staffMode: "add"
        property bool undidChange: false
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
                bar.visible = true
                focus = false
                activity.focus = true
            }
        }

        Rectangle {
            id: instructionBox
            radius: 10
            width: background.width * 0.98
            height: background.height / 9
            anchors.horizontalCenter: parent.horizontalCenter
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
            width: horizontalLayout ? parent.width * 0.50 : parent.width * 0.8
            height: horizontalLayout ? parent.height * 0.58 : parent.height * 0.3
            nbStaves: 2
            clef: clefType
            nbMaxNotesPerStaff: 10
            noteIsColored: true
            isMetronomeDisplayed: true
            anchors.right: horizontalLayout ? parent.right: undefined
            anchors.horizontalCenter: horizontalLayout ? undefined : parent.horizontalCenter
            anchors.top: instructionBox.bottom
            anchors.topMargin: parent.height * 0.1
            anchors.rightMargin: parent.width * 0.043
            onNoteClicked: {
                if(background.staffMode === "add")
                    playNoteAudio(noteName, noteType)
                else if(background.staffMode === "replace")
                    noteToReplace = noteIndex
                else
                    multipleStaff.eraseNote(noteIndex)
            }
            onPushToUndoStack: {
                // If we have undid the change, we won't push the undid change in the stack as the undoStack will enter in a loop.
                if(!background.undidChange)
                    Activity.pushToStack(noteIndex, oldNoteName, oldNoteType)
            }
            onNotePlayed: piano.indicateKey(noteName)
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

        Piano {
            id: piano
            width: horizontalLayout ? parent.width * 0.34 : parent.width * 0.7
            height: horizontalLayout ? parent.height * 0.40 : parent.width * 0.26
            anchors.horizontalCenter: horizontalLayout ? undefined : parent.horizontalCenter
            anchors.left: horizontalLayout ? parent.left : undefined
            anchors.leftMargin: parent.width * 0.04
            anchors.top: horizontalLayout ? multipleStaff.top : multipleStaff.bottom
            anchors.topMargin: horizontalLayout ? parent.height * 0.08 : parent.height * 0.025
            blackLabelsVisible: [3, 4, 5, 6, 7, 8].indexOf(items.bar.level) == -1 ? false : true
            useSharpNotation: bar.level != 4
            blackKeysEnabled: bar.level > 2
            onNoteClicked: {
                if(background.staffMode === "add")
                    multipleStaff.addNote(note, currentType, false, true)
                else if(background.staffMode === "replace")
                    multipleStaff.replaceNote(note, currentType)
            }
            visible: !background.isLyricsMode
        }

        Image {
            id: shiftKeyboardLeft
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.width: piano.width / 7
            width: sourceSize.width
            height: width
            fillMode: Image.PreserveAspectFit
            rotation: 180
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
        }

        OptionsRow {
            id: optionsRow
            anchors.top: instructionBox.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            noteOptionsVisible: bar.level > 4
            playButtonVisible: true
            clefButtonVisible: bar.level > 2
            staffModesOptionsVisible: true
            clearButtonVisible: true
            undoButtonVisible: true
            openButtonVisible: bar.level > 6
            saveButtonVisible: bar.level > 6
            changeAccidentalStyleButtonVisible: bar.level >= 4
            lyricsOrPianoModeOptionVisible: bar.level > 6
            restOptionsVisible: bar.level > 5

            onUndoButtonClicked: {
                background.undidChange = true
                Activity.undoChange()
                background.undidChange = false
            }
            onClearButtonClicked: {
                Core.showMessageDialog(main,
                    qsTr("Do you want to erase all the notes?"),
                    qsTr("Yes"), function() {
                        Activity.undoStack = []
                        lyricsArea.resetLyricsArea()
                       multipleStaff.eraseAllNotes()
                    },
                    qsTr("No"), null,
                    null
                )
            }
            onOpenButtonClicked: {
                melodyList.melodiesModel.clear()
                var dataset = Dataset.get()
                for(var i = 0; i < dataset.length; i++) {
                    melodyList.melodiesModel.append(dataset[i])
                }
                piano.enabled = false
                bar.visible = false
                melodyList.visible = true
                melodyList.forceActiveFocus()
            }
            onSaveButtonClicked: Activity.saveMelody()
            onEmitOptionMessage: clickedOptionMessage.show(message)
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
