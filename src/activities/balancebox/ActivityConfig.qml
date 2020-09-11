/* GCompris - ActivityConfig.qml
 *
* Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
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
import GCompris 1.0
import QtQuick.Controls 1.5

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    width: if(background) background.width
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

        Button {
            id: editorButton
            style:  GCButtonStyle {}
            height: levelsBox.height
            text: enabled ? qsTr("Start the editor") : qsTr("Start the activity to access the editor")
            visible: levelsBox.currentIndex == 1
            enabled: !dialogChooseLevel.inMenu
            onClicked: startEditor()
        }

        Button {
            id: loadButton
            style:  GCButtonStyle {}
            height: levelsBox.height
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
