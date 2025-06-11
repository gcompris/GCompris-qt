/* GCompris - UnderlinedTextInput.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Layouts

import "../singletons"

Item {
    id: underlinedTextInput
    height: Style.textInputHeight

    property string defaultText: "Default text, must be set in calling element"
    property alias text: textInput.text
    property alias echoMode: textInput.echoMode
    property bool readOnlyText: false
    property alias textInput: textInput

    onFocusChanged: { if (focus) textInput.forceActiveFocus(); }

    Rectangle {
        id: underlinePupilNameTextInput
        anchors.fill: parent
        color: Style.selectedPalette.alternateBase
        opacity: underlinedTextInput.readOnlyText ? 0.5 : 1
        border.color: Style.selectedPalette.accent
        border.width: underlinedTextInput.readOnlyText ? 0 : 1
    }

    TextInput {
        id: textInput
        color: Style.selectedPalette.text
        selectedTextColor: Style.selectedPalette.highlightedText
        selectionColor: Style.selectedPalette.highlight
        anchors {
            fill: parent
            leftMargin: Style.margins
            rightMargin: Style.margins
        }
        clip: true
        font.pixelSize: Style.textSize
        font.bold: true
        verticalAlignment: TextInput.AlignVCenter
        cursorVisible: false
        echoMode: TextInput.Normal
        selectByMouse: true
        focus: true
        readOnly: readOnlyText
        text: defaultText
    }
}
