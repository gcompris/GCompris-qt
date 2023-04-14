/* GCompris - ActivityConfig.qml
 *
* SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    width: flick.width
    height: childrenRect.height
    property alias levelsBox: levelsBox
    property string loadedFilePath: ""
    property var availableLevels: [
        { "text": qsTr("Built-in"), "value": "builtin" },
        { "text": qsTr("User"), "value": "user" },
    ]

    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCComboBox {
            id: levelsBox
            model: availableLevels
            background: activityConfiguration.background
            label: qsTr("Select your level set")
        }

        GCButton {
            id: editorButton
            height: 50 * ApplicationInfo.ratio
            width: Math.min(parent.width, implicitWidth)
            text: enabled ? qsTr("Start the editor") : qsTr("Start the activity to access the editor")
            visible: levelsBox.currentIndex == 1
            enabled: !dialogChooseLevel.inMenu
            onClicked: startEditor()
        }

        GCButton {
            id: loadButton
            height: 50 * ApplicationInfo.ratio
            width: Math.min(parent.width, implicitWidth)
            text: enabled ? qsTr("Load saved levels") : qsTr("Start the activity to load your levels")
            visible: levelsBox.currentIndex == 1
            enabled: !dialogChooseLevel.inMenu
            onClicked: creationHandler.loadWindow()
        }
    }

    function startEditor() {
        editorLoader.active = true;
        displayDialog(editorLoader.item);
    }

    property var dataToSave
    function setDefaultValues() {
        if(dataToSave["levels"] === undefined) {
            dataToSave["levels"] = "builtin";
            levelsBox.currentIndex = 0;
        }
        for(var i = 0 ; i < availableLevels.length ; i++) {
            if(availableLevels[i].value === dataToSave["levels"]) {
                levelsBox.currentIndex = i;
                break;
            }
        }
        if(dataToSave["filePath"] != undefined)
            activityConfiguration.loadedFilePath = dataToSave["filePath"];
    }

    function saveValues() {
        var newLevels = availableLevels[levelsBox.currentIndex].value;
        if(!dialogChooseLevel.inMenu)
            activityConfiguration.loadedFilePath = activity.loadedFilePath;
        dataToSave = {"levels": newLevels, "filePath": activityConfiguration.loadedFilePath};
        console.log("file path is " + activityConfiguration.loadedFilePath);
    }
}
