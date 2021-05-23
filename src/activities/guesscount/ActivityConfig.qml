/* GCompris - ActivityConfig.qml
 *
* SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property alias modeBox: modeBox
    property int numberOfLevel: 8
    property var adminLevelArr: [["+"],["-"],["/"],["*"],["+","-"],["/","*"],["/","*",'+'],['-',"*","+","/"]]
    width: if(background) background.width

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

        Row {
            id: labels
            spacing: 20
            anchors {
                top: modeBox.bottom
                topMargin: 5
            }
            visible: modeBox.currentIndex == 0
            Repeater {
                model: 2
                Row {
                    spacing: 10
                    Rectangle {
                        id: label
                        width: column.width*0.3
                        height: column.height/3
                        radius: 20.0;
                        color: modelData ? "green" : "red"
                        GCText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            fontSize: smallSize
                            text: modelData ? qsTr("Selected") : qsTr("Not Selected")
                        }
                    }
                }
            }
        }
        Rectangle {
            width: parent.width * 2.5
            color: "transparent"
            height:  parent.height/0.5
            anchors {
                top: labels.bottom
                topMargin: 5
            }
            ListView {
                anchors.fill: parent
                visible: modeBox.currentIndex == 0
                spacing: 5
                model: activityConfiguration.numberOfLevel
                clip: true
                delegate: Admin {
                    id: levels
                    level: modelData
                    width: column.width * 1.2
                    height: column.height / 1.5

                    Connections {
                        target: activityConfiguration
                        onRefreshAdmin: levels.refreshAllTiles();
                    }
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
