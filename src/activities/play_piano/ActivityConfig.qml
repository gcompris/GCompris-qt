/* GCompris - ActivityConfig.qml
 *
 * Copyright (C) 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Controls 1.5

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

    Flow {
        id: flow
        spacing: 5
        width: parent.width
        GCDialogCheckBox {
            id: coloredNotesModeBox
            width: flow.width - 50
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
