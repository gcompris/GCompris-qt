/* GCompris - baby_wordprocessor.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
        onStart: edit.forceActiveFocus();

        Flickable {
            id: flick

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: bar.top
                margins: 10
            }
            contentWidth: edit.paintedWidth
            contentHeight: edit.paintedHeight
            clip: true

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
                font {
                    pointSize: 38
                    capitalization: Font.AllUppercase
                    bold: true
                    letterSpacing: 5
                    wordSpacing: 10
                }
                cursorDelegate: Rectangle {
                    width: 10
                    color: 'red'
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
            onKeypress: {
                if(text == backspace)
                    edit.backspace()
                else
                    edit.insertText(text)
            }
            onError: console.log("VirtualKeyboard error: " + msg);
            layout: [
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
                    { label: backspace }
                ]
            ]
        }

    }

}
