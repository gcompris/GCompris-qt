/* GCompris - ActivityConfig.qml
 *
* SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item configBackground
    property bool useDefaultHole: true
    width: flick.width
    height: childrenRect.height

    Column {
        spacing: GCStyle.baseMargins
        width: activityConfiguration.width
        GCDialogCheckBox {
            id: defaultHoleBox
            text: qsTr("Use the default starting hole")
            checked: activityConfiguration.useDefaultHole
            onCheckedChanged: {
                activityConfiguration.useDefaultHole = checked;
            }
        }
    }

    property var dataToSave
    function setDefaultValues() {
        if(dataToSave["useDefaultHole"] === undefined) {
            dataToSave["useDefaultHole"] = "true";
        }
        defaultHoleBox.checked = (dataToSave.useDefaultHole === "true")
    }

    function saveValues() {
        dataToSave = { "useDefaultHole": "" + activityConfiguration.useDefaultHole }
    }
}
