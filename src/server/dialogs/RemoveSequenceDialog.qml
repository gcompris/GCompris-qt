/* GCompris - RemoveDatasetDialog.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"
import "../components"

Popup {
    id: removeSequenceDialog

    property string sequenceName
    property int sequenceId

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    signal sequenceRemoved()

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
    }

    onAboutToShow: {
        for(var i = 0 ; i < Master.sequenceModel.count ; i ++) {
            var sequence = Master.sequenceModel.get(i)
            if (sequence.sequence_checked === true) {
                sequenceId = sequence.sequence_id
                sequenceName = sequence.sequence_name
            }
        }
    }

    function validateDialog() {
        Master.deleteSequence(removeSequenceDialog.sequenceId)
        sequenceRemoved()
    }

    Item {
        id: focusItem
        anchors.fill: parent

        DefaultLabel {
            id: titleText
            width: parent.width
            height: implicitHeight
            font.pixelSize: Style.textSize
            font.bold: true
            wrapMode: Text.WordWrap
            text: qsTr("Are you sure you want to delete the following sequence from the database?")
        }

        Rectangle {
            id: sequenceNameBgq
            width: parent.width
            anchors.top: titleText.bottom
            anchors.bottom: bottomButtons.top
            anchors.margins: Style.margins
            color: Style.selectedPalette.alternateBase

            DefaultLabel {
                width: parent.width
                height: implicitHeight
                font.pixelSize: Style.textSize
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
                text: removeSequenceDialog.sequenceName
            }
        }

        OkCancelButtons {
            id: bottomButtons
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            onCancelled: removeSequenceDialog.close();
            onValidated: {
                removeSequenceDialog.validateDialog();
                removeSequenceDialog.close();
            }
        }

        Keys.onReturnPressed: bottomButtons.validated();
        Keys.onEscapePressed: bottomButtons.cancelled();
    }
}
