/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background

    readonly property string coloredNotes: "coloredNotes"
    readonly property string coloredlessNotes: "colorlessNotes"
    property string mode: coloredNotes
    width: flick.width

    ButtonGroup {
        id: childGroup
    }

    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCDialogCheckBox {
            id: coloredNotesModeBox
            text: qsTr("Display colored notes.")
            checked: activityConfiguration.mode === coloredNotes
            ButtonGroup.group: childGroup
            onCheckedChanged: {
                if(coloredNotesModeBox.checked) {
                    activityConfiguration.mode = coloredNotes
                }
            }
        }

        GCDialogCheckBox {
            id: colorlessNotesModeBox
            text: qsTr("Display colorless notes.")
            checked: activityConfiguration.mode === coloredlessNotes
            ButtonGroup.group: childGroup
            onCheckedChanged: {
                if(colorlessNotesModeBox.checked) {
                    activityConfiguration.mode = coloredlessNotes
                }
            }
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = coloredNotes;
        }
        activityConfiguration.mode = dataToSave["mode"];
        if(activityConfiguration.mode === coloredNotes) {
            coloredNotesModeBox.checked = true
        }
        else {
            colorlessNotesModeBox.checked = true
        }
    }

    function saveValues() {
        dataToSave = {"mode": activityConfiguration.mode};
    }
}
