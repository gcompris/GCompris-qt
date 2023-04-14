/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property bool easyMode: true
    width: flick.width

    Column {
        id: column
        spacing: 10
        width: parent.width

        GCDialogCheckBox {
            id: easyModeBox
            text: qsTr("Display counters")
            checked: easyMode // This is available in all editors.
            onCheckedChanged: {
                easyMode = checked
            }
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = "true";
        }
        easyModeBox.checked = (dataToSave.mode === "true")
    }

    function saveValues() {
        dataToSave = { "mode": "" + easyMode }
    }
}
