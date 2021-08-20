/* GCompris - SelectResultsDialog.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2
import CM 1.0

Popup {
    id: selectResultsDialog

    property string label
    property string pupilName: "e1"
    property string activities: "reversecount/Reversecount.qml"

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    signal accepted(string pupilName, string activityName)

    ColumnLayout {
        height: parent.height
        width: parent.width
        spacing: 20

        Text {
            id: labelText

            Layout.preferredHeight: 40
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 20

            text: label
            font.bold: true
            font {
                family: Style.fontAwesome
                pixelSize: 20
            }
        }

        Text {
            id: pupilNameText

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            text: qsTr("Pupil name")
            font.bold: true
            font {
                family: Style.fontAwesome
                pixelSize: 15
            }
        }

        UnderlinedTextInput {
            id: pupilNameTextInput

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            defaultText: selectResultsDialog.pupilName //? here we have a problem, when too long text is going left
        }

        Text {
            id: activityText

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            text: qsTr("Activities")
            font.bold: true
            font {
                family: Style.fontAwesome
                pixelSize: 15
            }
        }

        UnderlinedTextInput {
            id: activityTextInput

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            defaultText: selectResultsDialog.activities //? here we have a problem, when too long text is going left
        }

        // Todo, handle range of date too

        Rectangle {
            id: commandButtonsRectangle
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: saveButton.height + 5

            ViewButton {
                id: saveButton

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: qsTr("Save")
                onClicked: {
                    var currentPupil = pupilNameTextInput.text
                    var currentActivity = activityTextInput.text
                    
                    selectResultsDialog.accepted(currentPupil, currentActivity);
                    selectResultsDialog.close();
                }
            }

            ViewButton {
                id: cancelButton

                anchors.right: saveButton.left
                anchors.bottom: parent.bottom
                text: qsTr("Cancel")

                onClicked: {
                    selectResultsDialog.close();
                }
            }
        }
    }
}
