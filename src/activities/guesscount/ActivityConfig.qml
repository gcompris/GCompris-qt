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
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property alias modeBox: modeBox
    property int numberOfLevel: 8
    property var adminLevelArr: [["+"],["-"],["/"],["*"],["+","-"],["/","*"],["/","*",'+'],['-',"*","+","/"]]
    width: flick.width
    height: childrenRect.height

    signal refreshAdmin

    property var availableModes: [
        { "text": qsTr("Admin"), "value": "admin" },
        { "text": qsTr("BuiltIn"), "value": "builtin" }
    ]

    Column {
        id: column
        spacing: 10 * ApplicationInfo.ratio
        width: activityConfiguration.width
        GCComboBox {
            id: modeBox
            model: availableModes
            background: activityConfiguration.background
            label: qsTr("Select your mode")
            onCurrentIndexChanged: {
                if(currentIndex === 0) {
                    datasetButtonVisible = false
                    optionsVisibleButton.clicked()
                }
                else
                    datasetButtonVisible = true
            }
        }
        Row {
            id: labels
            spacing: 20
            visible: modeBox.currentIndex == 0
            Repeater {
                model: 2
                Rectangle {
                    id: label
                    width: column.width * 0.42
                    height: 32 * ApplicationInfo.ratio
                    radius: 10
                    color: modelData ? "#5cc854" : "#d94444" // green : red
                    GCText {
                        anchors.fill: parent
                        anchors.margins: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSizeMode: Text.Fit
                        fontSize: mediumSize
                        text: modelData ? qsTr("Selected") : qsTr("Not Selected")
                    }
                }
            }
        }
        Column {
            visible: modeBox.currentIndex == 0
            spacing: 10 * ApplicationInfo.ratio
            Repeater {
                model: activityConfiguration.numberOfLevel
                Admin {
                    id: levels
                    level: modelData
                    width: activityConfiguration.width
                    height: 50 * ApplicationInfo.ratio

                    Connections {
                        target: activityConfiguration
                        onRefreshAdmin: levels.refreshAllTiles();
                    }
                }
            }
        }

    }
    property var dataToSave

    function setDefaultValues() {

        if(dataToSave["levelArr"] === undefined) {
            dataToSave["levelArr"] = activityConfiguration.adminLevelArr
        }
        else
            activityConfiguration.adminLevelArr = dataToSave["levelArr"]

        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = "builtin";
            modeBox.currentIndex = 1
        }
        for(var i = 0 ; i < availableModes.length ; i++) {
            if(availableModes[i].value === dataToSave["mode"]) {
                modeBox.currentIndex = i;
                break;
            }
        }
        refreshAdmin()
    }

    function saveValues() {
        var newMode = availableModes[modeBox.currentIndex].value;
        var updatedArr = activityConfiguration.adminLevelArr
        dataToSave = {"mode": newMode, "levelArr": updatedArr};
    }
}
