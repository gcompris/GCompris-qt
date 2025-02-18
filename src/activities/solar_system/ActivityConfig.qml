/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item configBackground
    property alias modeBox: modeBox
    width: flick.width
    height: childrenRect.height
    property var availableModes: [
        { "text": qsTr("Learning Mode"), "value": "learning" },
        { "text": qsTr("Assessment Mode"), "value": "assessment" }
    ]
    Column {
        spacing: GCStyle.baseMargins
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            boxBackground: activityConfiguration.configBackground
            label: qsTr("Select your mode")
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = "learning";
            modeBox.currentIndex = 0
        }
        for(var i = 0 ; i < availableModes.length ; i++) {
            if(availableModes[i].value === dataToSave["mode"]) {
                modeBox.currentIndex = i;
                break;
            }
        }
    }

    function saveValues() {
        var newMode = availableModes[modeBox.currentIndex].value;
        dataToSave = {"mode": newMode};
    }
}
