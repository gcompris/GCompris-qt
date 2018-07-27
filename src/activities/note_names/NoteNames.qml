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
            property alias dataset: dataset
        }

        Loader {
            id: dataset
            asynchronous: false
            source: "qrc:/gcompris/src/activities/note_names/resource/dataset.qml"
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
                multipleStaff.stopNoteAnimation()
                noteNameLabel.visible = true
                colorLayer.color = "red"
            }
            onStopped: {
                Activity.wrongAnswer()
                noteNameLabel.visible = false
                colorLayer.color = "black"
            }
        }

        Rectangle {
            id: noteNameLabel
            width: multipleStaff.width / 5
            height: width
            border.width: 5
            border.color: "black"
            anchors.centerIn: multipleStaff
            radius: 10
            z: 11
            visible: false
            onVisibleChanged: text = Activity.sequence[0]

            property string text

            GCText {
                anchors.fill: parent
                anchors.rightMargin: parent.width * 0.02
                anchors.leftMargin: parent.width * 0.02
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                text: parent.text
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

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.5 : parent.width * 0.76
            height: horizontalLayout ? parent.height * 0.9 : parent.height * 0.59
            nbStaves: 1
            clef: clefType
            noteIsColored: false
            isMetronomeDisplayed: false
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: horizontalLayout ? 0 : parent.height * 0.02
            flickableTopMargin: multipleStaff.height / 14 + distanceBetweenStaff / 2.7
            noteHoverEnabled: false
            noteAnimationEnabled: true
            onNoteAnimationFinished: wrongAnswerAnimation.start()
        }

        Item {
            id: doubleOctave
            width: horizontalLayout ? 2 * parent.width * 0.3 : parent.width * 0.72
            height: horizontalLayout ? parent.height * 0.3 : 2 * parent.width * 0.232
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 30
            Piano {
                id: piano
                width: horizontalLayout ? parent.width / 2 : parent.width
                height: horizontalLayout ? parent.height : parent.height / 2
                blackLabelsVisible: false
                blackKeysEnabled: blackLabelsVisible
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
                onNoteClicked: Activity.checkAnswer(note)
                currentOctaveNb: piano.currentOctaveNb
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
