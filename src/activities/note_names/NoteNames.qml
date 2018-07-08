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
            property alias score: score
            property alias bonus: bonus
            property alias iAmReady: iAmReady
            property alias wrongAnswerAnimation: wrongAnswerAnimation
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
            duration: 500
            onStarted: colorLayer.color = "red"
            onStopped: {
                Activity.wrongAnswer()
                colorLayer.color = "black"
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

        Score {
            id: score
            anchors.top: background.top
            anchors.bottom: undefined
            numberOfSubLevels: 3
            width: horizontalLayout ? parent.width / 10 : (parent.width - multipleStaff.x - multipleStaff.width)
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.5 : parent.width * 0.76
            height: horizontalLayout ? parent.height * 0.9 : parent.height * 0.59
            nbStaves: 1
            clef: clefType
            noteIsColored: true
            isMetronomeDisplayed: false
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: horizontalLayout ? parent.height * 0.03 : parent.height * 0.1
            noteHoverEnabled: false
            noteAnimationEnabled: true
            onNoteAnimationFinished: wrongAnswerAnimation.start()
        }

        Piano {
            id: piano
            width: horizontalLayout ? parent.width * 0.4 : parent.width * 0.7
            height: horizontalLayout ? parent.height * 0.3 : parent.width * 0.26
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 30
            blackLabelsVisible: ([5, 6, 7, 8, 9, 10, 11, 12, 15, 16, 17, 18].indexOf(items.bar.level) != -1)
            useSharpNotation: ([5, 6, 7, 8, 15, 16].indexOf(items.bar.level) != -1)
            blackKeysEnabled: blackLabelsVisible
            onNoteClicked: Activity.checkAnswer(note)
            currentOctaveNb: 0
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
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
