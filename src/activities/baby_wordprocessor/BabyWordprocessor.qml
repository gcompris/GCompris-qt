/* GCompris - baby_wordprocessor.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "baby_wordprocessor.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // When going on configuration, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusTextInput();
        }
    }

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: 'white'
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
        }
        onStart: {
            keyboard.populate();
            Activity.start(items);
        }

        onStop: {
            Activity.stop();
        }

        property bool horizontalMode: height <= width
        property bool isLoadingCreation: false
        QtObject {
            id: items
            property alias edit: edit
            property GCAudio audioVoices: activity.audioVoices
            property GCSfx audioEffects: activity.audioEffects
            property alias fileId: fileId
            property bool audioMode: false
            property string locale: ApplicationSettings.locale
        }

        GCCreationHandler {
            id: creationHandler
            onFileLoaded: {
                isLoadingCreation = true
                edit.clear()
                edit.text = data["text"]
                edit.cursorPosition = edit.length
                isLoadingCreation = false
            }
            onClose: {
                Activity.focusTextInput();
                keyboard.hide = false;
            }
        }

        Column {
            id: controls
            width: 120 * ApplicationInfo.ratio
            anchors {
                right: parent.right
                top: parent.top
                margins: 10
            }
            spacing: 10

            GCButton {
                textSize: "title"
                text: qsTr("Title")
                width: parent.width
                onClicked: edit.formatLineWith('h2')
            }
            GCButton {
                textSize: "subtitle"
                text: qsTr("Subtitle")
                width: parent.width
                onClicked: edit.formatLineWith('h3')
            }
            GCButton {
                textSize: "regular"
                width: parent.width
                text: qsTr("Paragraph")
                onClicked: edit.formatLineWith('p')
            }
        }

        Column {
            id: saveAndLoadButtons
            width: controls.width

            property bool isEnoughSpace: {
                if(ApplicationInfo.isMobile && parent.horizontalMode)
                    return false
                return (parent.height - keyboard.height - controls.height) > 2.5 * loadButton.height
            }

            anchors {
                right: !isEnoughSpace ? controls.left : parent.right
                top: !isEnoughSpace ? parent.top : controls.bottom
                margins: 10
            }
            spacing: 10

            GCButton {
                id: loadButton
                textSize: "regular"
                width: parent.width
                text: qsTr("Load")
                onClicked: {
                    keyboard.hide = true;
                    creationHandler.loadWindow();
                }
            }
            GCButton {
                id: saveButton
                textSize: "regular"
                width: parent.width
                text: qsTr("Save")
                onClicked: {
                    keyboard.hide = true;
                    var textToSave = {};
                    // Remove focus to force text storing within the TextEdit
                    edit.focus = false;
                    textToSave["text"] = edit.getFormattedText(0, edit.length);
                    creationHandler.saveWindow(textToSave);
                }
            }
        }

        Flickable {
            id: flick

            anchors {
                left: parent.left
                right: saveAndLoadButtons.left
                top: parent.top
                bottom: bar.top
                margins: 10
            }
            contentWidth: edit.paintedWidth
            contentHeight: edit.paintedHeight
            clip: true
            flickableDirection: Flickable.VerticalFlick

            function ensureVisible(r)
            {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }

            TextEdit {
                id: edit
                width: flick.width
                height: flick.height
                focus: true
                wrapMode: TextEdit.Wrap
                onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                textFormat: TextEdit.RichText
                color: "#373737"
                font {
                    pointSize: (18 + ApplicationSettings.baseFontSize) * ApplicationInfo.fontRatio
                    capitalization: ApplicationSettings.fontCapitalization
                    weight: Font.DemiBold
                    family: GCSingletonFontLoader.fontLoader.name
                    letterSpacing: ApplicationSettings.fontLetterSpacing
                    wordSpacing: 10
                }
                cursorDelegate: Rectangle {
                    id: cursor
                    width: 10
                    // height should be set automatically as mention in cursorRectangle property
                    // documentation but it does not work
                    height: parent.cursorRectangle.height
                    color: '#DF543D'
                    SequentialAnimation on opacity {
                        running: true
                        loops: Animation.Infinite
                        PropertyAnimation {
                            to: 0.2
                            duration: 1000
                        }
                        PropertyAnimation {
                            to: 1
                            duration: 1000
                        }
                    }
                }

                property string previousText: text;
                function getDiffBetweenTexts(previousText, newText) {
                    var diff = "";
                    newText.split('').forEach(function(val, i) {
                        if(val != previousText.charAt(i) && diff === "") {
                            diff = val;
                        }
                    });
                    return diff;
                }

                onTextChanged: {
                    var newText = getText(0, text.length)
                    // if more characters are present, we added a new one and
                    // and wants to play a voice if available
                    if(previousText.length < newText.length && !isLoadingCreation) {
                        var letterTyped = getDiffBetweenTexts(previousText, newText)
                        if(letterTyped !== "") {
                            Activity.playLetter(letterTyped)
                        }
                    }
                    previousText = newText;
                }
                function insertText(text) {
                    edit.insert(cursorPosition, text)
                }
                function backspace() {
                    if(cursorPosition > 0) {
                        moveCursorSelection(cursorPosition - 1, TextEdit.SelectCharacters)
                        cut()
                    }
                }
                function newline() {
                    insert(cursorPosition, "<br></br>")
                }
                function formatLineWith(tag) {
                    var text = getText(0, length)
                    var initialPosition = cursorPosition
                    var first = cursorPosition - 1
                    for(; first >= 0; first--) {
                        if(text.charCodeAt(first) === 8233)
                            break
                    }
                    first++
                    var last = cursorPosition
                    for(; last < text.length; last++) {
                        if(text.charCodeAt(last) === 8233)
                            break
                    }
                    var line = getText(first, last)
                    remove(first, last)
                    insert(first, '<' + tag + '>' + line + '</' + tag + '>')
                    cursorPosition = initialPosition
                }
            }
        }

        File {
            id: fileId
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: {
                home()
            }
            onLoadData: {
                if(activityData && activityData["audioMode"]) {
                   items.audioMode = activityData["audioMode"] === "true" ? true : false;
                }
            }
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | reload | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
            onReloadClicked: edit.text = ''
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig);
            }

        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            visible: ApplicationSettings.isVirtualKeyboard && !ApplicationInfo.isMobile && !hide
            onKeypress: {
                if(text == backspace) {
                    edit.backspace();
                }
                else if(text == newline) {
                    edit.newline();
                }
                else {
                    edit.insertText(text);
                }
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
