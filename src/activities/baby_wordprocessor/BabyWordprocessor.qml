/* GCompris - baby_wordprocessor.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import QtQuick.Controls 1.5

import "../../core"

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: 'white'
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
        }
        onStart: {
            keyboard.populate();
            edit.forceActiveFocus();
        }

        property bool horizontalMode: height <= width

        GCCreationHandler {
            id: creationHandler
            onFileLoaded: {
                edit.clear()
                edit.text = data["text"]
                edit.cursorPosition = edit.length
            }
            onClose: edit.forceActiveFocus()
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

            Button {
                style: GCButtonStyle { textSize: "title"}
                text: qsTr("Title")
                width: parent.width
                onClicked: edit.formatLineWith('h2')
            }
            Button {
                style: GCButtonStyle { textSize: "subtitle"}
                text: qsTr("Subtitle")
                width: parent.width
                onClicked: edit.formatLineWith('h3')
            }
            Button {
                style: GCButtonStyle { textSize: "regular"}
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

            Button {
                id: loadButton
                style: GCButtonStyle { textSize: "regular"}
                width: parent.width
                text: qsTr("Load")
                onClicked: {
                    creationHandler.loadWindow()
                }
            }
            Button {
                id: saveButton
                style: GCButtonStyle { textSize: "regular"}
                width: parent.width
                text: qsTr("Save")
                onClicked: {
                    var textToSave = {}
                    textToSave["text"] = edit.getFormattedText(0, edit.length)
                    creationHandler.saveWindow(textToSave)
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
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
            onReloadClicked: edit.text = ''
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            visible: ApplicationSettings.isVirtualKeyboard && !ApplicationInfo.isMobile
            onKeypress: {
                if(text == backspace)
                    edit.backspace()
                else if(text == newline)
                    edit.newline()
                else
                    edit.insertText(text)
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
