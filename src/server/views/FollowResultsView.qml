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
        anchors.fill: parent
        color: Style.colourBackground
        Text {
            textFormat: Text.StyledText
            anchors.centerIn: parent
            text: currentData ? currentData.toString() : qsTr("Follow Results view")
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
                if(result.goodAnswer === true) {
                    result='<font color="green">'+results[index]+'</font>';
                }
                else {
                    result='<font color="red">'+results[index]+'</font>';
                }
                dataInArray.push(result);
            }
            currentData = dataInArray.join("<br/>");
            selectResultsDialog.close()
        }
    }

    CommandBar {
        commandList: masterController.ui_commandController.ui_followResultViewContextCommands
    }
}
