/* GCompris - CreateClientView.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../components"
import "../../core"
import QtQuick.Controls 2.12
import "."


Item {
    property var currentData

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: headerText.height
        color: Style.colourBackground
        Text {
            id: headerText
            anchors.horizontalCenter: parent.horizontalCenter
            textFormat: Text.StyledText
            text: qsTr("Follow Results view")
        }
    }

    ListView {
        anchors.top: header.bottom
        anchors.bottom: commandBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        model: currentData
        delegate: Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: new Date(modelData.date) + ": " + modelData.goodAnswer
            color: modelData.goodAnswer ? "green": "red"
        }
    }

    Connections {
        target: masterController.ui_navigationController
        onGoShowPupilActivitiesDataDialog: selectResultsDialog.open()
    }

    SelectResultsDialog {
        id: selectResultsDialog

        label: qsTr("Select a pupil, the activity and the range")

        onAccepted: {
            console.log("selected", pupilName, activityName)
            // todo fetch from database. At some point, do we want a local cache?
            var results = masterController.getActivityData(pupilName, activityName)
            var dataInArray = new Array();
            for(var index in results) {
                var result = JSON.parse(results[index]);
                dataInArray.push(result);
            }
            currentData = dataInArray;
            selectResultsDialog.close()
        }
    }

    CommandBar {
        id: commandBar
        commandList: masterController.ui_commandController.ui_followResultViewContextCommands
    }
}
