/* GCompris - ExportPupilsDialog.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.12
import QtCore // For StandardPaths
import QtQuick.Dialogs // For FileDialog
import GCompris 1.0

import "../components"
import "../singletons"

Popup {
    id: exportPupilsDialog

    property string pupilsNamesText: ""
    property var pupilsNamesList: []

    signal accepted()

    anchors.centerIn: Overlay.overlay
    width: 800
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    background: Rectangle {
        color: Style.colorBackgroundDialog
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }

    File { id: file }

    function pupilsToCsv() {
        var str= ""
        for (var i = 0; i < exportModel.count ; i++) {
            var user = exportModel.get(i)
            str += `${user.user_name};${user.groups_name};${user.user_password}\n`
        }
        csvOutput.text = str
    }

    ListModel { id: exportModel }

    onAboutToShow: {
        exportModel.clear()
        for(var i = 0 ; i < Master.filteredUserModel.count ; i ++) {
            var user = Master.filteredUserModel.get(i)
            if (user.user_checked)
                exportModel.append(user)
        }
        pupilsToCsv()
    }

    ColumnLayout {
        height: parent.height
        width: parent.width

        Text {
            Layout.fillWidth: true
            height: 40
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Export pupils to CSV file")
            font {
                pixelSize: 20
                bold: true
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: parent.width - 20

            TextArea {
                id: csvOutput
                width: parent.width
                height: parent.height
                wrapMode: Text.Wrap
                clip: true
                readOnly: true
            }
        }

        OkCancelButtons {
            okText: qsTr("Save file")
            onCancelled: exportPupilsDialog.close()
            onValidated: fileDialog.open()
        }

        FileDialog {
            id: fileDialog
            fileMode: FileDialog.SaveFile
            defaultSuffix: "csv"
            currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
            currentFile: currentFolder + "/" + qsTr("Pupils") + "-" + serverSettings.lastLogin + ".csv"
            onAccepted: {
                file.write(csvOutput.text, currentFile)
                exportPupilsDialog.close()
            }
        }
    }
}
