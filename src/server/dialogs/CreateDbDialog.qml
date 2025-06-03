/* GCompris - CreateDbDialog.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Basic
import core 1.0
import "../components"
import "../singletons"

Popup {
    id: createDbDialog
    property var message: [ qsTr("You are about to create a new GCompris database") ]
    anchors.centerIn: Overlay.overlay
    width: 550
    height: 330
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
            topBanner.visible = true
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
        radius: 5
        border.color: "black"
        border.width: 4
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Text {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("New database creation")
            font {
                bold: true
                pixelSize: 20
            }
            color: Style.selectedPalette.text
        }

        Repeater {
            model: createDbDialog.message
            Text {
                Layout.fillWidth: true
                height: 40
                horizontalAlignment: Text.AlignHCenter
                text: createDbDialog.message[index]
                color: Style.selectedPalette.text
            }
        }

        Text {
            id: loginLabel
            Layout.preferredHeight: 20
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Teacher login")
            font.bold: true
            font {
                pixelSize: 15
            }
            color: Style.selectedPalette.text
        }

        UnderlinedTextInput {
            id: login
            Layout.preferredHeight: Style.lineHeight
            Layout.fillWidth: true
            Layout.leftMargin: 100
            Layout.rightMargin: 100
            activeFocusOnTab: true
            focus: true
            defaultText: serverSettings.lastLogin
            onTextChanged: {
//                serverSettings.lastLogin = text
                createDbDialog.message.text = ""
            }
        }

        Text {
            id: passwordLabel
            Layout.preferredHeight: 20
            Layout.fillWidth: true
            // anchors.horizontalCenter: parent.center
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Password")
            font.bold: true
            font {
                pixelSize: 15
            }
            color: Style.selectedPalette.text
        }

        UnderlinedTextInput {
            id: password
            Layout.preferredHeight: Style.lineHeight
            Layout.fillWidth: true
            Layout.leftMargin: 100
            Layout.rightMargin: 100
            activeFocusOnTab: true
            echoMode: TextInput.Password
            defaultText: serverSettings.lastLogin
        }

        StyledCheckBox {
            id: crypted
            Layout.fillWidth: true
            Layout.leftMargin: 100
            Layout.rightMargin: 100
            text: qsTr("Encrypted database (default will be yes)")
            checked: true
        }

        OkCancelButtons {
            onCancelled: createDbDialog.close()
            onValidated: createDatabaseFile()
        }
    }
}
