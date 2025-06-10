/* GCompris - ExportPupilsDialog.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic
import QtCore // For StandardPaths
import QtQuick.Dialogs // For FileDialog
import core 1.0

import "../components"
import "../singletons"

Popup {
    id: exportPupilsDialog

    property string pupilsNamesText: ""
    property var pupilsNamesList: []

    signal accepted()

    anchors.centerIn: Overlay.overlay
    width: dialogColumn.childrenRect.width + 2 * padding
    height: dialogColumn.childrenRect.height + 2 * padding
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    // popupType: Popup.Item // TODO: uncomment when min Qt version >= 6.8

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.text
        border.width: Style.defaultBorderWidth
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

    Column {
        id: dialogColumn
        width: 780
        height: childrenRect.height
        anchors.centerIn: parent
        spacing: Style.margins

        DefaultLabel {
            width: parent.width
            height: Style.mediumTextSize
            fontSizeMode: Text.Fit
            font.bold: true
            text: qsTr("Export pupils to CSV file")
        }

        Item {
            width: 1
            height: Style.margins
        }

        ScrollView {
            id: scrollLines
            width: parent.width
            height: 400
            contentWidth: parent.width - Style.bigMargins
            background: Rectangle {
                color: Style.selectedPalette.alternateBase
            }
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.contentItem: Rectangle {
                implicitHeight: 6
                radius: height
                opacity: scrollLines.contentWidth > scrollLines.width ? 0.5 : 0
                color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.text
            }
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.contentItem: Rectangle {
                implicitWidth: 6
                radius: width
                opacity: scrollLines.contentHeight > scrollLines.height ? 0.5 : 0
                color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.text
            }

            TextArea {
                id: csvOutput
                width: parent.contentWidth
                wrapMode: Text.Wrap
                readOnly: true
                color: Style.selectedPalette.text
            }
        }

        OkCancelButtons {
            anchors.horizontalCenter: parent.horizontalCenter
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
