/* GCompris - NoteNames.qml
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
import QtQuick 2.1
import QtQuick.Controls 1.0
import GCompris 1.0

import "../../core"
import "../piano_composition"
import "note_names.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool horizontalLayout: width > height

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
                if(Activity.sequence[0][0] === 'C')
                    Activity.checkAnswer(Activity.sequence[currentNoteIndex])
                else
                   Activity.checkAnswer("Z")
            }
            else if(event.key === Qt.Key_2) {
                if(Activity.sequence[0][0] === 'D')
                    Activity.checkAnswer(Activity.sequence[currentNoteIndex])
                else
                   Activity.checkAnswer("Z")
            }
            else if(event.key === Qt.Key_3) {
                if(Activity.sequence[0][0] === 'E')
                    Activity.checkAnswer(Activity.sequence[currentNoteIndex])
                else
                   Activity.checkAnswer("Z")
            }
            else if(event.key === Qt.Key_4) {
                if(Activity.sequence[0][0] === 'F')
                    Activity.checkAnswer(Activity.sequence[currentNoteIndex])
                else
                   Activity.checkAnswer("Z")
            }
            else if(event.key === Qt.Key_5) {
                if(Activity.sequence[0][0] === 'G')
                    Activity.checkAnswer(Activity.sequence[currentNoteIndex])
                else
                   Activity.checkAnswer("Z")
            }
            else if(event.key === Qt.Key_6) {
                if(Activity.sequence[0][0] === 'A')
                    Activity.checkAnswer(Activity.sequence[currentNoteIndex])
                else
                   Activity.checkAnswer("Z")
            }
            else if(event.key === Qt.Key_7) {
                if(Activity.sequence[0][0] === 'B')
                    Activity.checkAnswer(Activity.sequence[currentNoteIndex])
                else
                   Activity.checkAnswer("Z")
            }
            else if(event.key === Qt.Key_Left && shiftKeyboardLeft.visible) {
                piano.currentOctaveNb--
            }
            else if(event.key === Qt.Key_Right && shiftKeyboardRight.visible) {
                piano.currentOctaveNb++
            }
            else
                Activity.checkAnswer("Z")
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property alias bar: bar
            property alias multipleStaff: multipleStaff
            property alias piano: piano
            property alias piano2: piano2
            property alias bonus: bonus
            property alias iAmReady: iAmReady
            property alias wrongAnswerAnimation: wrongAnswerAnimation
            property alias messageBox: messageBox
            property alias addNoteTimer: addNoteTimer
            property alias parser: parser
            property alias progressBar: progressBar
            property bool isTutorialMode: true
        }

        JsonParser {
            id: parser
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property string clefType: "Treble"

        NumberAnimation {
            id: wrongAnswerAnimation
            target: colorLayer
            properties: "opacity"
            from: 0
            to: 0.4
            duration: 2000
            onStarted: {
                multipleStaff.pauseNoteAnimation()
                addNoteTimer.pause()
                messageBox.visible = true
                colorLayer.color = "red"
            }
            onStopped: {
                messageBox.visible = false
                colorLayer.color = "black"
                if(Activity.noteIndexToDisplay >= Activity.newNotesSequence.length) {
                    addNoteTimer.triggeredOnStart = true
                }
                Activity.wrongAnswer()
                addNoteTimer.resume()
            }
        }

        Rectangle {
            id: messageBox
            width: label.width + 20
            height: label.height + 20
            border.width: 5
            border.color: "black"
            anchors.centerIn: multipleStaff
            radius: 10
            z: 11
            visible: false
            onVisibleChanged: text = Activity.targetNotes[0] == undefined ? ""
                                                                       : items.isTutorialMode ? qsTr("New note: %1").arg(Activity.targetNotes[0])
                                                                       : Activity.newNotesSequence[Activity.currentNoteIndex]
            Behavior on visible {
                SequentialAnimation {
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: messageBox
                        property: "scale"
                        to: 0.85
                        duration: 700
                    }
                    NumberAnimation {
                        target: messageBox
                        property: "scale"
                        to: 1
                        duration: 700
                    }
                }
            }

            property string text

            GCText {
                id: label
                anchors.centerIn: parent
                fontSize: mediumSize
                text: parent.text
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
            color: "black"
            opacity: 0.3
            visible: iAmReady.visible || wrongAnswerAnimation.running
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

        AdvancedTimer {
            id: addNoteTimer
            onTriggered: {
                if(Activity.newNotesSequence[++Activity.noteIndexToDisplay] != undefined) {
                    Activity.displayNote(Activity.newNotesSequence[Activity.noteIndexToDisplay])
                }
            }
        }

        ProgressBar {
            id: progressBar
            height: 20 * ApplicationInfo.ratio
            width: parent.width / 4

            readonly property real percentage: 0
            readonly property string message: qsTr("%1%").arg(value)

            value: Math.round(percentage * 10) / 10
            maximumValue: 100
            visible: !items.isTutorialMode
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 10
            }

            GCText {
                anchors.centerIn: parent
                fontSize: mediumSize
                font.bold: true
                color: "black"
                text: parent.message
                z: 2
            }

            function updatePercentage(isTargetNote, isCorrectAnswer) {
                var newNotesRemSequenceLength = Activity.newNotesSequence.length - Activity.currentNoteIndex
                var nbTargetNotes = 0
                for(var i = Activity.currentNoteIndex; i < Activity.newNotesSequence.length; i++)
                    if(Activity.targetNotes.indexOf(Activity.newNotesSequence[i]) != -1)
                        nbTargetNotes++;

                if(isCorrectAnswer) {
                    if(isTargetNote)
                        percentage += (2 * (100 - value)) / (nbTargetNotes + newNotesRemSequenceLength)
                    else
                        percentage += (100 - value) / (nbTargetNotes + newNotesRemSequenceLength)
                }
                else {
                    if(isTargetNote)
                        percentage -= (2 * (100 - value)) / (Activity.targetNotes.length + Activity.newNotesSequence.length)
                    else
                        percentage -= (100 - value) / (Activity.targetNotes.length + Activity.newNotesSequence.length)
                }

                if(percentage < 0) {
                    percentage = 0
                }
            }
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.4 : parent.width * 0.76
            height: horizontalLayout ? parent.height * 0.8 : parent.height * 0.59
            nbStaves: 1
            clef: clefType
            coloredNotes: []
            notesColor: "red"
            isMetronomeDisplayed: false
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: progressBar.height + 20
            flickableTopMargin: multipleStaff.height / 14 + distanceBetweenStaff / 2.7
            noteHoverEnabled: false
            noteAnimationEnabled: true
            onNoteAnimationFinished: {
                if(!items.isTutorialMode)
                    wrongAnswerAnimation.start()
            }
        }

        Item {
            id: doubleOctave
            width: horizontalLayout ? 2 * parent.width * 0.3 : parent.width * 0.72
            height: horizontalLayout ? parent.height * 0.26 : 2 * parent.width * 0.21
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 30
            Piano {
                id: piano
                width: horizontalLayout ? parent.width / 2 : parent.width
                height: horizontalLayout ? parent.height : parent.height / 2
                blackLabelsVisible: false
                blackKeysEnabled: blackLabelsVisible
                whiteKeysEnabled: !messageBox.visible
                onNoteClicked: Activity.checkAnswer(note)
                currentOctaveNb: 1
                anchors.bottom: parent.bottom
                whiteNotesBass: [
                    whiteKeyNotes.slice(0, 8),
                    whiteKeyNotes.slice(4, 12),
                    whiteKeyNotes.slice(9, 17)
                ]
                whiteNotesTreble: [
                    whiteKeyNotes.slice(11, 19),
                    whiteKeyNotes.slice(18, 26),
                ]
            }

            Piano {
                id: piano2
                width: piano.width
                height: piano.height
                anchors.top: parent.top
                anchors.topMargin: horizontalLayout ? 0 : -15
                anchors.left: horizontalLayout ? piano.right : parent.left
                blackLabelsVisible: false
                blackKeysEnabled: blackLabelsVisible
                whiteKeysEnabled: !messageBox.visible
                onNoteClicked: Activity.checkAnswer(note)
                currentOctaveNb: piano.currentOctaveNb
                leftOctaveVisible: horizontalLayout
                whiteNotesBass: [
                    whiteKeyNotes.slice(8, 16),
                    whiteKeyNotes.slice(12, 20),
                    whiteKeyNotes.slice(17, 25)
                ]
                whiteNotesTreble: [
                    whiteKeyNotes.slice(19, 27),
                    whiteKeyNotes.slice(26, 34),
                ]
            }
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
                verticalCenter: doubleOctave.verticalCenter
                right: doubleOctave.left
            }
            MouseArea {
                enabled: !messageBox.visible
                anchors.fill: parent
                onClicked: {
                    piano.currentOctaveNb--
                    piano2.currentOctaveNb--
                }
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
                verticalCenter: doubleOctave.verticalCenter
                left: doubleOctave.right
            }
            MouseArea {
                enabled: !messageBox.visible
                anchors.fill: parent
                onClicked: {
                    piano.currentOctaveNb++
                    piano2.currentOctaveNb++
                }
            }
        }

        OptionsRow {
            id: optionsRow
            visible: false
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                multipleStaff.eraseAllNotes()
                iAmReady.visible = true
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
