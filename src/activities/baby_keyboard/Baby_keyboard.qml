/* GCompris - baby_keyboard.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import core 1.0

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
        id: activityBackground
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
            property alias locale: activityBackground.locale
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
            anchors.top: activityBackground.top
            anchors.bottom: bar.top
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right

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
            color: GCStyle.whiteBg
            opacity: 0.5
            width: typedText.contentWidth * 2
            height: typedText.contentHeight
            radius: GCStyle.baseMargins
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
                when: !InputMethod.visible
                AnchorChanges {
                    target: textBG
                    anchors.top: undefined
                    anchors.horizontalCenter: layoutArea.horizontalCenter
                    anchors.verticalCenter: layoutArea.verticalCenter
                }
            },
            State {
                name: "mobileKeyboard"
                when: InputMethod.visible
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
            onClose: activity.home()
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home }
            onHelpClicked: {
                activity.displayDialog(dialogHelp);
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
