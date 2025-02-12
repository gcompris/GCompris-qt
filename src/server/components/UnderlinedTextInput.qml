/* GCompris - UnderlinedTextInput.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.2

import "../singletons"

Item {
    id: underlinedTextInput

    property string defaultText: "Default text, must be set in calling element"
    property alias text: textInput.text
    property alias echoMode: textInput.echoMode
    property bool readOnlyText: false
    property alias textInput: textInput

    onFocusChanged: { if (focus) textInput.forceActiveFocus(); }

    Rectangle {
        id: underlinePupilNameTextInput
        anchors.fill: parent
        color: readOnlyText ? "transparent" : Style.textInputBackground
        border.color: "lightgray"
        border.width: readOnlyText ? 0 : 1
    }

    TextInput {
        id: textInput

        anchors.fill: parent
        anchors.margins: 3
        text: defaultText
        cursorVisible: false
        echoMode: TextInput.Normal
        font.pixelSize: Style.defaultPixelSize
        selectByMouse: true
        focus: true
        readOnly: readOnlyText
    }
}
