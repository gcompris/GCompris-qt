/* GCompris - ImportPupilsDialog.qml
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
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.12
import QtCore // For StandardPaths
import QtQuick.Dialogs // For FileDialog
import core 1.0

import "../singletons"
import "../components"

Popup {
    id: importPupilsDialog

    anchors.centerIn: Overlay.overlay
    width: 600
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

    onAboutToShow: edit.text = ""

    function pupilsAdd(pupilList) {
        var pupilDetailsLineArray = pupilList.split("\n")
        for (var i = 0; i < pupilDetailsLineArray.length; ++i) {
            if (pupilDetailsLineArray[i].trim() === "")
                continue
            var pupilDetails = pupilDetailsLineArray[i].split(";");
            if(pupilDetails.length > 3) {
                console.warn("Line", pupilDetails, "too long");
            }
            Master.createUser(pupilDetails[0], pupilDetails[2], pupilDetails[1].split(","), [])
        }
        Master.loadUsers()
        Master.filterUsers(Master.filteredUserModel, false)
    }

    ColumnLayout {
        height: parent.height
        width: parent.width

        Text {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Add pupils from CSV file")
            font.bold: true
            color: Style.colorNavigationBarBackground
            font {
                pixelSize: 20
                bold: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "lemonchiffon"
            border.color: "lightgray"
            border.width: 1
            Text {
                anchors.fill: parent
                anchors.margins: 3
                text: qsTr("Format: name;groups;password\nExample:\nPatrick Dummy;group 1;1234\nPatricia Brown;group 1, group 2;4321\n")
                font {
                  pixelSize: 12
                }
            }
        }

        ViewButton {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Add CSV file")
            onClicked: fileDialog.open()
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: parent.width - 20

            TextArea {
                id: edit
                width: parent.width
                height: parent.height
                wrapMode: Text.Wrap
                clip: true
            }
        }

        OkCancelButtons {
            okText: qsTr("Import pupils")
            onCancelled: importPupilsDialog.close()
            onValidated: {
                importPupilsDialog.pupilsAdd(edit.text);
                importPupilsDialog.close();
            }
        }

        FileDialog {
            id: fileDialog
            fileMode: FileDialog.OpenFile
            defaultSuffix: "csv"
            currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
            onAccepted: {
                var str = file.read(currentFile)
                edit.text += str
            }
        }

    }
}
