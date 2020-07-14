/* GCompris - ActivityConfig.qml
 *
 * Copyright (C) 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
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
import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property bool easyMode: true
    width: if(background) background.width

    Column {
        id: column
        spacing: 10
        width: parent.width

        GCDialogCheckBox {
            id: easyModeBox
            width: activityConfiguration.width
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
