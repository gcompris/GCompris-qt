/* GCompris - baby_keyboard.qml
 *
 * Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "baby_keyboard.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // When going on configuration, it steals the focus and re set it to the activity.
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
            property GCSfx audioEffects: activity.audioEffects
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

        Rectangle {
            id: layoutArea
            visible: false
            anchors.top: background.top
            anchors.bottom: bar.top
            anchors.left: background.left
            anchors.right: background.right
        }

        states: [
            State {
                name: "baseLayout"
                when: !ApplicationInfo.isMobile
                AnchorChanges {
                    target: typedText
                    anchors.bottom: bar.top
                }
            },
            State {
                name: "mobileLayout"
                when: ApplicationInfo.isMobile
                AnchorChanges {
                    target: typedText
                    anchors.bottom: background.verticalCenter
                }
            }
        ]

        Rectangle {
            anchors.centerIn: typedText
            visible: typedText.text != ""
            color: "#80ffffff"
            width: typedText.contentWidth * 2
            height: typedText.contentHeight
            radius: 16
        }

        GCText {
            id: typedText
            anchors.centerIn: layoutArea
            text: ""
            fontSize: 54
            font.bold: true
            color: "#d2611d"
            style: Text.Outline
            styleColor: "white"
        }

        TextInput {
            id: textinput
            focus: true
            visible: false

            onTextChanged: {
                if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }
            }
        }

        Keys.onPressed: {
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
            onKeypress: {
                if(text == backspace || text == newline)
                    Activity.playSound();
                else
                    Activity.processKeyPress(text);
            }
            shiftKey: true
            onError: console.log("VirtualKeyboard error: " + msg);
            readonly property string newline: "\u21B2"

            function populate() {
                layout = [
                [
                    { label: "0" },
                    { label: "1" },
                    { label: "2" },
                    { label: "3" },
                    { label: "4" },
                    { label: "5" },
                    { label: "6" },
                    { label: "7" },
                    { label: "8" },
                    { label: "9" }
                ],
                [
                    { label: "A" },
                    { label: "B" },
                    { label: "C" },
                    { label: "D" },
                    { label: "E" },
                    { label: "F" },
                    { label: "G" },
                    { label: "H" },
                    { label: "I" }
                ],
                [
                    { label: "J" },
                    { label: "K" },
                    { label: "L" },
                    { label: "M" },
                    { label: "N" },
                    { label: "O" },
                    { label: "P" },
                    { label: "Q" },
                    { label: "R" }
                ],
                [
                    { label: "S" },
                    { label: "T" },
                    { label: "U" },
                    { label: "V" },
                    { label: "W" },
                    { label: "X" },
                    { label: "Y" },
                    { label: "Z" },
                    { label: " " },
                    { label: backspace },
                    { label: newline }
                ]
            ]
            }

        }
    }

}
