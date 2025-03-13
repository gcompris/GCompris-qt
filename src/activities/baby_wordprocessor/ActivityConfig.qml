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
import core 1.0
import "../../core"

Item {
    id: activityConfiguration
    property Item configBackground
    property bool audioMode: false
    width: flick.width
    height: childrenRect.height

    Column {
        id: column
        spacing: GCStyle.baseMargins
        width: parent.width

        GCDialogCheckBox {
            id: audioModeBox
            text: qsTr("Play characters' sound when typed")
            checked: audioMode // This is available in all editors.
            onCheckedChanged: {
                audioMode = checked
            }
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if(dataToSave["audioMode"] === undefined) {
            dataToSave["audioMode"] = "false";
        }
        audioModeBox.checked = (dataToSave.audioMode === "true")
    }

    function saveValues() {
        dataToSave = { "audioMode": "" + audioMode }
    }
}
