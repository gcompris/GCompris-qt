/* GCompris - baby_keyboard.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "baby_keyboard.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // When opening a dialog, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusTextInput()
        }
    }

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/menu/resource/background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height

        signal start
        signal stop

        property string locale: ApplicationSettings.locale

        Component.onCompleted: {
            activity.start.connect(start);
            activity.stop.connect(stop);
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property GCAudio audioVoices: activity.audioVoices
            property alias bleepSound: bleepSound
            property alias clickSound: clickSound
            property alias typedText: typedText
            property alias textinput: textinput
            property alias locale: background.locale
            property alias fileId: fileId
        }

        onStart: {
            Activity.start(items);
            keyboard.populate();
            Activity.focusTextInput();
        }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: bleepSound
            source: "qrc:/gcompris/src/core/resource/sounds/bleep.wav"
        }

        GCSoundEffect {
            id: clickSound
            source: "qrc:/gcompris/src/core/resource/sounds/audioclick.wav"
        }

        Item {
            id: layoutArea
            anchors.top: background.top
            anchors.bottom: bar.top
            anchors.left: background.left
            anchors.right: background.right

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textinput.focus = false;
                    textinput.focus = true;
                    textinput.forceActiveFocus();
                }
            }
        }

        Rectangle {
            id: textBG
            visible: typedText.text != ""
            color: "#80ffffff"
            width: typedText.contentWidth * 2
            height: typedText.contentHeight
            radius: 16
        }

        GCText {
            id: typedText
            anchors.centerIn: textBG
            text: ""
            fontSize: 54
            font.bold: true
            color: "#d2611d"
            style: Text.Outline
            styleColor: "white"
        }

        states: [
            State {
                name: "regularKeyboard"
                when: !Qt.inputMethod.visible
                AnchorChanges {
                    target: textBG
                    anchors.top: undefined
                    anchors.horizontalCenter: layoutArea.horizontalCenter
                    anchors.verticalCenter: layoutArea.verticalCenter
                }
            },
            State {
                name: "mobileKeyboard"
                when: Qt.inputMethod.visible
                AnchorChanges {
                    target: textBG
                    anchors.top: layoutArea.top
                    anchors.horizontalCenter: layoutArea.horizontalCenter
                    anchors.verticalCenter: undefined
                }
            }
        ]

        TextEdit {
            id: textinput
            focus: true
            visible: false
            inputMethodHints: Qt.ImhNoPredictiveText
            onTextChanged: {
                if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }
            }
        }

        Keys.onPressed: (event) => {
            Activity.playSound();
        }

        File {
            id: fileId
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home }
            onHelpClicked: {
                displayDialog(dialogHelp);
            }
            onHomeClicked: activity.home();
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            visible: ApplicationSettings.isVirtualKeyboard && !ApplicationInfo.isMobile
            onKeypress: (text) => {
                if(text == backspace || text == newline)
                    Activity.playSound();
                else
                    Activity.processKeyPress(text);
            }
            shiftKey: true
            onError: (msg) => console.log("VirtualKeyboard error: " + msg);
            readonly property string newline: "\u21B2"

            function populate() {
                var tmplayout = [];
                var row = 0;
                var offset = 0;
                var cols;
                var allCharacters = keyboard.allCharacters.split("/")
                var numberOfLetters = allCharacters.length
                while(offset < numberOfLetters-1) {
                    if(numberOfLetters <= 100) {
                        cols = Math.ceil((numberOfLetters-offset) / (3 - row));
                    }
                    else {
                        cols = background.horizontal ? (Math.ceil((numberOfLetters-offset) / (15 - row)))
                        :(Math.ceil((numberOfLetters-offset) / (22 - row)))
                    }

                    tmplayout[row] = [];
                    for (var j = 0; j < cols; j++)
                    tmplayout[row][j] = { label: allCharacters[j+offset] };
                    offset += j;
                    row ++;
                }
                layout = tmplayout
            }
        }
    }

}
