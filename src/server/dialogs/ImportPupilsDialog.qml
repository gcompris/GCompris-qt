/* GCompris - ImportPupilsDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
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

import "../singletons"
import "../components"

Popup {
    id: importPupilsDialog

    anchors.centerIn: Overlay.overlay
    width: Overlay.overlay.width
    height: Overlay.overlay.height
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

    Column {
        id: topColumn
        width: parent.width
        height: childrenRect.height
        spacing: Style.margins

        DefaultLabel {
            width: parent.width
            height: Style.mediumTextSize
            fontSizeMode: Text.Fit
            font.bold: true
            text: qsTr("Import pupils from CSV file")
        }

        Item {
            height: Style.margins
            width: 1
        }

        Rectangle {
            width: parent.width
            height: exampleText.height + Style.bigMargins
            color: Style.selectedPalette.alternateBase
            Text {
                id: exampleText
                width: parent.width - Style.bigMargins
                anchors.centerIn: parent
                font.pixelSize: Style.textSize
                color: Style.selectedPalette.text
                text: qsTr("Format: name;groups;password\nExample:\nPatrick Dummy;group 1;1234\nPatricia Brown;group 1,group 2;4321\n")
            }
        }

        ViewButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Add CSV file")
            onClicked: fileDialog.open()
        }
    }

    ScrollView {
        id: scrollLines
        width: parent.width
        anchors.top: topColumn.bottom
        anchors.bottom: bottomButtons.top
        anchors.margins: Style.margins
        contentWidth: width - Style.bigMargins
        background: Rectangle {
            color: Style.selectedPalette.alternateBase
            border.color: Style.selectedPalette.accent
            border.width: 1
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
            id: edit
            width: parent.contentWidth
            wrapMode: Text.Wrap
            color: Style.selectedPalette.text
            selectionColor: Style.selectedPalette.highlight
            selectedTextColor: Style.selectedPalette.highlightedText
            font.pixelSize: Style.textSize
        }
    }

    OkCancelButtons {
        id: bottomButtons
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
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
