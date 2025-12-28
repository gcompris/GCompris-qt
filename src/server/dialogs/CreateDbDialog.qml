/* GCompris - CreateDbDialog.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic
import core 1.0
import "../components"
import "../singletons"

Popup {
    id: createDbDialog
    property var message: [ qsTr("You are about to create a new GCompris database.") ]
    anchors.centerIn: Overlay.overlay
    width: 600
    height: layoutColumn.height + Style.hugeMargins
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    function createDatabaseFile() {
        serverSettings.lastLogin = login.text
        var fileName = userDataPath + "/" + databaseFile
        console.warn(fileName)
        if (!Master.fileExists(fileName)) {
            Master.loadDatabase(fileName);
            console.warn("Create teacher:", login.text);
            Master.createTeacher(login.text, password.text, crypted.checked)
            Master.initialize()
            navigationBar.enabled = true
            navigationBar.startNavigation(navigationBar.pupilsView)
        }
        errorDialog.message = [ qsTr("Database file") +
                " <b>" + databaseFile + "</b> " +
                qsTr("created in:") + "<br>" +
                userDataPath ]
        errorDialog.open()
        createDbDialog.close()
    }

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
    }

    Column {
        id: layoutColumn
        anchors.centerIn: parent
        width: parent.width - Style.hugeMargins
        height: childrenRect.height
        spacing: Style.margins

        DefaultLabel {
            width: parent.width
            height: Style.mediumTextSize
            wrapMode: Text.WordWrap
            text: qsTr("New database creation")
            font.bold: true
        }

        Item {
            height: Style.margins
            width: parent.width
        }

        Repeater {
            model: createDbDialog.message

            DefaultLabel {
                width: layoutColumn.width
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                text: createDbDialog.message[index]
            }
        }

        Item {
            height: Style.margins
            width: parent.width
        }

        DefaultLabel {
            id: loginLabel
            width: parent.width
            text: qsTr("Teacher login")
            font.bold: true
        }

        UnderlinedTextInput {
            id: login
            height: Style.lineHeight
            width: parent.width
            activeFocusOnTab: true
            focus: true
            defaultText: serverSettings.lastLogin
//             onTextChanged: {
// //                serverSettings.lastLogin = text
//                 createDbDialog.message.text = ""
//             }
        }

        DefaultLabel {
            id: passwordLabel
            width: parent.width
            text: qsTr("Password")
            font.bold: true
        }

        UnderlinedTextInput {
            id: password
            height: Style.lineHeight
            width: parent.width
            activeFocusOnTab: true
            echoMode: TextInput.Password
            defaultText: serverSettings.lastLogin
        }

        StyledCheckBox {
            id: crypted
            width: parent.width
            text: qsTr("Encrypted database (enabled by default)")
            checked: true
        }

        OkCancelButtons {
            id: okCancelButtons
            buttonsWidth:(parent.width - Style.margins) * 0.5
            onCancelled: createDbDialog.close()
            onValidated: createDatabaseFile()
        }
    }
}
