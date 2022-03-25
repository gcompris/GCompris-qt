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
import QtQuick.Controls 1.5
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background

    readonly property string coloredNotes: "coloredNotes"
    readonly property string coloredlessNotes: "colorlessNotes"
    property string mode: coloredNotes
    width: if(background) background.width

    ExclusiveGroup {
        id: configOptions
    }

    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCDialogCheckBox {
            id: coloredNotesModeBox
            width: parent.width - 50
            text: qsTr("Display colored notes.")
            checked: activityConfiguration.mode === coloredNotes
            exclusiveGroup: configOptions
            onCheckedChanged: {
                if(coloredNotesModeBox.checked) {
                    activityConfiguration.mode = coloredNotes
                }
            }
        }

        GCDialogCheckBox {
            id: colorlessNotesModeBox
            width: coloredNotesModeBox.width
            text: qsTr("Display colorless notes.")
            checked: activityConfiguration.mode === coloredlessNotes
            exclusiveGroup: configOptions
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
